import 'package:flutter/material.dart';
import 'package:mediscanhelper/core/constants/app_colors.dart';
import 'package:mediscanhelper/core/constants/app_sizes.dart';
import 'package:mediscanhelper/core/services/barcode_scanner_service.dart';
import 'package:mediscanhelper/core/services/medication_info_extractor.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Widget pour afficher les options de scan de code-barres
class BarcodeScannerBottomSheet extends StatelessWidget {
  final BarcodeScannerService scannerService;
  final Function(MedicationScanResult result) onMedicationScanned;

  const BarcodeScannerBottomSheet({
    super.key,
    required this.scannerService,
    required this.onMedicationScanned,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppSizes.spacingL),
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Titre
          Row(
            children: [
              const Icon(
                Icons.qr_code_scanner,
                color: AppColors.primaryBlue,
                size: 32,
              ),
              const SizedBox(width: AppSizes.spacingM),
              Text(
                'Scanner un code-barres',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.2, end: 0),

          const SizedBox(height: AppSizes.spacingXl),

          // Option Caméra
          _buildScanOption(
            context: context,
            icon: Icons.camera_alt,
            title: 'Scanner avec la caméra',
            subtitle: 'Prendre une photo du code-barres',
            color: AppColors.primaryBlue,
            onTap: () => _scanWithCamera(context),
          ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideY(begin: 0.2, end: 0),

          const SizedBox(height: AppSizes.spacingM),

          // Option Galerie
          _buildScanOption(
            context: context,
            icon: Icons.photo_library,
            title: 'Choisir depuis la galerie',
            subtitle: 'Sélectionner une image existante',
            color: AppColors.secondaryGreen,
            onTap: () => _scanFromGallery(context),
          ).animate().fadeIn(duration: 300.ms, delay: 200.ms).slideY(begin: 0.2, end: 0),

          const SizedBox(height: AppSizes.spacingM),

          // Bouton Annuler
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              label: const Text('Annuler'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                side: const BorderSide(color: AppColors.grey400),
              ),
            ),
          ).animate().fadeIn(duration: 300.ms, delay: 300.ms).slideY(begin: 0.2, end: 0),

          const SizedBox(height: AppSizes.spacingL),
        ],
      ),
    );
  }

  Widget _buildScanOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusL),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          border: Border.all(color: color.withAlpha(51)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: AppSizes.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.grey600,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey600),
          ],
        ),
      ),
    );
  }

  Future<void> _scanWithCamera(BuildContext context) async {
    // 1. Show loading dialog
    _showLoadingDialog(context);

    // 2. Perform scan
    final result = await scannerService.scanFromCamera();

    // 3. Close loading dialog
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    // 4. Close bottom sheet
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    // 5. Return result via callback
    onMedicationScanned(result);
  }

  Future<void> _scanFromGallery(BuildContext context) async {
    // 1. Show loading dialog
    _showLoadingDialog(context);

    // 2. Perform scan
    final result = await scannerService.scanFromGallery();

    // 3. Close loading dialog
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    // 4. Close bottom sheet
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    // 5. Return result via callback
    onMedicationScanned(result);
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.paddingXl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: AppSizes.spacingM),
                Text('Extraction du code-barres...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fonction helper pour afficher le bottom sheet
void showBarcodeScannerBottomSheet(
  BuildContext context,
  BarcodeScannerService scannerService,
  Function(MedicationScanResult result) onMedicationScanned,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => BarcodeScannerBottomSheet(
      scannerService: scannerService,
      onMedicationScanned: onMedicationScanned,
    ),
  );
}
