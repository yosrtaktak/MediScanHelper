import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediscanhelper/core/data/medication_database.dart';
import 'package:mediscanhelper/core/models/medication_database_model.dart';

/// Status of barcode validation
enum BarcodeValidationStatus {
  /// Barcode is valid and found in database
  valid,
  
  /// Barcode is valid format but not found in database
  validNotFound,
  
  /// Barcode format is invalid
  invalid,
  
  /// Error during validation
  error,
}

/// Result of barcode validation
class BarcodeValidationResult {
  final bool isValid;
  final String? barcode;
  final MedicationDatabaseEntry? medication;
  final String? errorMessage;
  final BarcodeValidationStatus status;

  const BarcodeValidationResult({
    required this.isValid,
    this.barcode,
    this.medication,
    this.errorMessage,
    required this.status,
  });

  factory BarcodeValidationResult.valid({
    required String barcode,
    required MedicationDatabaseEntry medication,
  }) {
    return BarcodeValidationResult(
      isValid: true,
      barcode: barcode,
      medication: medication,
      status: BarcodeValidationStatus.valid,
    );
  }

  factory BarcodeValidationResult.validNotFound({
    required String barcode,
  }) {
    return BarcodeValidationResult(
      isValid: true,
      barcode: barcode,
      status: BarcodeValidationStatus.validNotFound,
      errorMessage: 'Médicament non trouvé dans la base de données',
    );
  }

  factory BarcodeValidationResult.invalid({
    required String barcode,
    String? reason,
  }) {
    return BarcodeValidationResult(
      isValid: false,
      barcode: barcode,
      status: BarcodeValidationStatus.invalid,
      errorMessage: reason ?? 'Format de code-barres invalide',
    );
  }

  factory BarcodeValidationResult.error(String message) {
    return BarcodeValidationResult(
      isValid: false,
      status: BarcodeValidationStatus.error,
      errorMessage: message,
    );
  }

  bool get foundInDatabase => medication != null;
}

/// Service for validating barcodes and looking up medication data
class BarcodeValidationService {
  final MedicationDatabase _database;
  final http.Client _client;

  BarcodeValidationService({
    MedicationDatabase? database,
    http.Client? client,
  })  : _database = database ?? MedicationDatabase(),
        _client = client ?? http.Client();

  /// Validates a barcode and looks it up in the medication database or API
  Future<BarcodeValidationResult> validateAndLookup(String barcode) async {
    try {
      // Clean the barcode
      final cleanBarcode = barcode.trim();

      // Validate barcode format
      if (!_isValidBarcodeFormat(cleanBarcode)) {
        return BarcodeValidationResult.invalid(
          barcode: cleanBarcode,
          reason: 'Le code-barres doit contenir entre 8 et 13 chiffres',
        );
      }

      // 1. Look up in local database
      final localMedication = _database.findByBarcode(cleanBarcode);

      if (localMedication != null) {
        return BarcodeValidationResult.valid(
          barcode: cleanBarcode,
          medication: localMedication,
        );
      } 
      
      // 2. Look up in external API
      try {
        final apiMedication = await _lookupFromApi(cleanBarcode);
        if (apiMedication != null) {
          return BarcodeValidationResult.valid(
            barcode: cleanBarcode,
            medication: apiMedication,
          );
        }
      } catch (e) {
        print('API lookup failed: $e');
        // Continue to return not found if API fails
      }

      return BarcodeValidationResult.validNotFound(
        barcode: cleanBarcode,
      );
    } catch (e) {
      return BarcodeValidationResult.error(
        'Erreur lors de la validation: $e',
      );
    }
  }

  /// Looks up medication in UPCitemdb API
  Future<MedicationDatabaseEntry?> _lookupFromApi(String barcode) async {
    try {
      // UPCitemdb API - trial endpoint (free but limited)
      final url = Uri.parse('https://api.upcitemdb.com/prod/trial/lookup?upc=$barcode');
      final response = await _client.get(url);

      print('🔍 UPCitemdb API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        print('📦 API Response: ${data.toString().substring(0, data.toString().length > 200 ? 200 : data.toString().length)}...');
        
        if (data['items'] != null && (data['items'] as List).isNotEmpty) {
          final item = data['items'][0];
          
          String name = item['title'] ?? 'Médicament inconnu';
          String? brand = item['brand'];
          String? description = item['description'];
          
          print('✅ Found product: $name');
          
          return MedicationDatabaseEntry(
            barcode: barcode,
            name: name,
            dosage: _extractDosage(name) ?? _extractDosage(description ?? '') ?? 'Non spécifié',
            manufacturer: brand,
            category: item['category'],
            description: description,
          );
        } else {
          print('❌ No items found in API response');
        }
      } else if (response.statusCode == 404) {
        print('❌ Product not found (404)');
      } else {
        print('❌ API error: ${response.statusCode} - ${response.body}');
      }
      return null;
    } catch (e) {
      print('❌ Error fetching from UPCitemdb API: $e');
      return null;
    }
  }

  /// Extracts dosage from text string
  String? _extractDosage(String text) {
    if (text.isEmpty) return null;
    
    // Patterns pour les dosages courants
    final patterns = [
      RegExp(r'(\d+(?:\.\d+)?\s*(?:mg|g|ml|mcg|UI|%|µg))', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(1)?.trim();
      }
    }
    return null;
  }

  /// Validates barcode format
  /// Accepts common formats: EAN-8, EAN-13, UPC-A, UPC-E, Code-128, etc.
  bool _isValidBarcodeFormat(String barcode) {
    // Remove any whitespace
    final cleaned = barcode.replaceAll(RegExp(r'\s'), '');

    // Check if it's numeric (for EAN/UPC codes)
    final isNumeric = RegExp(r'^\d+$').hasMatch(cleaned);
    
    if (isNumeric) {
      // Common barcode lengths: 8 (EAN-8), 12 (UPC-A), 13 (EAN-13)
      final length = cleaned.length;
      return length >= 8 && length <= 13;
    }

    // For non-numeric barcodes (Code-128, Code-39, etc.)
    // Accept alphanumeric codes between 4 and 20 characters
    final isAlphanumeric = RegExp(r'^[A-Za-z0-9\-]+$').hasMatch(cleaned);
    if (isAlphanumeric) {
      final length = cleaned.length;
      return length >= 4 && length <= 20;
    }

    return false;
  }

  /// Checks if a barcode exists in the database
  bool barcodeExists(String barcode) {
    final cleanBarcode = barcode.trim();
    return _database.findByBarcode(cleanBarcode) != null;
  }

  /// Gets medication by barcode (returns null if not found)
  MedicationDatabaseEntry? getMedicationByBarcode(String barcode) {
    final cleanBarcode = barcode.trim();
    return _database.findByBarcode(cleanBarcode);
  }
}
