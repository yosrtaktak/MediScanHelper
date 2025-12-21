import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediscanhelper/core/constants/app_colors.dart';
import 'package:mediscanhelper/core/constants/app_sizes.dart';
import 'package:mediscanhelper/features/auth/presentation/providers/auth_provider.dart';
import 'package:mediscanhelper/features/auth/presentation/pages/auth_wrapper.dart';
import 'package:mediscanhelper/features/auth/presentation/pages/login_page.dart';
import 'package:mediscanhelper/features/home/presentation/pages/home_page.dart';
import 'package:mediscanhelper/features/medications/presentation/pages/medications_list_page.dart';
import 'package:mediscanhelper/features/prescription_scanner/presentation/pages/scanner_page.dart';
import 'package:mediscanhelper/features/reminders/presentation/pages/reminders_page.dart';
import 'package:mediscanhelper/features/history/presentation/pages/treatment_history_page.dart';
import 'package:mediscanhelper/features/settings/presentation/pages/settings_page.dart';
import 'package:mediscanhelper/features/profile/presentation/pages/profile_page.dart';
import 'package:mediscanhelper/features/medications/presentation/providers/medication_provider.dart';
import 'package:mediscanhelper/features/reminders/presentation/providers/reminder_provider.dart';
import 'package:mediscanhelper/l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      child: Column(
        children: [
          // Modern header without avatar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingL,
              AppSizes.paddingXl + 40,
              AppSizes.paddingL,
              AppSizes.paddingL,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.primaryBlueDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? l10n.user,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingXs),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingM),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingM,
                      vertical: AppSizes.paddingS,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.profile,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Liste des items de navigation
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home_outlined,
                  title: l10n.homeTitle,
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    // If we are already on home, generally we don't need to push, but for simplicity let's check
                    // Ideally we might want a better navigation strategy ensuring Home is root.
                    // Since this drawer is used IN HomePage, we just close it.
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.camera_alt_outlined,
                  title: l10n.menuScanPrescription,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ScannerPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.medication_outlined,
                  title: l10n.menuMyMedications,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MedicationsListPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.alarm,
                  title: l10n.menuReminders,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RemindersPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.history,
                  title: l10n.menuHistory,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TreatmentHistoryPage()),
                    );
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline,
                  title: l10n.profile,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: l10n.settingsTitle,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                ),
              ],
            ),
          ),

          // Bouton de déconnexion en bas
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: SafeArea(
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red.shade700),
                title: Text(
                  l10n.logout,
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                tileColor: Colors.red.withOpacity(0.05),
                onTap: () => _handleLogout(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? Colors.white70 : AppColors.grey800;
    
    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.white60 : AppColors.grey700),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      dense: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
    );
  }

  void _handleLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    print('🔓 Showing logout confirmation dialog...');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red.shade700),
            const SizedBox(width: 12),
            Text(l10n.logoutConfirmTitle),
          ],
        ),
        content: Text(
          l10n.logoutConfirmMessage,
          style: const TextStyle(fontSize: 16),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        actions: [
          TextButton(
            onPressed: () {
              print('🔓 Cancel button pressed');
              Navigator.of(dialogContext).pop(false);
            },
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              print('🔓 Logout button pressed');
              Navigator.of(dialogContext).pop(true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
    
    print('🔓 Dialog result: $confirmed (runtimeType: ${confirmed.runtimeType})');
    print('🔓 Context mounted: ${context.mounted}');

    if (confirmed != true) {
      print('🔓 Logout cancelled by user');
      return;
    }
    
    if (!context.mounted) {
      print('🔓 Context not mounted after dialog, cannot proceed');
      return;
    }
    
    // Close drawer after confirmation
    Navigator.pop(context);

    print('🔓 Logout confirmed, starting logout process...');
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final medicationProvider = Provider.of<MedicationProvider>(context, listen: false);
    final reminderProvider = Provider.of<ReminderProvider>(context, listen: false);
    
    print('🔓 Current user before logout: ${authProvider.currentUser?.email}');
    print('🔓 Is authenticated before logout: ${authProvider.isAuthenticated}');
    
    // Clear all provider data before logout
    print('🔓 Clearing provider data...');
    medicationProvider.clearAllData();
    reminderProvider.clearAllData();
    
    // Perform logout
    final success = await authProvider.signOutUser();
    
    print('🔓 Logout result: $success');
    print('🔓 Current user after logout: ${authProvider.currentUser?.email}');
    print('🔓 Is authenticated after logout: ${authProvider.isAuthenticated}');

    if (!context.mounted) {
      print('🔓 Context not mounted after signOut');
      return;
    }
    
    if (success) {
      print('🔓 Logout successful, navigating to AuthWrapper...');
      // Wait a brief moment to ensure state is updated
      await Future.delayed(const Duration(milliseconds: 100));
      
      if (context.mounted) {
        // Navigate to AuthWrapper which will show LoginPage
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
          (route) => false,
        );
        print('🔓 Navigation to AuthWrapper completed');
      } else {
        print('🔓 Context not mounted, cannot navigate');
      }
    } else {
      print('🔓 Logout failed: ${authProvider.errorMessage}');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? l10n.errorGeneric),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
