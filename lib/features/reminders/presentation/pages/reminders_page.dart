import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediscanhelper/core/constants/app_colors.dart';
import 'package:mediscanhelper/core/constants/app_strings.dart';
import 'package:mediscanhelper/core/constants/app_sizes.dart';
import 'package:mediscanhelper/core/utils/notification_service.dart';
import 'package:mediscanhelper/core/utils/notification_scheduler.dart';
import 'package:mediscanhelper/features/medications/presentation/providers/medication_provider.dart';
import 'package:mediscanhelper/features/reminders/presentation/providers/reminder_provider.dart';
import 'package:mediscanhelper/features/history/domain/entities/treatment_history.dart';
import 'package:mediscanhelper/injection_container.dart' as di;
import 'package:mediscanhelper/l10n/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Page de gestion des rappels
class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final _notificationService = NotificationService();
  late final NotificationScheduler _notificationScheduler;
  bool _notificationsEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _notificationScheduler = di.sl<NotificationScheduler>();
    _initializeNotifications();
    _loadMedications();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
    final hasPermission = await _notificationService.requestPermission();
    setState(() {
      _notificationsEnabled = hasPermission;
      _isLoading = false;
    });
  }

  Future<void> _loadMedications() async {
    print('🔄 Reminders: Loading medications...');
    final provider = context.read<MedicationProvider>();

    try {
      // Load all medications
      await provider.loadMedications();
      print('📦 Reminders: Total medications loaded: ${provider.medications.length}');
      print('✅ Reminders: Active medications: ${provider.activeMedicationsCount}');

      // Get active medications
      final activeMeds = provider.medications.where((m) => m.isActive).toList();

      // Debug: Print each active medication
      for (final med in activeMeds) {
        print('   - ${med.name}: ${med.times.length} times, active: ${med.isActive}');
        print('     Start: ${med.startDate}, End: ${med.endDate}');
      }

      // Planifier les notifications pour les médicaments actifs
      await _ensureNotificationsScheduled(activeMeds);
    } catch (e) {
      print('❌ Reminders: Error loading medications: $e');
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

  /// S'assure que les notifications sont planifiées pour tous les médicaments
  Future<void> _ensureNotificationsScheduled(List medications) async {
    if (!_notificationsEnabled) {
      print('⚠️ Notifications not enabled, skipping scheduling');
      return;
    }

    print('📋 Checking and scheduling notifications...');
    int scheduledCount = 0;

    for (final medication in medications) {
      for (int i = 0; i < medication.times.length; i++) {
        final time = medication.times[i];
        final notificationId = NotificationScheduler.generateNotificationId(
          medication.id,
          i,
        );

        // Vérifier si la notification est déjà planifiée
        final isScheduled = await _notificationService.isNotificationScheduled(notificationId);

        if (!isScheduled) {
          // Planifier la notification
          await _notificationService.scheduleDailyNotification(
            id: notificationId,
            title: '💊 ${medication.name}',
            body: AppLocalizations.of(context)!.notificationTimeForMed(medication.dosage),
            hour: time.hour,
            minute: time.minute,
            sound: true,
            vibration: true,
          );
          scheduledCount++;
          print('   🔔 Notification planifiée: ${medication.name} à ${time.hour}:${time.minute.toString().padLeft(2, '0')}');
        } else {
          print('   ✓ Notification déjà planifiée: ${medication.name} à ${time.hour}:${time.minute.toString().padLeft(2, '0')}');
        }
      }
    }

    if (scheduledCount > 0) {
      print('✅ $scheduledCount nouvelles notifications planifiées');
    } else {
      print('✅ Toutes les notifications sont déjà planifiées');
    }

    // Forcer la mise à jour de l'UI
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.grey50, // Removed to allow Theme background
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.remindersTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Aide',
            onPressed: _showHelp,
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: _loadMedications,
                child: ListView(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  children: [
                    _buildPermissionCard(),
                    const SizedBox(height: AppSizes.spacingL),
                    _buildTodayMedicationsSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildPermissionCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: _notificationsEnabled
            ? (isDark ? AppColors.success.withOpacity(0.1) : AppColors.success.withOpacity(0.05))
            : (isDark ? AppColors.warning.withOpacity(0.1) : AppColors.warning.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(
          color: _notificationsEnabled
              ? AppColors.success.withOpacity(0.3)
              : AppColors.warning.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: _notificationsEnabled ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _notificationsEnabled ? Icons.notifications_active : Icons.notifications_off,
              color: _notificationsEnabled ? AppColors.success : AppColors.warning,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSizes.spacingL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _notificationsEnabled
                      ? AppLocalizations.of(context)!.remindersNotificationsEnabled
                      : AppLocalizations.of(context)!.remindersNotificationsDisabled,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _notificationsEnabled ? AppColors.success : AppColors.warning,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  _notificationsEnabled
                      ? AppLocalizations.of(context)!.remindersEnabledDesc
                      : AppLocalizations.of(context)!.remindersDisabledDesc,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          if (!_notificationsEnabled)
            TextButton(
              onPressed: _requestPermission,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.warning,
              ),
              child: Text(AppLocalizations.of(context)!.activate),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildTodayMedicationsSection() {
    return Consumer<MedicationProvider>(
      builder: (context, provider, _) {
        final activeMeds = provider.medications.where((m) => m.isActive).toList();

        if (activeMeds.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingXl),
              child: Column(
                children: [
                  Icon(Icons.medication_outlined, size: 64, color: Theme.of(context).disabledColor),
                  const SizedBox(height: AppSizes.spacingM),
                  Text(
                    AppLocalizations.of(context)!.remindersNoActiveMeds,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSizes.spacingS),
                  Text(
                    AppLocalizations.of(context)!.remindersAddMedsHint,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                  ),
                  const SizedBox(height: AppSizes.spacingM),
                  OutlinedButton.icon(
                    onPressed: () async => await _loadMedications(),
                    icon: const Icon(Icons.refresh),
                    label: Text(AppLocalizations.of(context)!.refresh),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.remindersMyMeds(activeMeds.length),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () async {
                      await _ensureNotificationsScheduled(activeMeds);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.remindersScheduled),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.sync),
                    tooltip: AppLocalizations.of(context)!.refresh,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spacingM),
            ...activeMeds.asMap().entries.map((entry) {
              return _buildMedicationCard(entry.value, entry.key);
            }),
          ],
        );
      },
    );
  }

  Widget _buildMedicationCard(medication, int index) {
    return Consumer<ReminderProvider>(
      builder: (context, reminderProvider, child) {
        final now = DateTime.now();
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          margin: const EdgeInsets.only(bottom: AppSizes.spacingM),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isDark ? AppColors.grey800 : AppColors.grey100,
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingL),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.medication, color: AppColors.primaryBlue),
                    ),
                    const SizedBox(width: AppSizes.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medication.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            medication.dosage,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grey500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              Divider(height: 1, color: isDark ? AppColors.grey800 : AppColors.grey100),

              // Times List
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingL),
                child: Builder(
                  builder: (context) {
                    final pendingTimes = <MapEntry<int, TimeOfDay>>[];
                    final treatedTimes = <MapEntry<int, TimeOfDay>>[];

                    for (final entry in medication.times.asMap().entries) {
                      final time = entry.value;
                      final scheduledTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
                      if (reminderProvider.isDoseTaken(medication.id, scheduledTime)) {
                        treatedTimes.add(entry);
                      } else {
                        pendingTimes.add(entry);
                      }
                    }

                    if (pendingTimes.isEmpty && treatedTimes.isEmpty) {
                      return Text(
                        AppLocalizations.of(context)!.remindersNoTimesConfigured,
                        style: TextStyle(color: AppColors.grey500, fontStyle: FontStyle.italic),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (pendingTimes.isNotEmpty)
                          Wrap(
                            spacing: AppSizes.spacingS,
                            runSpacing: AppSizes.spacingS,
                            children: pendingTimes.map((entry) {
                               final time = entry.value;
                               final notificationId = NotificationScheduler.generateNotificationId(medication.id, entry.key);
                               
                               return FutureBuilder<bool>(
                                 future: _notificationService.isNotificationScheduled(notificationId),
                                 builder: (context, snapshot) {
                                   final isScheduled = snapshot.data ?? false;
                                   return InkWell(
                                     onTap: () => _showTimeSelectionDialog(medication, isMarkingAsTaken: true),
                                     borderRadius: BorderRadius.circular(AppSizes.radiusM),
                                     child: Container(
                                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                       decoration: BoxDecoration(
                                         color: isScheduled ? AppColors.activeLight : Theme.of(context).scaffoldBackgroundColor,
                                         borderRadius: BorderRadius.circular(AppSizes.radiusM),
                                         border: Border.all(
                                           color: isScheduled ? AppColors.primaryBlue : AppColors.grey300,
                                         ),
                                       ),
                                       child: Row(
                                         mainAxisSize: MainAxisSize.min,
                                         children: [
                                            Icon(
                                              Icons.access_time_filled, 
                                              size: 16, 
                                              color: isScheduled ? AppColors.primaryBlue : AppColors.grey500
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              time.format(context),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: isScheduled ? AppColors.primaryBlue : Theme.of(context).textTheme.bodyMedium?.color,
                                              ),
                                            ),
                                         ],
                                       ),
                                     ),
                                   );
                                 }
                               );
                            }).toList(),
                          ),
                          
                        if (treatedTimes.isNotEmpty) ...[
                          if (pendingTimes.isNotEmpty) const SizedBox(height: AppSizes.spacingM),
                          Text(
                            AppLocalizations.of(context)!.historyCompleted,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.success),
                          ),
                          const SizedBox(height: AppSizes.spacingXs),
                          Wrap(
                             spacing: AppSizes.spacingS,
                             children: treatedTimes.map((entry) {
                               final time = entry.value;
                               return Chip(
                                 label: Text(
                                   time.format(context),
                                   style: const TextStyle(fontSize: 12, decoration: TextDecoration.lineThrough),
                                 ),
                                 avatar: const Icon(Icons.check, size: 14),
                                 backgroundColor: AppColors.success.withOpacity(0.1),
                                 labelStyle: TextStyle(color: AppColors.success),
                                 side: BorderSide.none,
                                 visualDensity: VisualDensity.compact,
                               );
                             }).toList(),
                          ),
                        ]
                      ],
                    );
                  },
                ),
              ),
              
              // Actions Footer for Pending
              if (medication.times.any((time) {
                 final scheduledTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
                 return !reminderProvider.isDoseTaken(medication.id, scheduledTime);
              }))
                Padding(
                  padding: const EdgeInsets.only(left: AppSizes.paddingL, right: AppSizes.paddingL, bottom: AppSizes.paddingL),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showTimeSelectionDialog(medication, isMarkingAsTaken: true),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.success,
                            side: BorderSide(color: AppColors.success.withOpacity(0.5)),
                          ),
                          child: Text(AppLocalizations.of(context)!.markAsTaken),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms, delay: Duration(milliseconds: 100 * index)).slideY(begin: 0.1, end: 0);
      },
    );
  }

  /// Affiche un dialogue pour sélectionner l'heure spécifique de prise
  void _showTimeSelectionDialog(medication, {required bool isMarkingAsTaken}) {
    final reminderProvider = context.read<ReminderProvider>();
    final now = DateTime.now();

    if (medication.times.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.remindersNoTimesConfigured),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // Filtrer pour ne montrer que les heures non traitées
    final availableTimes = medication.times.where((time) {
      final scheduledTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      return !reminderProvider.isDoseTaken(medication.id, scheduledTime);
    }).toList();

    if (availableTimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isMarkingAsTaken
                ? AppLocalizations.of(context)!.remindersAllTaken
                : AppLocalizations.of(context)!.remindersAllSkipped,
          ),
          backgroundColor: AppColors.info,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
        ),
        title: Row(
          children: [
            Icon(
              isMarkingAsTaken ? Icons.check_circle : Icons.block,
              color: isMarkingAsTaken ? AppColors.success : AppColors.warning,
            ),
            const SizedBox(width: AppSizes.spacingM),
            Expanded(
              child: Text(
                isMarkingAsTaken ? AppLocalizations.of(context)!.markAsTaken : AppLocalizations.of(context)!.markAsSkipped,
                style: TextStyle(
                  color: isMarkingAsTaken ? AppColors.success : AppColors.warning,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              medication.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: AppSizes.spacingS),
            Text(
              medication.dosage,
              style: const TextStyle(color: AppColors.grey600),
            ),
            const SizedBox(height: AppSizes.spacingL),
            Text(
              AppLocalizations.of(context)!.remindersSelectTime,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: AppSizes.spacingM),
            ...availableTimes.map<Widget>((time) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.spacingS),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (isMarkingAsTaken) {
                        _markAsTaken(medication, time);
                      } else {
                        _markAsSkipped(medication, time);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isMarkingAsTaken
                          ? AppColors.success
                          : AppColors.warning,
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                    ),
                    child: Text(
                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _markAsTaken(medication, TimeOfDay selectedTime) async {
    final now = DateTime.now();
    final reminderProvider = context.read<ReminderProvider>();

    // Utiliser l'heure sélectionnée par l'utilisateur
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    await reminderProvider.markAsTaken(
      medicationId: medication.id,
      medicationName: medication.name,
      dosage: medication.dosage,
      scheduledTime: scheduledTime,
    );

    if (mounted) {
      final timeStr = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ ${medication.name} ($timeStr) marqué comme pris'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _markAsSkipped(medication, TimeOfDay selectedTime) async {
    final now = DateTime.now();
    final reminderProvider = context.read<ReminderProvider>();

    // Utiliser l'heure sélectionnée par l'utilisateur
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    await reminderProvider.markAsSkipped(
      medicationId: medication.id,
      medicationName: medication.name,
      dosage: medication.dosage,
      scheduledTime: scheduledTime,
    );

    if (mounted) {
      final timeStr = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⏭️ ${medication.name} ($timeStr) marqué comme ignoré'),
          backgroundColor: AppColors.warning,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _requestPermission() async {
    final hasPermission = await _notificationService.requestPermission();
    setState(() {
      _notificationsEnabled = hasPermission;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            hasPermission
                ? '✅ Notifications activées'
                : '❌ Permission refusée',
          ),
          backgroundColor: hasPermission ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

  Future<void> _sendTestNotification() async {
    await _notificationService.showImmediateNotification(
      id: 99999,
      title: '💊 Rappel de médicament',
      body: 'Ceci est une notification de test. Tout fonctionne bien !',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🔔 Notification de test envoyée !'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _toggleNotification(
    medication,
    int hour,
    int minute,
    int notificationId,
    bool currentlyScheduled,
  ) async {
    if (!_notificationsEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Activez d\'abord les notifications'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    if (currentlyScheduled) {
      // Annuler la notification
      await _notificationService.cancelNotification(notificationId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '❌ Rappel désactivé pour ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } else {
      // Planifier la notification
      await _notificationService.scheduleDailyNotification(
        id: notificationId,
        title: '💊 ${medication.name}',
        body: 'Il est temps de prendre votre médicament (${medication.dosage})',
        hour: hour,
        minute: minute,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Rappel activé pour ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }

    // Forcer le rebuild pour mettre à jour l'UI
    setState(() {});
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
        ),
        title: Row(
          children: [
            const Icon(Icons.help_outline, color: AppColors.info),
            const SizedBox(width: AppSizes.spacingM),
            const Text('Aide'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpItem(
                '🔔',
                'Activer les notifications',
                'Cliquez sur "Activer" pour autoriser les notifications',
              ),
              _buildHelpItem(
                '⏰',
                'Configurer les rappels',
                'Cliquez sur une heure pour activer/désactiver le rappel',
              ),
              _buildHelpItem(
                '💊',
                'Médicaments du jour',
                'Seuls les médicaments actifs avec horaires sont affichés',
              ),
              _buildHelpItem(
                '🧪',
                'Test',
                'Utilisez le bouton de test pour vérifier que les notifications fonctionnent',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Compris'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: AppSizes.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

