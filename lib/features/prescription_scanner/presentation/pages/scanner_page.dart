import 'package:flutter/material.dart';
import 'package:mediscanhelper/core/constants/app_colors.dart';
import 'package:mediscanhelper/core/constants/app_sizes.dart';
import 'package:mediscanhelper/core/utils/scanner_service.dart';
import 'package:mediscanhelper/l10n/app_localizations.dart';
import 'package:mediscanhelper/features/medications/domain/entities/medication.dart';
import 'package:mediscanhelper/features/medications/presentation/providers/medication_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

/// Page de scanner d'ordonnances - Design moderne amélioré
class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool _isScanning = false;
  String? _extractedText;
  String? _imagePath;
  List<MedicationData>? _detectedMedications;
  final _scannerService = ScannerService();

  @override
  void dispose() {
    _scannerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.grey50, // Removed to use Theme background
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.scanTitle),
        elevation: 0,
        actions: [
          if (_imagePath != null && !_isScanning)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Nouveau scan',
              onPressed: _resetScan,
            ),
        ],
      ),
      body: SafeArea(
        child: _imagePath == null
            ? _buildInitialView()
            : _buildResultView(),
      ),
    );
  }

  /// Vue initiale avec boutons de scan
  Widget _buildInitialView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Illustration centrale animée
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingXl * 1.5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryBlue.withAlpha(26),
                  AppColors.secondaryGreen.withAlpha(26),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.document_scanner_outlined,
                  size: 120,
                  color: AppColors.primaryBlue,
                )
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .scale(
                      duration: const Duration(seconds: 2),
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1.1, 1.1),
                    ),
                const SizedBox(height: AppSizes.spacingL),
                Text(
                  AppLocalizations.of(context)!.scanHeader,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlueDark,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.spacingM),
                Text(
                  AppLocalizations.of(context)!.scanSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey700,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: -0.2, end: 0),

          const SizedBox(height: AppSizes.spacingXl),

          // Conseils
          _buildTipsCard()
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(begin: 0.2, end: 0),

          const SizedBox(height: AppSizes.spacingXl),

          // Titre
          Text(
            AppLocalizations.of(context)!.scanMethodTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey800,
                ),
          ),

          const SizedBox(height: AppSizes.spacingM),

          // Boutons de scan
          if (!_isScanning) ...[
            _buildScanButton(
              icon: Icons.camera_alt,
              title: AppLocalizations.of(context)!.scanTakePhoto,
              subtitle: AppLocalizations.of(context)!.scanCameraSubtitle,
              gradient: const LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.primaryBlueDark],
              ),
              onTap: () => _startScan(useCamera: true),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: AppSizes.spacingM),
            _buildScanButton(
              icon: Icons.photo_library,
              title: AppLocalizations.of(context)!.scanPickImage,
              subtitle: AppLocalizations.of(context)!.scanGallerySubtitle,
              gradient: const LinearGradient(
                colors: [AppColors.secondaryGreen, AppColors.secondaryGreenDark],
              ),
              onTap: () => _startScan(useCamera: false),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 400.ms)
                .slideX(begin: -0.2, end: 0),
          ] else
            _buildScanningIndicator(),
        ],
      ),
    );
  }

  /// Vue avec résultats du scan
  Widget _buildResultView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImageCard(),
          if (_extractedText != null) ...[
            const SizedBox(height: AppSizes.spacingL),
            _buildExtractedTextCard(),
          ],
          if (_detectedMedications != null && _detectedMedications!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacingL),
            _buildDetectedMedicationsCard(),
          ],
          const SizedBox(height: AppSizes.spacingXl),
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// Card de conseils
  Widget _buildTipsCard() {
    return Card(
      elevation: 0,
      color: AppColors.info.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        side: BorderSide(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingS),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
              ),
              child: const Icon(Icons.lightbulb_outline, color: AppColors.info),
            ),
            const SizedBox(width: AppSizes.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.scanTipsTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.info,
                        ),
                  ),
                  const SizedBox(height: AppSizes.spacingS),
                  ...[
                    AppLocalizations.of(context)!.scanTipLight,
                    AppLocalizations.of(context)!.scanTipSharp,
                    AppLocalizations.of(context)!.scanTipFlat,
                    AppLocalizations.of(context)!.scanTipHandwriting
                  ].map((tip) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, size: 16, color: AppColors.info),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(tip, style: Theme.of(context).textTheme.bodySmall),
                                ),
                              ],
                            ),
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bouton de scan personnalisé
  Widget _buildScanButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(AppSizes.radiusL),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: Icon(icon, color: AppColors.white, size: AppSizes.iconL),
              ),
              const SizedBox(width: AppSizes.spacingL),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.white.withAlpha(204),
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppColors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Indicateur de scan
  Widget _buildScanningIndicator() {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXl),
        child: Column(
          children: [
            const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(strokeWidth: 4),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .rotate(duration: 2.seconds),
            const SizedBox(height: AppSizes.spacingL),
            Text(
              AppLocalizations.of(context)!.scanProcessing,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSizes.spacingS),
            Text(
              'Reconnaissance de texte imprimé et manuscrit', // Keep static or add global key? I'll keep it for now as low priority or generic. Wait, "scanSubtitle" is already used for main subtitle. I'll leave it or replace if I have a key. I don't have a specific key for this loading subtitle. I'll leave it for now or use `scanProcessing`.
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Card image scannée
  Widget _buildImageCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusL)),
                child: Image.file(
                  File(_imagePath!),
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 280,
                    color: AppColors.grey200,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 64, color: AppColors.grey500),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: AppSizes.paddingM,
                right: AppSizes.paddingM,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingM,
                    vertical: AppSizes.paddingS,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.success, Color(0xFF2E7D32)],
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: AppColors.white, size: 18),
                      SizedBox(width: 6),
                      Text(
                        AppLocalizations.of(context)!.scanCaptured,
                        style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn()
                    .scale(delay: 300.ms),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryBlue.withAlpha(26),
                  AppColors.secondaryGreen.withAlpha(26),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingS),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withAlpha(51),
                    borderRadius: BorderRadius.circular(AppSizes.radiusS),
                  ),
                  child: const Icon(Icons.description, color: AppColors.primaryBlue),
                ),
                const SizedBox(width: AppSizes.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.scanCapturedTitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.scanCapturedSubtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.grey600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }

  /// Card texte extrait
  Widget _buildExtractedTextCard() {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: const BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusL)),
            ),
            child: Row(
              children: [
                const Icon(Icons.text_fields, color: AppColors.primaryBlue),
                const SizedBox(width: AppSizes.spacingS),
                Text(AppLocalizations.of(context)!.scanExtractedText, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: SingleChildScrollView(
              child: SelectableText(_extractedText!),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 200.ms)
        .slideY(begin: 0.2, end: 0);
  }

  /// Card médicaments détectés
  Widget _buildDetectedMedicationsCard() {
    return Card(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.secondaryGreen.withAlpha(51),
                  AppColors.secondaryGreenLight.withAlpha(51),
                ],
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.medication, color: AppColors.secondaryGreen),
                const SizedBox(width: AppSizes.spacingM),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.scanDetectedMeds(_detectedMedications!.length),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSizes.paddingM),
            itemCount: _detectedMedications!.length,
            itemBuilder: (context, index) {
              final med = _detectedMedications![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.secondaryGreen.withAlpha(51),
                  child: Text('${index + 1}'),
                ),
                title: Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${med.dosage} - ${med.frequency}x/jour'),
              );
            },
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 300.ms)
        .slideY(begin: 0.2, end: 0);
  }

  /// Génère des heures de prise par défaut basées sur la fréquence
  List<TimeOfDay> _generateDefaultTimes(int frequency) {
    // Distribuer les prises sur la journée
    if (frequency == 1) {
      return [const TimeOfDay(hour: 8, minute: 0)]; // Matin
    } else if (frequency == 2) {
      return [
        const TimeOfDay(hour: 8, minute: 0),  // Matin
        const TimeOfDay(hour: 20, minute: 0), // Soir
      ];
    } else if (frequency == 3) {
      return [
        const TimeOfDay(hour: 8, minute: 0),  // Matin
        const TimeOfDay(hour: 13, minute: 0), // Midi
        const TimeOfDay(hour: 20, minute: 0), // Soir
      ];
    } else if (frequency == 4) {
      return [
        const TimeOfDay(hour: 7, minute: 0),
        const TimeOfDay(hour: 12, minute: 0),
        const TimeOfDay(hour: 17, minute: 0),
        const TimeOfDay(hour: 22, minute: 0),
      ];
    } else {
      // Pour plus de 4 prises, distribuer uniformément sur 16h (de 6h à 22h)
      final interval = 16 ~/ frequency;
      return List.generate(frequency, (index) {
        final hour = 6 + (index * interval);
        return TimeOfDay(hour: hour.clamp(0, 23), minute: 0);
      });
    }
  }

  /// Dialogue de confirmation avant l'enregistrement
  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.primaryBlue),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.scanConfirmTitle),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.scanConfirmBody(_detectedMedications!.length)),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _detectedMedications!.map((med) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.medication, size: 16, color: AppColors.primaryBlue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                                '${med.name}\n${med.dosage} - ${med.frequency}x/${AppLocalizations.of(context)!.frequencyDay}',
                                style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: AppColors.info),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.scanScheduleWarning,
                      style: TextStyle(fontSize: 12, color: AppColors.grey700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.medFormCancelBtn),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryGreen,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    ) ?? false;
  }

  /// Boutons d'action
  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _savePrescription,
            icon: const Icon(Icons.save),
            label: Text(AppLocalizations.of(context)!.scanSaveButton, style: const TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryGreen,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.all(AppSizes.paddingL),
              elevation: 4,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 400.ms)
            .slideY(begin: 0.2, end: 0),
        const SizedBox(height: AppSizes.spacingM),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _resetScan,
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context)!.scanNew, style: const TextStyle(fontSize: 16)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              side: const BorderSide(color: AppColors.primaryBlue, width: 2),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 500.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  /// Démarre le scan
  Future<void> _startScan({required bool useCamera}) async {
    setState(() => _isScanning = true);

    try {
      final scanResult = useCamera
          ? await _scannerService.scanFromCamera()
          : await _scannerService.scanFromGallery();

      if (!scanResult.isSuccess) throw Exception(scanResult.errorMessage);

      final text = await _scannerService.extractText(scanResult.imagePath!);
      if (text.isEmpty) throw Exception(AppLocalizations.of(context)!.scanNoText);

      final medications = _scannerService.parseMedications(text);

      setState(() {
        _imagePath = scanResult.imagePath;
        _extractedText = text;
        _detectedMedications = medications;
        _isScanning = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${AppLocalizations.of(context)!.scanDetectedMeds(medications.length)}'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _isScanning = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  /// Réinitialise
  void _resetScan() {
    setState(() {
      _imagePath = null;
      _extractedText = null;
      _detectedMedications = null;
    });
  }

  /// Enregistre
  Future<void> _savePrescription() async {
    if (_detectedMedications == null || _detectedMedications!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.scanNoMedsToSave),
            backgroundColor: AppColors.warning,
          ),
        );
      }
      return;
    }

    // Afficher un dialogue de confirmation avec les détails
    final confirmed = await _showConfirmationDialog();
    if (!confirmed) return;

    setState(() => _isScanning = true);

    try {
      final provider = context.read<MedicationProvider>();
      final uuid = const Uuid();
      final now = DateTime.now();
      int successCount = 0;
      int failureCount = 0;

      // Convertir et ajouter chaque médicament détecté
      for (final medData in _detectedMedications!) {
        try {
          // Générer des heures de prise par défaut basées sur la fréquence
          final times = _generateDefaultTimes(medData.frequency);

          // Calculer la date de fin si une durée est spécifiée
          DateTime? endDate;
          if (medData.durationDays != null) {
            endDate = now.add(Duration(days: medData.durationDays!));
          }

          // Créer l'entité Medication
          final medication = Medication(
            id: uuid.v4(),
            name: medData.name,
            dosage: medData.dosage,
            frequency: medData.frequency,
            times: times,
            startDate: now,
            endDate: endDate,
            expiryDate: null, // Pas d'info d'expiration dans le scan
            barcode: null,
            imagePath: _imagePath, // Utiliser l'image scannée
            isActive: true,
            createdAt: now,
            updatedAt: now,
          );

          // Ajouter le médicament via le provider
          final success = await provider.addNewMedication(medication);
          if (success) {
            successCount++;
          } else {
            failureCount++;
          }
        } catch (e) {
          print('Erreur lors de l\'ajout du médicament ${medData.name}: $e');
          failureCount++;
        }
      }

      setState(() => _isScanning = false);

      if (mounted) {
        // Afficher le résultat
        if (successCount > 0) {
          final message = failureCount == 0
              ? '✅ $successCount médicament(s) ajouté(s) avec succès !'
              : '✅ $successCount/${ _detectedMedications!.length} médicament(s) ajouté(s) ($failureCount échec(s))';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: failureCount == 0 ? AppColors.success : AppColors.warning,
              duration: const Duration(seconds: 3),
            ),
          );

          // Retourner à la page précédente après un court délai si tout s'est bien passé
          if (failureCount == 0) {
            await Future.delayed(const Duration(milliseconds: 800));
            if (mounted) Navigator.of(context).pop(true);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Erreur lors de l\'ajout des médicaments'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isScanning = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
