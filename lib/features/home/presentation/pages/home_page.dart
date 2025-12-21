import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediscanhelper/core/constants/app_colors.dart';
import 'package:mediscanhelper/core/constants/app_strings.dart';
import 'package:mediscanhelper/core/constants/app_sizes.dart';
import 'package:mediscanhelper/features/auth/presentation/providers/auth_provider.dart' as auth;
import 'package:mediscanhelper/features/auth/presentation/pages/login_page.dart';
import 'package:mediscanhelper/features/home/presentation/widgets/dashboard_card.dart';
import 'package:mediscanhelper/features/home/presentation/widgets/app_drawer.dart';
import 'package:mediscanhelper/features/prescription_scanner/presentation/pages/scanner_page.dart';
import 'package:mediscanhelper/features/medications/presentation/pages/medications_list_page.dart';
import 'package:mediscanhelper/features/medications/presentation/providers/medication_provider.dart';
import 'package:mediscanhelper/features/reminders/presentation/pages/reminders_page.dart';
import 'package:mediscanhelper/features/reminders/presentation/providers/reminder_provider.dart';
import 'package:mediscanhelper/features/settings/presentation/pages/settings_page.dart';
import 'package:mediscanhelper/features/profile/presentation/pages/profile_page.dart';
import 'package:mediscanhelper/features/history/presentation/pages/treatment_history_page.dart';
import 'package:mediscanhelper/features/history/domain/entities/treatment_history.dart';
import 'package:mediscanhelper/features/medications/domain/entities/medication.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mediscanhelper/l10n/app_localizations.dart';
import 'package:mediscanhelper/core/utils/feedback_service.dart';

