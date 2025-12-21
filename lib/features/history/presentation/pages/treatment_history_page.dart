import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediscanhelper/core/constants/app_colors.dart';
import 'package:mediscanhelper/core/constants/app_sizes.dart';
import 'package:mediscanhelper/features/medications/presentation/providers/medication_provider.dart';
import 'package:mediscanhelper/features/reminders/presentation/providers/reminder_provider.dart';
import 'package:mediscanhelper/features/history/domain/entities/treatment_history.dart';
import 'package:mediscanhelper/l10n/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

/// Page d'historique des traitements
class TreatmentHistoryPage extends StatefulWidget {
  const TreatmentHistoryPage({super.key});

  @override
  State<TreatmentHistoryPage> createState() => _TreatmentHistoryPageState();
}

class _TreatmentHistoryPageState extends State<TreatmentHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Charger les médicaments et générer l'historique
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final medicationProvider = context.read<MedicationProvider>();
      final reminderProvider = context.read<ReminderProvider>();

      medicationProvider.loadMedications().then((_) {
        // Générer des données d'exemple si l'historique est vide
        if (reminderProvider.treatmentHistory.isEmpty) {
          reminderProvider.generateSampleHistory(medicationProvider.medications);
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.historyTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              _showDateRangePicker(context);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.historyToday),
            Tab(text: AppLocalizations.of(context)!.historyWeek),
            Tab(text: AppLocalizations.of(context)!.historyAllTime),
          ],
        ),
      ),
      body: Consumer<ReminderProvider>(
        builder: (context, reminderProvider, _) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildHistoryList(context, reminderProvider.getTodayHistory()),
              _buildHistoryList(context, reminderProvider.getWeekHistory()),
              _buildHistoryList(context, reminderProvider.treatmentHistory),
            ],
          );
        },
      ),
      floatingActionButton: Consumer<ReminderProvider>(
        builder: (context, reminderProvider, _) {
          return FloatingActionButton.extended(
            onPressed: () {
              _showStatsDialog(context, reminderProvider.treatmentHistory);
            },
            icon: const Icon(Icons.analytics_outlined),
            label: Text(AppLocalizations.of(context)!.statsTitle),
          );
        },
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context, List<TreatmentHistory> history) {
    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: AppColors.grey400,
            ),
            const SizedBox(height: AppSizes.spacingM),
            const SizedBox(height: AppSizes.spacingM),
            Text(
              AppLocalizations.of(context)!.historyEmptyTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.grey600,
                  ),
            ),
            const SizedBox(height: AppSizes.spacingS),
            Text(
              AppLocalizations.of(context)!.historyEmptyBody,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey500,
                  ),
            ),
          ],
        ),
      );
    }

    // Grouper par date
    final groupedHistory = _groupByDate(history);

    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      itemCount: groupedHistory.length,
      itemBuilder: (context, index) {
        final dateKey = groupedHistory.keys.elementAt(index);
        final items = groupedHistory[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSizes.paddingS,
                horizontal: AppSizes.paddingS,
              ),
              child: Text(
                _formatDateHeader(dateKey),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
              ),
            ),
            ...items.asMap().entries.map((entry) {
              final itemIndex = entry.key;
              final item = entry.value;
              return _buildHistoryItem(context, item)
                  .animate()
                  .fadeIn(
                    duration: const Duration(milliseconds: 400),
                    delay: Duration(milliseconds: itemIndex * 50),
                  )
                  .slideX(begin: -0.2, end: 0);
            }).toList(),
            const SizedBox(height: AppSizes.spacingM),
          ],
        );
      },
    );
  }

  Widget _buildHistoryItem(BuildContext context, TreatmentHistory item) {
    final statusColor = _getStatusColor(item.status);
    final isLate = item.delayInMinutes != null && item.delayInMinutes! > 15;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingS),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusS),
          ),
          child: Center(
            child: Text(
              item.status.icon,
              style: TextStyle(
                fontSize: 24,
                color: statusColor,
              ),
            ),
          ),
        ),
        title: Text(
          item.medicationName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${item.dosage} • ${_formatTime(item.scheduledTime)}'),
            if (item.takenTime != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    isLate ? Icons.schedule : Icons.check_circle_outline,
                    size: 14,
                    color: isLate ? AppColors.error : AppColors.success,
                  ),
                  const SizedBox(width: 4),
                  const SizedBox(width: 4),
                  Text(
                    '${AppLocalizations.of(context)!.takenTime}: ${_formatTime(item.takenTime!)}${isLate ? " (${AppLocalizations.of(context)!.minutesLate(item.delayInMinutes ?? 0)})" : ""}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isLate ? AppColors.error : AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
            if (item.note != null) ...[
              const SizedBox(height: 4),
              Text(
                item.note!,
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        trailing: Chip(
          label: Text(item.status.label),
          backgroundColor: statusColor.withOpacity(0.2),
          labelStyle: TextStyle(
            color: statusColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        onTap: () {
          _showHistoryDetails(context, item);
        },
      ),
    );
  }

  Color _getStatusColor(TreatmentStatus status) {
    switch (status) {
      case TreatmentStatus.taken:
        return AppColors.success;
      case TreatmentStatus.missed:
        return AppColors.error;
      case TreatmentStatus.skipped:
        return AppColors.warning;
      case TreatmentStatus.pending:
        return AppColors.info;
    }
  }

  Map<DateTime, List<TreatmentHistory>> _groupByDate(List<TreatmentHistory> history) {
    final Map<DateTime, List<TreatmentHistory>> grouped = {};

    for (final item in history) {
      final date = DateTime(
        item.scheduledTime.year,
        item.scheduledTime.month,
        item.scheduledTime.day,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(item);
    }

    // Trier par date décroissante
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, grouped[key]!)),
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final l10n = AppLocalizations.of(context)!;
    if (date == today) {
      return l10n.historyToday;
    } else if (date == yesterday) {
      return l10n.historyYesterday;
    } else {
      return DateFormat.yMMMMEEEEd(Localizations.localeOf(context).toString()).format(date);
    }
  }

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.filterHistory),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(AppLocalizations.of(context)!.filterAll),
              value: 'all',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(AppLocalizations.of(context)!.filterTaken),
              value: 'taken',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(AppLocalizations.of(context)!.filterMissed),
              value: 'missed',
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.dateRangeSelected(
              DateFormat('dd/MM/yyyy').format(picked.start),
              DateFormat('dd/MM/yyyy').format(picked.end)
            ),
          ),
        ),
      );
    }
  }

  void _showHistoryDetails(BuildContext context, TreatmentHistory item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusL)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  ),
                  child: Icon(
                    Icons.medication,
                    color: _getStatusColor(item.status),
                    size: 32,
                  ),
                ),
                const SizedBox(width: AppSizes.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.medicationName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        item.dosage,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.grey600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingL),
            _buildDetailRow(AppLocalizations.of(context)!.status, item.status.label),
            _buildDetailRow(AppLocalizations.of(context)!.scheduledTime, _formatTime(item.scheduledTime)),
            if (item.takenTime != null)
              _buildDetailRow(AppLocalizations.of(context)!.takenTime, _formatTime(item.takenTime!)),
            if (item.delayInMinutes != null)
              _buildDetailRow(AppLocalizations.of(context)!.delay, '${item.delayInMinutes} ${AppLocalizations.of(context)!.minutesLabel}'),
            if (item.note != null) _buildDetailRow(AppLocalizations.of(context)!.note, item.note!),
            const SizedBox(height: AppSizes.spacingL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.grey600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatsDialog(BuildContext context, List<TreatmentHistory> history) {
    // Calculer toutes les statistiques
    final taken = history.where((h) => h.status == TreatmentStatus.taken).length;
    final missed = history.where((h) => h.status == TreatmentStatus.missed).length;
    final skipped = history.where((h) => h.status == TreatmentStatus.skipped).length;
    final pending = history.where((h) => h.status == TreatmentStatus.pending).length;
    final total = history.length;

    // Calculer le taux d'observance (prises / total non-pending)
    final totalCompleted = total - pending;
    final compliance = totalCompleted > 0
        ? (taken / totalCompleted * 100).toStringAsFixed(1)
        : '0.0';

    // Calculer les prises en retard
    final takenLate = history.where((h) =>
      h.status == TreatmentStatus.taken &&
      h.delayInMinutes != null &&
      h.delayInMinutes! > 5
    ).length;

    // Calculer le pourcentage de chaque statut
    final takenPercent = totalCompleted > 0 ? (taken / totalCompleted * 100).toStringAsFixed(0) : '0';
    final missedPercent = totalCompleted > 0 ? (missed / totalCompleted * 100).toStringAsFixed(0) : '0';
    final skippedPercent = totalCompleted > 0 ? (skipped / totalCompleted * 100).toStringAsFixed(0) : '0';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.analytics_outlined, color: AppColors.primaryBlue),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.statsDetailed),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section: Vue d'ensemble
              Text(
                AppLocalizations.of(context)!.statsOverview,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.grey700,
                ),
              ),
              const SizedBox(height: 8),
              _buildStatItem(AppLocalizations.of(context)!.statsTotal, '$total', AppColors.info),
              _buildStatItem(AppLocalizations.of(context)!.statsCompleted, '$totalCompleted', AppColors.grey700),
              _buildStatItem(AppLocalizations.of(context)!.statsPending, '$pending', AppColors.warning),

              const Divider(height: 24),

              // Section: Détails des prises
              Text(
                AppLocalizations.of(context)!.statsDetails,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.grey700,
                ),
              ),
              const SizedBox(height: 8),
              _buildStatItemWithPercent('✓ ${AppLocalizations.of(context)!.statsSuccess}', '$taken', takenPercent, AppColors.success),
              _buildStatItemWithPercent('✕ ${AppLocalizations.of(context)!.statsMissed}', '$missed', missedPercent, AppColors.error),
              _buildStatItemWithPercent('⏭ ${AppLocalizations.of(context)!.statsSkipped}', '$skipped', skippedPercent, AppColors.warning),
              if (takenLate > 0)
                _buildStatItem('⏰ ${AppLocalizations.of(context)!.statsLate}', '$takenLate', AppColors.warning),

              const Divider(height: 24),

              // Section: Observance
              Text(
                AppLocalizations.of(context)!.complianceRate,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.grey700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: _getComplianceColor(double.parse(compliance)).withAlpha(26),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(
                    color: _getComplianceColor(double.parse(compliance)).withAlpha(77),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getComplianceIcon(double.parse(compliance)),
                          color: _getComplianceColor(double.parse(compliance)),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getComplianceLabel(double.parse(compliance), context),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getComplianceColor(double.parse(compliance)),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$compliance%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: _getComplianceColor(double.parse(compliance)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItemWithPercent(String label, String value, String percent, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, overflow: TextOverflow.ellipsis)),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                constraints: const BoxConstraints(minWidth: 40),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$percent%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getComplianceColor(double compliance) {
    if (compliance >= 90) return AppColors.success;
    if (compliance >= 70) return AppColors.warning;
    return AppColors.error;
  }

  IconData _getComplianceIcon(double compliance) {
    if (compliance >= 90) return Icons.sentiment_very_satisfied;
    if (compliance >= 70) return Icons.sentiment_satisfied;
    return Icons.sentiment_dissatisfied;
  }

  String _getComplianceLabel(double compliance, BuildContext context) {
    if (compliance >= 90) return AppLocalizations.of(context)!.complianceExcellent;
    if (compliance >= 70) return AppLocalizations.of(context)!.complianceGood;
    if (compliance >= 50) return AppLocalizations.of(context)!.complianceAverage;
    return AppLocalizations.of(context)!.compliancePoor;
  }
}

