import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediscanhelper/core/constants/app_colors.dart';
import 'package:mediscanhelper/core/constants/app_strings.dart';
import 'package:mediscanhelper/core/constants/app_sizes.dart';
import 'package:mediscanhelper/features/medications/domain/entities/medication.dart';
import 'package:mediscanhelper/features/medications/presentation/providers/medication_provider.dart';
import 'package:mediscanhelper/features/medications/presentation/pages/medication_form_page.dart';
import 'package:mediscanhelper/core/utils/formatters.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mediscanhelper/l10n/app_localizations.dart';
import 'package:mediscanhelper/core/utils/feedback_service.dart';

/// Page de liste des médicaments - Design moderne
class MedicationsListPage extends StatefulWidget {
  final bool showInactiveOnly;
  final bool showActiveOnly;
  final bool showExpiringOnly;

  const MedicationsListPage({
    super.key,
    this.showInactiveOnly = false,
    this.showActiveOnly = false,
    this.showExpiringOnly = false,
  });

  @override
  State<MedicationsListPage> createState() => _MedicationsListPageState();
}

class _MedicationsListPageState extends State<MedicationsListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    // Charger les médicaments au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicationProvider>().loadMedications();

      // Si on doit afficher uniquement les inactifs, désactiver le filtre "actifs seulement"
      if (widget.showInactiveOnly) {
        final provider = context.read<MedicationProvider>();
        if (provider.showActiveOnly) {
          provider.toggleShowActive();
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filtrer les médicaments selon la recherche
  List<Medication> _filterMedications(List<Medication> medications) {
    if (_searchQuery.isEmpty) {
      return medications;
    }

    final query = _searchQuery.toLowerCase();
    return medications.where((med) {
      return med.name.toLowerCase().contains(query) ||
             med.dosage.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Déterminer le titre selon le mode
    String pageTitle = l10n.medsTitle;
    if (widget.showInactiveOnly) {
      pageTitle = l10n.medsTitleInactive;
    } else if (widget.showActiveOnly) {
      pageTitle = l10n.medsTitleActive;
    } else if (widget.showExpiringOnly) {
      pageTitle = l10n.medsTitleExpiring;
    }

    return Scaffold(
      // backgroundColor: AppColors.grey50, // Removed to use Theme background
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Text(pageTitle),
        elevation: 0,
        actions: [
          // Filtre actif/tous (masqué si showInactiveOnly ou showActiveOnly ou showExpiringOnly ou en recherche)
          if (!widget.showInactiveOnly && !widget.showActiveOnly && !widget.showExpiringOnly && !_isSearching)
            Consumer<MedicationProvider>(
              builder: (context, provider, _) {
                return IconButton(
                  icon: Icon(
                    provider.showActiveOnly
                        ? Icons.filter_alt
                        : Icons.filter_alt_off,
                  ),
                  tooltip: provider.showActiveOnly
                      ? l10n.filterAll
                      : l10n.filterActiveOnly,
                  onPressed: () => provider.toggleShowActive(),
                );
              },
            ),
          // Bouton recherche
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            tooltip: _isSearching ? l10n.searchCloseTooltip : l10n.searchOpenTooltip,
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<MedicationProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading && provider.allMedications.isEmpty) {
              return _buildLoadingState();
            }

            if (provider.errorMessage != null) {
              return _buildErrorState(provider.errorMessage!, provider);
            }

            // Filtrer pour afficher uniquement les actifs ou inactifs si demandé
            List<Medication> displayedMedications;
            if (widget.showInactiveOnly) {
              displayedMedications = provider.allMedications.where((m) => !m.isActive).toList();
            } else if (widget.showActiveOnly) {
              displayedMedications = provider.allMedications.where((m) => m.isActive).toList();
            } else if (widget.showExpiringOnly) {
              // Afficher les médicaments expirés ou expirant dans les 3 prochains jours
              final now = DateTime.now();
              displayedMedications = provider.allMedications.where((m) {
                if (!m.isActive) return false;
                if (m.expiryDate == null) return false;

                // Inclure les médicaments expirés
                if (m.isExpired) return true;

                // Inclure les médicaments expirant dans les 3 prochains jours
                final daysUntilExpiry = m.expiryDate!.difference(now).inDays;
                return daysUntilExpiry >= 0 && daysUntilExpiry <= 3;
              }).toList();
            } else {
              displayedMedications = provider.medications;
            }

            // Appliquer le filtre de recherche
            displayedMedications = _filterMedications(displayedMedications);

            if (displayedMedications.isEmpty) {
              // Si on est en recherche et qu'il n'y a pas de résultats
              if (_isSearching && _searchQuery.isNotEmpty) {
                return _buildNoSearchResultsState();
              }

              if (widget.showInactiveOnly) {
                return _buildNoInactiveMedicationsState();
              } else if (widget.showActiveOnly) {
                return _buildNoActiveMedicationsState();
              } else if (widget.showExpiringOnly) {
                return _buildNoExpiringMedicationsState();
              } else {
                return _buildEmptyState();
              }
            }

            return _buildMedicationsList(provider, displayedMedications);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<FeedbackService>().click();
          _addMedication();
        },
        backgroundColor: AppColors.secondaryGreen,
        elevation: 4,
        tooltip: l10n.medsAdd,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// État de chargement
  Widget _buildLoadingState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSizes.spacingL),
          Text(
            l10n.loadingMeds,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.grey600,
                ),
          ),
        ],
      ),
    );
  }

  /// État d'erreur
  Widget _buildErrorState(String error, MedicationProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.error.withAlpha(128),
            ),
            const SizedBox(height: AppSizes.spacingL),
            Text(
              l10n.errorTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
            ),
            const SizedBox(height: AppSizes.spacingM),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSizes.spacingXl),
            ElevatedButton.icon(
              onPressed: () => provider.loadMedications(),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingXl,
                  vertical: AppSizes.paddingM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// État vide
  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingXl),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondaryGreen.withAlpha(26),
                    AppColors.primaryBlue.withAlpha(26),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              ),
              child: Icon(
                Icons.medication_outlined,
                size: 100,
                color: AppColors.secondaryGreen.withAlpha(128),
              ),
            )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  duration: 2.seconds,
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                ),
            const SizedBox(height: AppSizes.spacingXl),
            Text(
              l10n.medsEmptyTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey700,
                  ),
            ),
            const SizedBox(height: AppSizes.spacingM),
            Text(
              l10n.medsEmptyBody,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacingXl),
            ElevatedButton.icon(
              onPressed: _addMedication,
              icon: const Icon(Icons.add),
              label: Text(l10n.medsAdd),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryGreen,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingXl,
                  vertical: AppSizes.paddingL,
                ),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// État vide pour les médicaments inactifs
  Widget _buildNoInactiveMedicationsState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingXl),
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(26),
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 100,
                color: AppColors.success,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  duration: 2.seconds,
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                ),
            const SizedBox(height: AppSizes.spacingXl),
            Text(
              l10n.medsNoInactiveTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
            ),
            const SizedBox(height: AppSizes.spacingM),
            Text(
              l10n.medsNoInactiveBody,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacingXl),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: Text(l10n.back),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingXl,
                  vertical: AppSizes.paddingM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// État vide pour les médicaments actifs
  Widget _buildNoActiveMedicationsState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingXl),
              decoration: BoxDecoration(
                color: AppColors.grey400.withAlpha(26),
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              ),
              child: Icon(
                Icons.archive_outlined,
                size: 100,
                color: AppColors.grey600,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  duration: 2.seconds,
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                ),
            const SizedBox(height: AppSizes.spacingXl),
            Text(
              l10n.medsNoActiveTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey700,
                  ),
            ),
            const SizedBox(height: AppSizes.spacingM),
            Text(
              l10n.medsNoActiveBody,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacingXl),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: Text(l10n.back),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingXl,
                  vertical: AppSizes.paddingM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// État aucun résultat de recherche
  Widget _buildNoSearchResultsState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingXl),
              decoration: BoxDecoration(
                color: AppColors.info.withAlpha(26),
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              ),
              child: Icon(
                Icons.search_off,
                size: 100,
                color: AppColors.info,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  duration: 2.seconds,
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                ),
            const SizedBox(height: AppSizes.spacingXl),
            Text(
              l10n.medsNoSearchTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey700,
                  ),
            ),
            const SizedBox(height: AppSizes.spacingM),
            Text(
              l10n.medsNoSearchBody(_searchQuery),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacingXl),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              icon: const Icon(Icons.clear),
              label: Text(l10n.clearSearch),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingXl,
                  vertical: AppSizes.paddingM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// État vide pour les médicaments expirant bientôt
  Widget _buildNoExpiringMedicationsState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingXl),
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(26),
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 100,
                color: AppColors.success,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  duration: 2.seconds,
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                ),
            const SizedBox(height: AppSizes.spacingXl),
            Text(
              l10n.medsNoExpiringTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
            ),
            const SizedBox(height: AppSizes.spacingM),
            Text(
              l10n.medsNoExpiringBody,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacingXl),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: Text(l10n.back),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingXl,
                  vertical: AppSizes.paddingM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Liste des médicaments
  Widget _buildMedicationsList(MedicationProvider provider, List<Medication> medications) {
    return RefreshIndicator(
      onRefresh: () => provider.loadMedications(),
      child: CustomScrollView(
        slivers: [
          // En-tête avec statistiques
          SliverToBoxAdapter(
            child: _buildHeader(provider, medications)
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.2, end: 0),
          ),

          // Liste des médicaments
          SliverPadding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final medication = medications[index];
                  return _buildMedicationCard(medication, index)
                      .animate()
                      .fadeIn(
                        duration: 400.ms,
                        delay: Duration(milliseconds: 50 * index),
                      )
                      .slideX(begin: -0.2, end: 0);
                },
                childCount: medications.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// En-tête avec statistiques
  Widget _buildHeader(MedicationProvider provider, List<Medication> medications) {
    // Use ALL medications from provider for total count
    final allMedications = provider.allMedications;
    final totalActiveMeds = allMedications.where((m) => m.isActive).length;
    final totalInactiveMeds = allMedications.where((m) => !m.isActive).length;

    // Count in the filtered list (what's currently displayed)
    final displayedActiveMeds = medications.where((m) => m.isActive).length;
    final displayedInactiveMeds = medications.where((m) => !m.isActive).length;

    // Determine second stat based on filter mode
    return _buildStatsCard(
      context,
      medications,
      totalActiveMeds,
      displayedActiveMeds,
      displayedInactiveMeds,
    );
  }

  Widget _buildStatsCard(
    BuildContext context,
    List<Medication> medications,
    int totalActiveMeds,
    int displayedActiveMeds,
    int displayedInactiveMeds,
  ) {
    String secondLabel;
    int secondValue;
    IconData secondIcon;
    Color secondColor;
    
    final l10n = AppLocalizations.of(context)!;

    if (widget.showInactiveOnly) {
      secondLabel = l10n.statLabelInactive;
      secondValue = displayedInactiveMeds;
      secondIcon = Icons.cancel;
      secondColor = AppColors.grey600;
    } else if (widget.showActiveOnly) {
      secondLabel = l10n.statLabelActive;
      secondValue = displayedActiveMeds;
      secondIcon = Icons.check_circle;
      secondColor = AppColors.secondaryGreen;
    } else if (widget.showExpiringOnly) {
      secondLabel = l10n.statLabelAlerts;
      secondValue = medications.length; // All shown are expiring
      secondIcon = Icons.warning_amber;
      secondColor = AppColors.warning;
    } else {
      // Default view - show active count
      secondLabel = l10n.statLabelActive;
      secondValue = totalActiveMeds;
      secondIcon = Icons.check_circle;
      secondColor = AppColors.secondaryGreen;
    }

    return Container(
      margin: const EdgeInsets.all(AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3), // Soft tint
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.medication,
              label: l10n.statTotal,
              value: '${medications.length}', // Changed from allMedications to medications (passed in) or provider access? Assuming medications is the list.
              color: AppColors.primaryBlue,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.grey300,
          ),
          Expanded(
            child: _buildStatItem(
              icon: secondIcon,
              label: secondLabel,
              value: '$secondValue',
              color: secondColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Item de statistique
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: AppSizes.iconL),
        const SizedBox(height: AppSizes.spacingS),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }

  /// Card d'un médicament
  Widget _buildMedicationCard(Medication medication, int index) {
    // Déterminer la couleur selon l'expiration
    final l10n = AppLocalizations.of(context)!;
    Color expiryColor = AppColors.expiryGood;
    String expiryLabel = 'OK';
    IconData expiryIcon = Icons.check_circle;

    if (medication.isExpired) {
      expiryColor = AppColors.expiryExpired;
      expiryLabel = l10n.expiryExpired;
      expiryIcon = Icons.cancel;
    } else if (medication.isExpiringSoon) {
      expiryColor = AppColors.expiryWarning;
      expiryLabel = l10n.expiryWarning;
      expiryIcon = Icons.warning;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingM),
      elevation: 0, // Flat style
      color: Theme.of(context).cardColor, // Use theme color (Surface/Grey800)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        side: medication.isExpired
            ? BorderSide(color: AppColors.error.withOpacity(0.5), width: 1)
            : BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: InkWell(
        onTap: () => _viewMedicationDetails(medication),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec nom et badge
              Row(
                children: [
                  // Icône
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingS),
                    decoration: BoxDecoration(
                      color: medication.isActive
                          ? AppColors.secondaryGreen.withAlpha(26)
                          : AppColors.grey400.withAlpha(26),
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                    child: Icon(
                      Icons.medication,
                      color: medication.isActive
                          ? AppColors.secondaryGreen
                          : AppColors.grey600,
                      size: AppSizes.iconM,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacingM),
                  // Nom et dosage
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                medication.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: medication.isActive
                                      ? null
                                      : AppColors.grey600,
                                ),
                              ),
                            ),
                            // Badge Actif/Inactif
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: medication.isActive
                                    ? AppColors.success.withAlpha(26)
                                    : AppColors.grey400.withAlpha(26),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    medication.isActive
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    size: 12,
                                    color: medication.isActive
                                        ? AppColors.success
                                        : AppColors.grey600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    medication.isActive ? l10n.commonActive : l10n.commonInactive,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: medication.isActive
                                          ? AppColors.success
                                          : AppColors.grey600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          medication.dosage,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacingS),
                  // Badge d'expiration
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingS,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: expiryColor.withAlpha(26),
                      borderRadius: BorderRadius.circular(AppSizes.radiusS),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(expiryIcon, size: 14, color: expiryColor),
                        const SizedBox(width: 4),
                        Text(
                          expiryLabel,
                          style: TextStyle(
                            color: expiryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spacingM),

              // Informations
              Row(
                children: [
                    _buildInfoChip(
                    icon: Icons.access_time,
                    label: l10n.dosesPerDay(medication.frequency),
                    color: AppColors.info,
                  ),
                  const SizedBox(width: AppSizes.spacingS),
                  if (medication.endDate != null)
                    _buildInfoChip(
                      icon: Icons.event,
                      label: l10n.untilDate(Formatters.formatDate(medication.endDate!)),
                      color: AppColors.warning,
                    ),
                ],
              ),

              const SizedBox(height: AppSizes.spacingM),

              // Actions
              Row(
                children: [
                  // Bouton Activer/Désactiver
                  Flexible(
                    flex: 2,
                    child: OutlinedButton.icon(
                      onPressed: () => _toggleMedicationActive(medication),
                      icon: Icon(
                        medication.isActive ? Icons.pause_circle_outline : Icons.play_circle_outline,
                        size: 16,
                      ),
                      label: Text(
                        medication.isActive ? l10n.deactivate : l10n.activate,
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: medication.isActive
                            ? AppColors.warning
                            : AppColors.success,
                        side: BorderSide(
                          color: medication.isActive
                              ? AppColors.warning
                              : AppColors.success,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Bouton Modifier
                  Flexible(
                    child: IconButton(
                      onPressed: () => _editMedication(medication),
                      icon: const Icon(Icons.edit, size: 20),
                      color: AppColors.primaryBlue,
                      tooltip: l10n.edit,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  // Bouton Supprimer
                  Flexible(
                    child: IconButton(
                      onPressed: () => _deleteMedication(medication),
                      icon: const Icon(Icons.delete, size: 20),
                      color: AppColors.error,
                      tooltip: l10n.delete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Chip d'information
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Ajouter un médicament
  void _addMedication() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MedicationFormPage(),
      ),
    );
  }

  /// Modifier un médicament
  void _editMedication(Medication medication) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MedicationFormPage(medication: medication),
      ),
    );
  }

  /// Activer/Désactiver un médicament
  void _toggleMedicationActive(Medication medication) async {
    final provider = context.read<MedicationProvider>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
        ),
        title: Row(
          children: [
            Icon(
              medication.isActive ? Icons.pause_circle : Icons.play_circle,
              color: medication.isActive ? AppColors.warning : AppColors.success,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                medication.isActive ? l10n.confirmDeactivateTitle : l10n.confirmActivateTitle,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          medication.isActive
              ? l10n.confirmDeactivateBody(medication.name)
              : l10n.confirmActivateBody(medication.name),
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: medication.isActive ? AppColors.warning : AppColors.success,
            ),
            child: Text(medication.isActive ? l10n.deactivate : l10n.activate),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await provider.toggleMedicationActive(medication);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                medication.isActive
                    ? '✅ ${medication.name} a été désactivé'
                    : '✅ ${medication.name} a été activé',
              ),
              backgroundColor: medication.isActive ? AppColors.warning : AppColors.success,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorGeneric),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  /// Supprimer un médicament
  void _deleteMedication(Medication medication) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingS),
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(26),
                borderRadius: BorderRadius.circular(AppSizes.radiusS),
              ),
              child: const Icon(Icons.delete, color: AppColors.error),
            ),
            const SizedBox(width: AppSizes.spacingM),
            Expanded(child: Text(l10n.confirmDeleteTitle)),
          ],
        ),
        content: Text(l10n.confirmDeleteBody(medication.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await context
                  .read<MedicationProvider>()
                  .removeMedication(medication.id);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? AppStrings.successDeleted
                          : 'Erreur lors de la suppression',
                    ),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  /// Voir les détails d'un médicament
  void _viewMedicationDetails(Medication medication) {
    // TODO: Navigation vers page détails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.detailsComingSoon(medication.name)),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
