import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

/// Service pour optimiser les images avant le traitement ML
/// Inclut des optimisations spécifiques pour la reconnaissance d'écriture manuscrite
class ImageProcessor {
  static const int maxWidth = 1600;
  static const int maxHeight = 1600;
  static const int quality = 85; // Qualité plus élevée pour l'OCR

  /// Compresse une image pour accélérer le traitement ML Kit
  /// Réduit la taille tout en gardant une qualité suffisante pour l'OCR
  Future<File> compressImage(String imagePath) async {
    try {
      final file = File(imagePath);

      // Vérifier si le fichier existe
      if (!await file.exists()) {
        return file;
      }

      // Vérifier la taille du fichier
      final fileSize = await file.length();

      // Si l'image est déjà petite (<500KB), pas besoin de compresser
      if (fileSize < 500 * 1024) {
        return file;
      }

      // Créer un nom de fichier temporaire
      final tempDir = await getTemporaryDirectory();
      final targetPath = path.join(
        tempDir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      // Compresser l'image
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: maxWidth,
        minHeight: maxHeight,
        format: CompressFormat.jpeg,
      );

      if (result != null) {
        final compressedFile = File(result.path);
        final compressedSize = await compressedFile.length();

        // Log pour debug
        print('Image compression: ${fileSize / 1024}KB → ${compressedSize / 1024}KB');

        return compressedFile;
      }

      // Si la compression échoue, retourner l'original
      return file;
    } catch (e) {
      print('Erreur lors de la compression: $e');
      // En cas d'erreur, retourner l'image originale
      return File(imagePath);
    }
  }

  /// Prétraite une image pour améliorer la reconnaissance d'écriture manuscrite
  /// Applique: conversion en niveaux de gris, amélioration du contraste, 
  /// seuillage adaptatif, et réduction du bruit
  Future<File> preprocessForHandwriting(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        return file;
      }

      // Lire l'image
      final bytes = await file.readAsBytes();
      final originalImage = img.decodeImage(bytes);
      
      if (originalImage == null) {
        print('Impossible de décoder l\'image');
        return file;
      }

      // 1. Redimensionner si nécessaire (garder une bonne résolution pour l'OCR)
      img.Image processed = originalImage;
      if (processed.width > maxWidth || processed.height > maxHeight) {
        processed = img.copyResize(
          processed,
          width: processed.width > processed.height ? maxWidth : null,
          height: processed.height >= processed.width ? maxHeight : null,
          interpolation: img.Interpolation.linear,
        );
      }

      // 2. Convertir en niveaux de gris
      processed = img.grayscale(processed);

      // 3. Améliorer le contraste (normalisation d'histogramme)
      processed = _enhanceContrast(processed);

      // 4. Appliquer un léger flou gaussien pour réduire le bruit
      processed = img.gaussianBlur(processed, radius: 1);

      // 5. Affiner les bords (sharpening)
      processed = _sharpen(processed);

      // 6. Désactivé: Le seuillage adaptatif peut perdre des détails fins
      // processed = _adaptiveThreshold(processed);

