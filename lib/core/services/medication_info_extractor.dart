import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Informations extraites d'un médicament
class MedicationInfo {
  final String? name;
  final String? dosage;
  final String? barcode;
  final String? manufacturer;
  final String? activeIngredient;

  const MedicationInfo({
    this.name,
    this.dosage,
    this.barcode,
    this.manufacturer,
    this.activeIngredient,
  });

  bool get hasData => name != null || dosage != null || barcode != null;

  @override
  String toString() {
    return 'MedicationInfo(name: $name, dosage: $dosage, barcode: $barcode)';
  }
}

/// Service pour extraire les informations de médicaments depuis les images
class MedicationInfoExtractor {
  // Singleton recognizer pour réutilisation (plus rapide)
  static final TextRecognizer _sharedTextRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  MedicationInfoExtractor();

  /// Extrait les informations du médicament depuis une image
  Future<MedicationInfo> extractFromImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      return await extractFromImageInputImage(inputImage);
    } catch (e) {
      return const MedicationInfo();
    }
  }

  /// Extrait les informations depuis un InputImage (pour réutilisation)
  Future<MedicationInfo> extractFromImageInputImage(InputImage inputImage) async {
    try {
      final recognizedText = await _sharedTextRecognizer.processImage(inputImage);

      // Extraire les informations du texte
      return _parseMedicationText(recognizedText.text);
    } catch (e) {
      return const MedicationInfo();
    }
  }

  /// Parse le texte reconnu pour extraire les informations
  MedicationInfo _parseMedicationText(String text) {
    final lines = text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

    String? name;
    String? dosage;
    String? manufacturer;
    String? activeIngredient;

    // Patterns pour les médicaments tunisiens
    final dosagePatterns = [
      RegExp(r'(\d+\s*(?:mg|g|ml|mcg|UI|%|µg)(?:/\d+\s*(?:mg|g|ml))?)', caseSensitive: false),
      RegExp(r'(\d+(?:\.\d+)?\s*(?:mg|g|ml|mcg|UI|%|µg))', caseSensitive: false),
    ];

    final manufacturerKeywords = [
      'SIPHAT', 'ADWYA', 'UNIMED', 'STERIPHARMA', 'SAIPH',
      'PHARMAGHREB', 'MEDIS', 'LABOREX', 'OPALIA', 'PFIZER',
      'SANOFI', 'NOVARTIS', 'ROCHE', 'GSK', 'MERCK'
    ];

    // Chercher le nom du médicament (généralement en premier ou en gros caractères)
    // Le nom est souvent le texte le plus long ou en majuscules
    for (int i = 0; i < lines.length && i < 5; i++) {
      final line = lines[i];

      // Skip les très petites lignes
      if (line.length < 3) continue;

      // Le nom est souvent en majuscules et assez long
      if (line.length >= 4 && line == line.toUpperCase() && !_isOnlyNumbers(line)) {
        // Nettoyer le nom (enlever les dosages)
        String cleanName = line;
        for (final pattern in dosagePatterns) {
          cleanName = cleanName.replaceAll(pattern, '').trim();
        }

        if (cleanName.length >= 3 && name == null) {
          name = cleanName;
        }
      }
    }

    // Si pas de nom trouvé, prendre la première ligne significative
    if (name == null && lines.isNotEmpty) {
      for (final line in lines.take(3)) {
        if (line.length >= 4 && !_isOnlyNumbers(line)) {
          String cleanName = line;
          for (final pattern in dosagePatterns) {
            cleanName = cleanName.replaceAll(pattern, '').trim();
          }
          if (cleanName.length >= 3) {
            name = cleanName;
            break;
          }
        }
      }
    }

    // Chercher le dosage
    for (final line in lines) {
      for (final pattern in dosagePatterns) {
        final match = pattern.firstMatch(line);
        if (match != null && dosage == null) {
          dosage = match.group(1)?.trim();
          break;
        }
      }
      if (dosage != null) break;
    }

    // Chercher le fabricant
    for (final line in lines) {
      final upperLine = line.toUpperCase();
      for (final keyword in manufacturerKeywords) {
        if (upperLine.contains(keyword)) {
          manufacturer = line;
          break;
        }
      }
      if (manufacturer != null) break;
    }

    // Chercher la DCI (Dénomination Commune Internationale)
    final dciPattern = RegExp(r'DCI[:\s]*([A-Za-zÀ-ÿ\s]+)', caseSensitive: false);
    for (final line in lines) {
      final match = dciPattern.firstMatch(line);
      if (match != null) {
        activeIngredient = match.group(1)?.trim();
        break;
      }
    }

    // Si on a trouvé la DCI mais pas de nom, utiliser la DCI comme nom
    if (name == null && activeIngredient != null) {
      name = activeIngredient;
    }

    return MedicationInfo(
      name: name,
      dosage: dosage,
      manufacturer: manufacturer,
      activeIngredient: activeIngredient,
    );
  }

  /// Vérifie si une chaîne ne contient que des chiffres et espaces
  bool _isOnlyNumbers(String str) {
    return RegExp(r'^[\d\s\-\.]+$').hasMatch(str);
  }


  /// Ferme le recognizer (méthode statique pour le recognizer partagé)
  void dispose() {
    // Ne rien faire ici car on utilise un recognizer partagé
    // Il sera fermé par disposeShared()
  }

  /// Ferme le recognizer partagé (à appeler à la fin de l'app)
  static void disposeShared() {
    _sharedTextRecognizer.close();
  }
}


/// Résultat du scan de code-barres (extraction uniquement)
class MedicationScanResult {
  final String? barcode;
  final String? barcodeFormat;
  final bool isSuccess;
  final bool isCancelled;
  final String? errorMessage;

  const MedicationScanResult({
    this.barcode,
    this.barcodeFormat,
    this.isSuccess = true,
    this.isCancelled = false,
    this.errorMessage,
  });

  factory MedicationScanResult.success({
    required String barcode,
    String? barcodeFormat,
  }) {
    return MedicationScanResult(
      barcode: barcode,
      barcodeFormat: barcodeFormat,
      isSuccess: true,
    );
  }

  factory MedicationScanResult.cancelled() {
    return const MedicationScanResult(
      isCancelled: true,
      isSuccess: false,
    );
  }

  factory MedicationScanResult.error(String message) {
    return MedicationScanResult(
      isSuccess: false,
      errorMessage: message,
    );
  }

  bool get hasBarcode => barcode != null && barcode!.isNotEmpty;
}

