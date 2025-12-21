import 'dart:async';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mediscanhelper/core/services/medication_info_extractor.dart';

/// Service pour scanner les codes-barres avec ML Kit
class BarcodeScannerService {
  // Singleton instance pour réutiliser le recognizer (plus rapide)
  static final BarcodeScanner _sharedBarcodeScanner = BarcodeScanner(formats: [BarcodeFormat.all]);

  final ImagePicker _imagePicker;

  // Timeout réduit pour un traitement plus rapide
  static const Duration _processingTimeout = Duration(seconds: 5);

  BarcodeScannerService()
      : _imagePicker = ImagePicker();

  /// Scanne un code-barres depuis la caméra
  Future<MedicationScanResult> scanFromCamera() async {
    try {
      // Vérifier les permissions
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        return MedicationScanResult.error('Permission caméra refusée');
      }

      // Prendre une photo - taille réduite pour traitement ultra-rapide
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 75, // Qualité réduite pour vitesse
        maxWidth: 1024,   // Taille réduite pour scan rapide
        maxHeight: 1024,
      );

      if (image == null) {
        return MedicationScanResult.cancelled();
      }

      // Scanner le code-barres et chercher dans la base de données
      return await _scanImage(image.path);
    } catch (e) {
      return MedicationScanResult.error('Erreur lors du scan: $e');
    }
  }

  /// Scanne un code-barres depuis la galerie
  Future<MedicationScanResult> scanFromGallery() async {
    try {
      // Sélectionner une image
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image == null) {
        return MedicationScanResult.cancelled();
      }

      // Scanner le code-barres et chercher dans la base de données
      return await _scanImage(image.path);
    } catch (e) {
      return MedicationScanResult.error('Erreur lors du scan: $e');
    }
  }

  /// Scanne une image pour détecter les codes-barres
  Future<MedicationScanResult> _scanImage(String imagePath) async {
    try {
      print('🔍 Début du scan barcode...');
      final startTime = DateTime.now();
      
      // Scanner directement l'image sans compression (plus rapide)
      final inputImage = InputImage.fromFilePath(imagePath);
      print('📸 Image chargée en ${DateTime.now().difference(startTime).inMilliseconds}ms');

      // Scanner le code-barres avec timeout réduit
      final scanStart = DateTime.now();
      final List<Barcode> barcodes = await _sharedBarcodeScanner.processImage(inputImage).timeout(
        _processingTimeout,
        onTimeout: () {
          print('⏱️ Timeout après ${_processingTimeout.inSeconds}s');
          return <Barcode>[];
        },
      );
      print('🔎 Scan ML Kit terminé en ${DateTime.now().difference(scanStart).inMilliseconds}ms');

      String? barcodeValue;
      BarcodeFormat? barcodeFormat;

      if (barcodes.isNotEmpty) {
        final barcode = barcodes.first;
        barcodeValue = barcode.displayValue ?? barcode.rawValue;
        barcodeFormat = barcode.format;
        print('✅ Barcode détecté: $barcodeValue');
      } else {
        print('❌ Aucun barcode détecté');
      }

      final totalTime = DateTime.now().difference(startTime).inMilliseconds;
      print('⏱️ Temps total: ${totalTime}ms');

      // Vérifier qu'on a au moins un code-barres
      if (barcodeValue == null) {
        return MedicationScanResult.error(
          'Aucun code-barres détecté. Assurez-vous que l\'image montre clairement le code-barres.'
        );
      }

      return MedicationScanResult.success(
        barcode: barcodeValue,
        barcodeFormat: barcodeFormat != null ? _formatToString(barcodeFormat) : null,
      );
    } on TimeoutException {
      print('❌ Timeout exception');
      return MedicationScanResult.error(
        'Le traitement a pris trop de temps. Essayez avec une image plus claire.'
      );
    } catch (e) {
      print('❌ Erreur: $e');
      return MedicationScanResult.error('Erreur lors de l\'analyse: $e');
    }
  }

  /// Convertit le format de code-barres en string lisible
  String _formatToString(BarcodeFormat format) {
    switch (format) {
      case BarcodeFormat.code128:
        return 'Code 128';
      case BarcodeFormat.code39:
        return 'Code 39';
      case BarcodeFormat.code93:
        return 'Code 93';
      case BarcodeFormat.codabar:
        return 'Codabar';
      case BarcodeFormat.dataMatrix:
        return 'Data Matrix';
      case BarcodeFormat.ean13:
        return 'EAN-13';
      case BarcodeFormat.ean8:
        return 'EAN-8';
      case BarcodeFormat.itf:
        return 'ITF';
      case BarcodeFormat.qrCode:
        return 'QR Code';
      case BarcodeFormat.upca:
        return 'UPC-A';
      case BarcodeFormat.upce:
        return 'UPC-E';
      case BarcodeFormat.pdf417:
        return 'PDF417';
      case BarcodeFormat.aztec:
        return 'Aztec';
      default:
        return 'Autre';
    }
  }

  /// Ferme le scanner et nettoie les ressources
  void dispose() {
    // Les recognizers partagés seront fermés quand l'app se termine
  }

  /// Méthode statique pour fermer les recognizers partagés (à appeler à la fin de l'app)
  static void disposeShared() {
    _sharedBarcodeScanner.close();
  }
}