      // Sauvegarder l'image prétraitée
      final tempDir = await getTemporaryDirectory();
      final outputPath = path.join(
        tempDir.path,
        'handwriting_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      final outputBytes = img.encodePng(processed);
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(outputBytes);

      print('Image prétraitée pour écriture manuscrite: $outputPath');
      return outputFile;
    } catch (e) {
      print('Erreur lors du prétraitement handwriting: $e');
      return File(imagePath);
    }
  }

  /// Améliore le contraste de l'image en utilisant la normalisation
  img.Image _enhanceContrast(img.Image src) {
    // Trouver les valeurs min et max des pixels
    int minVal = 255;
    int maxVal = 0;

    for (int y = 0; y < src.height; y++) {
      for (int x = 0; x < src.width; x++) {
        final pixel = src.getPixel(x, y);
        final gray = img.getLuminance(pixel).toInt();
        if (gray < minVal) minVal = gray;
        if (gray > maxVal) maxVal = gray;
      }
    }

    // Éviter la division par zéro
    if (maxVal == minVal) return src;

    // Normaliser les valeurs
    final range = maxVal - minVal;
    final result = img.Image(width: src.width, height: src.height);

    for (int y = 0; y < src.height; y++) {
      for (int x = 0; x < src.width; x++) {
        final pixel = src.getPixel(x, y);
        final gray = img.getLuminance(pixel).toInt();
        final normalized = ((gray - minVal) * 255 / range).clamp(0, 255).toInt();
        result.setPixel(x, y, img.ColorRgb8(normalized, normalized, normalized));
      }
    }

    return result;
  }

  /// Applique un filtrage de netteté (sharpening)
  img.Image _sharpen(img.Image src) {
    // Kernel de sharpening simple
    final kernel = [
      0, -1, 0,
      -1, 5, -1,
      0, -1, 0,
    ];

    return img.convolution(src, filter: kernel, div: 1);
  }

  /// Applique un seuillage adaptatif pour améliorer le contraste du texte
  img.Image _adaptiveThreshold(img.Image src) {
    final blockSize = 15;
    final c = 10; // Constante à soustraire de la moyenne
    final result = img.Image(width: src.width, height: src.height);

    for (int y = 0; y < src.height; y++) {
      for (int x = 0; x < src.width; x++) {
        // Calculer la moyenne locale
        int sum = 0;
        int count = 0;

        final startY = (y - blockSize ~/ 2).clamp(0, src.height - 1);
        final endY = (y + blockSize ~/ 2).clamp(0, src.height - 1);
        final startX = (x - blockSize ~/ 2).clamp(0, src.width - 1);
        final endX = (x + blockSize ~/ 2).clamp(0, src.width - 1);

        for (int by = startY; by <= endY; by++) {
          for (int bx = startX; bx <= endX; bx++) {
            sum += img.getLuminance(src.getPixel(bx, by)).toInt();
            count++;
          }
        }

        final threshold = (sum / count) - c;
        final pixel = src.getPixel(x, y);
        final gray = img.getLuminance(pixel).toInt();

        // Binariser avec un léger anti-aliasing
        final newValue = gray < threshold ? 0 : 255;
        result.setPixel(x, y, img.ColorRgb8(newValue, newValue, newValue));
      }
    }

    return result;
  }

  /// Prétraite une image avec un traitement plus léger pour les textes imprimés
  /// mais améliore quand même la lisibilité
  Future<File> preprocessForOCR(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        return file;
      }

      final bytes = await file.readAsBytes();
      final originalImage = img.decodeImage(bytes);
      
      if (originalImage == null) {
        return file;
      }

      img.Image processed = originalImage;

      // Redimensionner si nécessaire
      if (processed.width > maxWidth || processed.height > maxHeight) {
        processed = img.copyResize(
          processed,
          width: processed.width > processed.height ? maxWidth : null,
          height: processed.height >= processed.width ? maxHeight : null,
          interpolation: img.Interpolation.linear,
        );
      }

      // Améliorer légèrement le contraste
      processed = img.adjustColor(processed, contrast: 1.2);

      // Légère netteté
      processed = _sharpen(processed);

      final tempDir = await getTemporaryDirectory();
      final outputPath = path.join(
        tempDir.path,
        'ocr_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final outputBytes = img.encodeJpg(processed, quality: 90);
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(outputBytes);

      return outputFile;
    } catch (e) {
      print('Erreur lors du prétraitement OCR: $e');
      return File(imagePath);
    }
  }

  /// Nettoie les fichiers temporaires compressés
  Future<void> cleanupTempFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();

      for (final file in files) {
        if (file is File) {
          final fileName = path.basename(file.path);
          if (fileName.startsWith('compressed_') ||
              fileName.startsWith('handwriting_') ||
              fileName.startsWith('ocr_')) {
            try {
              await file.delete();
            } catch (e) {
              // Ignorer les erreurs de suppression
            }
          }
        }
      }
    } catch (e) {
      print('Erreur lors du nettoyage: $e');
    }
  }
}
