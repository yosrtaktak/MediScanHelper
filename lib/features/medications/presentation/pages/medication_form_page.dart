import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediscanhelper/core/constants/app_colors.dart';
import 'package:mediscanhelper/core/constants/app_strings.dart';
import 'package:mediscanhelper/core/constants/app_sizes.dart';
import 'package:mediscanhelper/features/medications/domain/entities/medication.dart';
import 'package:mediscanhelper/features/medications/presentation/providers/medication_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';
import 'package:mediscanhelper/core/services/barcode_scanner_service.dart';
import 'package:mediscanhelper/core/services/barcode_validation_service.dart';
import 'package:mediscanhelper/features/medications/presentation/widgets/barcode_scanner_bottom_sheet.dart';
import 'package:mediscanhelper/injection_container.dart' as di;
import 'package:mediscanhelper/l10n/app_localizations.dart';
import 'package:mediscanhelper/core/utils/feedback_service.dart';

/// Formulaire d'ajout/modification de médicament
class MedicationFormPage extends StatefulWidget {
  final Medication? medication; // null = mode ajout, non-null = mode édition

  const MedicationFormPage({super.key, this.medication});

  @override
  State<MedicationFormPage> createState() => _MedicationFormPageState();
}

class _MedicationFormPageState extends State<MedicationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _barcodeController = TextEditingController();

  late final BarcodeScannerService _scannerService;

  int _frequency = 1;
  List<TimeOfDay> _times = [const TimeOfDay(hour: 8, minute: 0)];
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  DateTime? _expiryDate;
  bool _isActive = true;
  bool _isLoading = false;

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _scannerService = di.sl<BarcodeScannerService>();
    if (widget.medication != null) {
      _initializeWithMedication(widget.medication!);
    }
    // Listen to barcode changes to update suffix icon
    _barcodeController.addListener(() {
      setState(() {});
    });
  }

  void _initializeWithMedication(Medication med) {
    _nameController.text = med.name;
    _dosageController.text = med.dosage;
    _barcodeController.text = med.barcode ?? '';
    _frequency = med.frequency;
    _times = List.from(med.times);
    _startDate = med.startDate;
    _endDate = med.endDate;
    _expiryDate = med.expiryDate;
    _isActive = med.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.medication != null;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? l10n.medFormTitleEdit : l10n.medFormTitleAdd),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingState()
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  children: [
                    _buildInfoCard(),
                    const SizedBox(height: AppSizes.spacingL),
                    _buildBasicInfoSection(),
                    const SizedBox(height: AppSizes.spacingL),
                    _buildScheduleSection(),
                    const SizedBox(height: AppSizes.spacingL),
                    _buildDatesSection(),
                    const SizedBox(height: AppSizes.spacingL),
                    _buildAdditionalInfoSection(),
                    const SizedBox(height: AppSizes.spacingXl),
                    _buildActionButtons(isEditMode),
                    const SizedBox(height: AppSizes.spacingXl),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSizes.spacingL),
          Text(
            l10n.medFormSaving,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        side: BorderSide(color: colorScheme.primary.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: colorScheme.primary),
            const SizedBox(width: AppSizes.spacingM),
            Expanded(
              child: Text(
                l10n.medFormFillInfo,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildBasicInfoSection() {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.medication, color: colorScheme.primary),
                ),
                const SizedBox(width: AppSizes.spacingS),
                Text(
                  l10n.medFormBasicInfo,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingL),

            // Nom
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '${l10n.medFormName} *',
                hintText: 'Ex: Paracétamol',
                prefixIcon: const Icon(Icons.medical_services),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.medFormNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.spacingM),

            // Dosage
            TextFormField(
              controller: _dosageController,
              decoration: InputDecoration(
                labelText: '${l10n.medFormDosage} *',
                hintText: l10n.medFormDosageHint,
                prefixIcon: const Icon(Icons.science),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.medFormDosageRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.spacingM),

            // Statut actif/inactif
            SwitchListTile(
              title: Text(l10n.medFormActive),
              subtitle: Text(
                _isActive ? l10n.medFormActiveDesc : l10n.medFormInactiveDesc,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              value: _isActive,
              onChanged: (value) {
                setState(() => _isActive = value);
              },
              activeColor: colorScheme.primary,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildScheduleSection() {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.access_time, color: colorScheme.secondary),
                ),
                const SizedBox(width: AppSizes.spacingS),
                Text(
                  l10n.medFormFreqAndTimes,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingL),

            // Fréquence
            DropdownButtonFormField<int>(
              initialValue: _frequency,
              decoration: InputDecoration(
                labelText: l10n.medFormFreqLabel,
                prefixIcon: const Icon(Icons.repeat),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
              ),
              items: List.generate(6, (index) => index + 1)
                  .map((freq) => DropdownMenuItem(
                        value: freq,
                        child: Text(l10n.medFormFreqPerDay(freq)),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _frequency = value!;
                  _adjustTimesForFrequency();
                });
              },
            ),
            const SizedBox(height: AppSizes.spacingM),

            // Horaires
            Text(
              l10n.medFormTimesLabel,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSizes.spacingS),

            ..._times.asMap().entries.map((entry) {
              final index = entry.key;
              final time = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.spacingS),
                child: InkWell(
                  onTap: () => _selectTime(index),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      border: Border.all(
                        color: colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.alarm,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: AppSizes.spacingM),
                        Text(
                          '${l10n.medFormTimeIndex(index + 1)}: ${time.format(context)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.edit,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildDatesSection() {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.calendar_today, color: colorScheme.tertiary),
                ),
                const SizedBox(width: AppSizes.spacingS),
                Text(
                  l10n.medFormDatesLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingL),

            // Date de début
            _buildDateField(
              label: '${l10n.medFormStartDate} *',
              value: _startDate,
              onTap: () => _selectStartDate(),
              icon: Icons.play_circle_outline,
            ),
            const SizedBox(height: AppSizes.spacingM),

            // Date de fin
            _buildDateField(
              label: l10n.medFormEndDateOptional,
              value: _endDate,
              onTap: () => _selectEndDate(),
              icon: Icons.stop_circle_outlined,
              canClear: true,
            ),
            const SizedBox(height: AppSizes.spacingM),

            // Date d'expiration
            _buildDateField(
              label: l10n.medFormExpiryDateOptional,
              value: _expiryDate,
              onTap: () => _selectExpiryDate(),
              icon: Icons.event_busy,
              canClear: true,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildAdditionalInfoSection() {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.more_horiz, color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(width: AppSizes.spacingS),
                Text(
                  l10n.medFormAdditionalInfo,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingL),

            // Code-barres
            TextFormField(
              controller: _barcodeController,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  _validateAndFillForm(value);
                }
              },
              decoration: InputDecoration(
                labelText: l10n.medFormBarcodeOptional,
                hintText: l10n.medFormBarcodeHint,
                prefixIcon: const Icon(Icons.qr_code),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_barcodeController.text.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.search, color: colorScheme.primary),
                        tooltip: l10n.searchOpenTooltip,
                        onPressed: () => _validateAndFillForm(_barcodeController.text),
                      ),
                    IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      tooltip: l10n.medFormScan,
                      onPressed: _scanBarcode,
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
    required IconData icon,
    bool canClear = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon: value != null && canClear
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      if (label.contains('fin')) {
                        _endDate = null;
                      } else if (label.contains('expiration')) {
                        _expiryDate = null;
                      }
                    });
                  },
                )
              : const Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
        ),
        child: Text(
          value != null
              ? '${value.day}/${value.month}/${value.year}'
              : l10n.medFormSelectDate,
          style: value != null
              ? null
              : TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isEditMode) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _saveMedication,
            icon: const Icon(Icons.save),
            label: Text(
              isEditMode ? l10n.medFormSaveChanges : l10n.medFormAddBtn,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.all(AppSizes.paddingL),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 500.ms)
            .slideY(begin: 0.2, end: 0),
        const SizedBox(height: AppSizes.spacingM),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.cancel),
            label: Text(
              l10n.medFormCancelBtn,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              side: BorderSide(color: colorScheme.error, width: 2),
              foregroundColor: colorScheme.error,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 600.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  void _adjustTimesForFrequency() {
    if (_times.length < _frequency) {
      // Ajouter des horaires
      while (_times.length < _frequency) {
        final lastTime = _times.last;
        final newHour = (lastTime.hour + 6) % 24;
        _times.add(TimeOfDay(hour: newHour, minute: 0));
      }
    } else if (_times.length > _frequency) {
      // Retirer des horaires
      _times = _times.sublist(0, _frequency);
    }
  }

  Future<void> _selectTime(int index) async {
    final colorScheme = Theme.of(context).colorScheme;
    final time = await showTimePicker(
      context: context,
      initialTime: _times[index],
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: colorScheme.copyWith(
              primary: colorScheme.secondary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _times[index] = time;
      });
    }
  }

  Future<void> _selectStartDate() async {
    final colorScheme = Theme.of(context).colorScheme;
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: colorScheme.copyWith(
              primary: colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _startDate = date;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final colorScheme = Theme.of(context).colorScheme;
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 7)),
      firstDate: _startDate,
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: colorScheme.copyWith(
              primary: colorScheme.tertiary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  Future<void> _selectExpiryDate() async {
    final colorScheme = Theme.of(context).colorScheme;
    final date = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: colorScheme.copyWith(
              primary: colorScheme.error,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _expiryDate = date;
      });
    }
  }

  void _scanBarcode() {
    showBarcodeScannerBottomSheet(
      context,
      _scannerService,
      (result) {
        if (result.isSuccess && result.hasBarcode) {
          // Succès + Code-barres
          _validateAndFillForm(result.barcode!);
        } else if (result.isCancelled) {
          final l10n = AppLocalizations.of(context)!;
          // Annulation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.medFormScanCancelled),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (!result.isSuccess) {
          final l10n = AppLocalizations.of(context)!;
          // Erreur
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onError),
                  const SizedBox(width: AppSizes.spacingS),
                  Expanded(
                    child: Text(
                      result.errorMessage ?? l10n.scanError,
                      style: TextStyle(color: Theme.of(context).colorScheme.onError),
                    ),
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  Future<void> _validateAndFillForm(String barcode) async {
    final l10n = AppLocalizations.of(context)!;
    // Show validation loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.paddingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: AppSizes.spacingM),
                Text(AppLocalizations.of(context)!.medFormSearching),
                Text(
                  AppLocalizations.of(context)!.medFormConsultingDb,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // Import the validation service
      final validationService = di.sl<BarcodeValidationService>();
      
      // Validate and lookup (async now)
      final validationResult = await validationService.validateAndLookup(barcode);

      // Close loading dialog
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (!mounted) return;

      setState(() {
        // Always fill the barcode field
        _barcodeController.text = barcode;

        // If medication found in database, auto-fill the form
        if (validationResult.foundInDatabase && validationResult.medication != null) {
          final med = validationResult.medication!;
          _nameController.text = med.name;
          _dosageController.text = med.dosage;
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: AppSizes.spacingS),
                      Text(
                        AppLocalizations.of(context)!.medFormFound,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 28, top: 2),
                    child: Text(
                      '${AppLocalizations.of(context)!.medFormName}: ${med.name}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28, top: 2),
                    child: Text(
                      '${AppLocalizations.of(context)!.medFormDosage}: ${med.dosage}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  if (med.manufacturer != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 28, top: 2),
                      child: Text(
                        AppLocalizations.of(context)!.medFormManufacturer(med.manufacturer!),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                ],
              ),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          // Barcode valid but not found in database
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.cloud_off, color: Colors.white),
                      SizedBox(width: AppSizes.spacingS),
                      Text(
                        'Médicament inconnu',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.only(left: 28, top: 2),
                    child: Text(
                      'Non trouvé dans la base locale ni en ligne',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28, top: 2),
                    child: Text(
                      'Code-barres: $barcode',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 28, top: 2),
                    child: Text(
                      'Veuillez remplir les informations manuellement',
                      style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.warning,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    } catch (e) {
      // Close loading dialog if error
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
             content: Text('Erreur lors de la validation: $e'),
             backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _saveMedication() async {
    final feedbackService = Provider.of<FeedbackService>(context, listen: false);

    if (!_formKey.currentState!.validate()) {
      feedbackService.playSound(SoundType.error);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final medication = Medication(
        id: widget.medication?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        frequency: _frequency,
        times: _times,
        startDate: _startDate,
        endDate: _endDate,
        expiryDate: _expiryDate,
        barcode: _barcodeController.text.trim().isNotEmpty
            ? _barcodeController.text.trim()
            : null,
        isActive: _isActive,
        createdAt: widget.medication?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final provider = context.read<MedicationProvider>();
      final success = widget.medication == null
          ? await provider.addNewMedication(medication)
          : await provider.updateExistingMedication(medication);

      if (mounted) {
        if (success) {
          feedbackService.playSound(SoundType.success);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.medication == null
                    ? l10n.medFormSaved
                    : l10n.medFormChangesSaved,
              ),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).pop();
        } else {
          feedbackService.playSound(SoundType.error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                provider.errorMessage ?? l10n.errorTitle,
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        feedbackService.playSound(SoundType.error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