/// Page d'accueil de l'application
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Charger les données au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        print('🏠 HomePage: Loading medications...');
        final medicationProvider = context.read<MedicationProvider>();

        // Load all medications first
        await medicationProvider.loadMedications();
        print('✅ HomePage: Loaded ${medicationProvider.medications.length} total medications');
        print('✅ HomePage: ${medicationProvider.activeMedicationsCount} active medications');

        // Then load today's medications
        await medicationProvider.loadTodayMedications();
        print('✅ HomePage: Loaded ${medicationProvider.todayMedications.length} today medications');
      } catch (e) {
        print('❌ HomePage: Error loading medications: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<auth.AuthProvider>(context);
    final feedbackService = Provider.of<FeedbackService>(context);
    final reminderProvider = Provider.of<ReminderProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryBlue,
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Consumer<MedicationProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () async {
                 await provider.loadMedications();
                 // Also refresh history logic if needed
              },
              child: ListView(
                padding: const EdgeInsets.all(AppSizes.paddingL),
                children: [
                  _buildHeroSection(context, provider, authProvider, feedbackService, reminderProvider),
                  const SizedBox(height: AppSizes.spacingL),
                  _buildQuickActions(context, feedbackService),
                  const SizedBox(height: AppSizes.spacingL),
                  _buildSimplifiedStats(context, provider),
                  const SizedBox(height: AppSizes.spacingL),
                   _buildTodayTimeline(context, provider, feedbackService, reminderProvider),
                   const SizedBox(height: AppSizes.spacingXl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// 1. Hero Section - Status & Next Dose
  Widget _buildHeroSection(BuildContext context, MedicationProvider provider, auth.AuthProvider authProvider, FeedbackService feedbackService, ReminderProvider reminderProvider) {
    // Find next dose logic
    final allMeds = provider.activeMedications;
    final now = DateTime.now();
    Medication? nextMed;
    TimeOfDay? nextTime;
    DateTime? nextDateTime;

    DateTime? closestDateTime;

    for (final med in allMeds) {
      for (final time in med.times) {
        final scheduled = DateTime(now.year, now.month, now.day, time.hour, time.minute);
        
        // Check if already taken
        final isTaken = reminderProvider.isDoseTaken(med.id, scheduled);
        
        if (!isTaken && scheduled.isAfter(now)) {
           if (closestDateTime == null || scheduled.isBefore(closestDateTime)) {
             closestDateTime = scheduled;
             nextMed = med;
             nextTime = time;
             nextDateTime = scheduled;
           }
        }
      }
    }

    // Determine Gradient & Status
    final isClear = nextMed == null;
    final gradientColors = isClear
        ? [AppColors.success, const Color(0xFF2E7D32)] // Green for "Caught Up"
        : [AppColors.primaryBlue, const Color(0xFF1E40AF)]; // Blue for "Next Dose"

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative Circles
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: const AssetImage('assets/images/user_avatar.png'), // Placeholder
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: AppSizes.spacingM),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.homeWelcome,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        Text(
                          authProvider.currentUser?.displayName ?? 'User',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                     // Notification Bell (moved from AppBar)
                     IconButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RemindersPage())),
                        icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                        ),
                     ),
                  ],
                ),

                const SizedBox(height: AppSizes.spacingXl),

                // Main Status
                if (isClear)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             const Icon(Icons.check_circle, color: Colors.white, size: 16),
                             const SizedBox(width: 8),
                             Text(
                               "All Caught Up", // L10n later
                               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                             ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "No medications pending for today.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             const Icon(Icons.access_time_filled, color: Colors.white, size: 16),
                             const SizedBox(width: 8),
                             Text(
                               "Next Dose", // L10n later
                               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                             ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacingM),
                      Text(
                        nextMed!.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28, // Large
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                       Text(
                        "${nextMed.dosage} • ${nextTime!.format(context)}",
                         style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacingL),
                      // Action Button (Take Now)
                      ElevatedButton.icon(
                        onPressed: () {
                           feedbackService.click();
                           reminderProvider.markAsTaken(
                              medicationId: nextMed!.id, 
                              medicationName: nextMed!.name, 
                              dosage: nextMed!.dosage, 
                              scheduledTime: nextDateTime!
                           );
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text('${nextMed!.name} marqué comme pris'))
                           );
                        },
                        icon: const Icon(Icons.check),
                        label: const Text("Mark as Taken"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: gradientColors[1],
                           elevation: 0,
                           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    )
    .animate()
    .fadeIn(duration: 800.ms)
    .slideY(begin: -0.2, end: 0);
  }

  /// 2. Quick Actions
  Widget _buildQuickActions(BuildContext context, FeedbackService feedbackService) {
    final l10n = AppLocalizations.of(context)!;
    final actions = [
      {'icon': Icons.document_scanner_outlined, 'label': l10n.medFormScan, 'color': AppColors.primaryBlue, 'page': const ScannerPage()},
      {'icon': Icons.medication_outlined, 'label': l10n.homeTotalMeds, 'color': AppColors.secondaryGreen, 'page': const MedicationsListPage()},
      {'icon': Icons.calendar_today_outlined, 'label': l10n.menuHistory, 'color': AppColors.warning, 'page': const TreatmentHistoryPage()},
      // {'icon': Icons.settings_outlined, 'label': l10n.menuSettings, 'color': AppColors.grey600, 'page': const SettingsPage()},
    ];

    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribute evenly
        crossAxisAlignment: CrossAxisAlignment.start, // Align top
        children: actions.map((action) {
           return _buildQuickActionButton(
             context,
             icon: action['icon'] as IconData,
             label: action['label'] as String,
             color: action['color'] as Color,
             onTap: () {
               feedbackService.click();
               Navigator.push(context, MaterialPageRoute(builder: (_) => action['page'] as Widget));
             },
           );
        }).toList(),
      ),
    );
  }

  Widget _buildQuickActionButton(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20), // Soft square
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    ).animate().scale(delay: 200.ms).fadeIn();
  }

  /// 3. Simplified Stats
  Widget _buildSimplifiedStats(BuildContext context, MedicationProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    // Logic from old stats
    final activeMeds = provider.activeMedications.length;
    final expiredCount = provider.allMedications.where((m) => m.isExpired).length;
    // final dosesToday = ... (calculate if needed)

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, label: l10n.statActiveMeds, value: "$activeMeds", color: AppColors.primaryBlue),
          Container(width: 1, height: 40, color: AppColors.grey200),
          _buildStatItem(context, label: l10n.statLabelAlerts, value: "$expiredCount", color: expiredCount > 0 ? AppColors.error : AppColors.grey400),
           // Add more if needed
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildStatItem(BuildContext context, {required String label, required String value, required Color color}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.grey600),
        ),
      ],
    );
  }

  /// 4. Today's Timeline
  Widget _buildTodayTimeline(BuildContext context, MedicationProvider provider, FeedbackService feedbackService, ReminderProvider reminderProvider) {
    final l10n = AppLocalizations.of(context)!;
    final activeMeds = provider.activeMedications;
    
    // Create a flat list of all doses for today
    final List<Map<String, dynamic>> timelineItems = [];
    
    for (final med in activeMeds) {
      for (final time in med.times) {
        timelineItems.add({
          'time': time,
          'medication': med,
        });
      }
    }

    // Sort by time
    timelineItems.sort((a, b) {
      final timeA = a['time'] as TimeOfDay;
      final timeB = b['time'] as TimeOfDay;
      final aMinutes = timeA.hour * 60 + timeA.minute;
      final bMinutes = timeB.hour * 60 + timeB.minute;
      return aMinutes.compareTo(bMinutes);
    });

    if (timelineItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingL),
          child: Column(
            children: [
              Icon(Icons.event_available, size: 48, color: AppColors.grey400),
              const SizedBox(height: AppSizes.spacingS),
              Text(
                l10n.homeTimelineEmpty,
                style: TextStyle(color: AppColors.grey600),
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
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingS),
          child: Text(
            l10n.homeTimelineTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: AppSizes.spacingM),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: timelineItems.length,
          itemBuilder: (context, index) {
             final item = timelineItems[index];
             final med = item['medication'] as Medication;
             final time = item['time'] as TimeOfDay;
             
             final now = DateTime.now();
             final scheduledDateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
             final isTaken = reminderProvider.isDoseTaken(med.id, scheduledDateTime);
             
             final nowMinutes = now.hour * 60 + now.minute;
             final scheduledMinutes = time.hour * 60 + time.minute;
             final isPast = scheduledMinutes < nowMinutes && !isTaken; // Only "passé" if not taken and time passed
             
             return IntrinsicHeight(
               child: Row(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                   SizedBox(
                     width: 50,
                     child: Column(
                       children: [
                         Text(
                           time.format(context),
                           style: TextStyle(
                             fontWeight: FontWeight.bold, 
                             color: isTaken ? AppColors.success : (isPast ? AppColors.grey500 : AppColors.primaryBlue)
                           ),
                         ),
                         Expanded(
                           child: Container(
                             width: 2, 
                             color: isTaken ? AppColors.success.withOpacity(0.5) : (isPast ? AppColors.grey300 : AppColors.primaryBlue.withOpacity(0.3))
                           )
                         ),
                       ],
                     ),
                   ),
                   const SizedBox(width: AppSizes.spacingS),
                   Expanded(
                     child: Container(
                       margin: const EdgeInsets.only(bottom: AppSizes.spacingM),
                       padding: const EdgeInsets.all(AppSizes.paddingM),
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(AppSizes.radiusM),
                         border: Border.all(
                           color: isTaken ? AppColors.success.withOpacity(0.3) : (isPast ? AppColors.grey200 : AppColors.primaryBlue.withOpacity(0.2))
                         ),
                         boxShadow: [
                           BoxShadow(
                             color: Colors.black.withOpacity(0.05), 
                             blurRadius: 4, 
                             offset: const Offset(0, 2)
                           )
                         ],
                       ),
                       child: Row(
                         children: [
                           Container(
                             padding: const EdgeInsets.all(8),
                             decoration: BoxDecoration(
                               color: isTaken ? AppColors.success.withOpacity(0.1) : (isPast ? AppColors.grey100 : AppColors.secondaryGreen.withOpacity(0.1)),
                               shape: BoxShape.circle,
                             ),
                             child: Icon(
                               isTaken ? Icons.check : Icons.medication, 
                               color: isTaken ? AppColors.success : (isPast ? AppColors.grey500 : AppColors.secondaryGreen),
                               size: 20
                             ),
                           ),
                           const SizedBox(width: AppSizes.spacingM),
                           Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   med.name, 
                                   style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     color: isTaken ? AppColors.grey600 : (isPast ? AppColors.grey600 : AppColors.grey900),
                                     decoration: isTaken ? TextDecoration.lineThrough : null,
                                   )
                                 ),
                                 Text(
                                   med.dosage, 
                                   style: TextStyle(color: AppColors.grey500, fontSize: 12)
                                 ),
                               ],
                             ),
                           ),
                           if (!isTaken)
                             IconButton(
                               icon: const Icon(Icons.check_circle_outline),
                               color: AppColors.primaryBlue,
                                onPressed: () {
                                  feedbackService.success();
                                  reminderProvider.markAsTaken(
                                    medicationId: med.id, 
                                    medicationName: med.name, 
                                    dosage: med.dosage, 
                                    scheduledTime: scheduledDateTime
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${med.name} marqué comme pris'),
                                      duration: const Duration(seconds: 2),
                                    )
                                  );
                                },
                             )
                           else
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.check_circle, color: AppColors.success),
                              ),
                         ],
                       ),
                     ),
                   ),
                 ],
               ),
             );
          },
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

}

