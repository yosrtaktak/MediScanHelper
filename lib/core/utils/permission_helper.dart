import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

/// Helper pour la gestion des permissions
class PermissionHelper {
  PermissionHelper._();

  /// Demande la permission pour la caméra
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Vérifie si la permission caméra est accordée
  static Future<bool> hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Demande la permission pour le stockage
  static Future<bool> requestStoragePermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true; // iOS gère automatiquement
  }

  /// Vérifie si la permission stockage est accordée
  static Future<bool> hasStoragePermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      return status.isGranted;
    }
    return true;
  }

  /// Demande la permission pour les notifications
  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Vérifie si la permission notification est accordée
  static Future<bool> hasNotificationPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  /// Demande toutes les permissions nécessaires
  static Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
    return await [
      Permission.camera,
      Permission.notification,
      if (defaultTargetPlatform == TargetPlatform.android)
        Permission.storage,
    ].request();
  }

  /// Ouvre les paramètres de l'application
  static Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  /// Vérifie si une permission est définitivement refusée
  static Future<bool> isPermissionPermanentlyDenied(Permission permission) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }
}

