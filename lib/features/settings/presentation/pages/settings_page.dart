import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediscanhelper/core/constants/app_colors.dart';
import 'package:mediscanhelper/core/constants/app_strings.dart';
import 'package:mediscanhelper/core/constants/app_sizes.dart';
import 'package:mediscanhelper/core/theme/theme_provider.dart';
import 'package:mediscanhelper/core/theme/settings_provider.dart';
import 'package:mediscanhelper/core/utils/feedback_service.dart';
import 'package:mediscanhelper/features/auth/presentation/providers/auth_provider.dart' as auth;
import 'package:mediscanhelper/features/auth/presentation/pages/login_page.dart';
import 'package:mediscanhelper/l10n/app_localizations.dart';

/// Page des paramètres de l'application
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final feedbackService = Provider.of<FeedbackService>(context);
    final authProvider = Provider.of<auth.AuthProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          children: [
            // Section Compte
            if (authProvider.isAuthenticated) ...[
              _buildSectionTitle(context, l10n.accountSection),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
                        child: Text(
                          authProvider.currentUser?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(authProvider.currentUser?.displayName ?? l10n.user),
                      subtitle: Text(authProvider.currentUser?.email ?? ''),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
                      onTap: () async {
                        await feedbackService.click();
                        _handleLogout(context, authProvider, feedbackService, l10n);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spacingL),
            ],

            // Section Apparence
            _buildSectionTitle(context, l10n.appearanceSection),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.palette_outlined),
                    title: Text(l10n.settingsTheme),
                    subtitle: Text(_getThemeModeName(themeProvider.themeMode, l10n)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      await feedbackService.click();
                      _showThemeDialog(context, themeProvider, feedbackService, l10n);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spacingL),

            // Section Retour
            _buildSectionTitle(context, l10n.feedbackSection),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.volume_up_outlined),
                    title: Text(l10n.settingsSound),
                    subtitle: Text(l10n.settingsSoundDescription),
                    value: feedbackService.isSoundEnabled,
                    onChanged: (value) async {
                      await feedbackService.setSoundEnabled(value);
                      await feedbackService.click();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              value ? l10n.soundEnabled : l10n.soundDisabled,
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.vibration_outlined),
                    title: Text(l10n.settingsVibration),
                    subtitle: Text(l10n.settingsVibrationDescription),
                    value: feedbackService.isVibrationEnabled,
                    onChanged: (value) async {
                      await feedbackService.setVibrationEnabled(value);
                      await feedbackService.vibrate(HapticType.medium);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              value ? l10n.vibrationEnabled : l10n.vibrationDisabled,
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spacingL),

            // Section Notifications
            _buildSectionTitle(context, l10n.notificationsSection),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_outlined),
                    title: Text(l10n.settingsNotifications),
                    subtitle: Text(l10n.notificationRemindersDescription),
                    value: settingsProvider.notificationsEnabled,
                    onChanged: (value) async {
                      await feedbackService.selection();
                      await settingsProvider.setNotificationsEnabled(value);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              value ? l10n.notificationsEnabled : l10n.notificationsDisabled,
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spacingL),

            // Section Langue
            _buildSectionTitle(context, l10n.languageSection),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language_outlined),
                    title: Text(l10n.settingsLanguage),
                    subtitle: Text(settingsProvider.getLanguageName(settingsProvider.locale)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      await feedbackService.click();
                      _showLanguageDialog(context, settingsProvider, feedbackService, l10n);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spacingL),

            // Section Sécurité
            _buildSectionTitle(context, l10n.securitySection),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.lock_outlined),
                    title: Text(l10n.settingsSecurityPin),
                    subtitle: Text(l10n.pinCodeDescription),
                    value: false, // TODO: Lier à la vraie valeur
                    onChanged: (value) async {
                      await feedbackService.click();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.pinCodeInDevelopment),
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.fingerprint_outlined),
                    title: Text(l10n.settingsSecurityBio),
                    subtitle: Text(l10n.biometricsDescription),
                    value: false, // TODO: Lier à la vraie valeur
                    onChanged: (value) async {
                      await feedbackService.click();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.biometricsInDevelopment),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spacingL),

            // Section À propos
            _buildSectionTitle(context, l10n.aboutSection),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outlined),
                    title: Text(l10n.version),
                    subtitle: const Text(AppStrings.appVersion),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.code_outlined),
                    title: Text(l10n.settingsDeveloper),
                    subtitle: Text(l10n.developedWith),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text(l10n.license),
                    subtitle: Text(l10n.mitLicense),
                    onTap: () async {
                      await feedbackService.click();
                      // TODO: Afficher la licence
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spacingXl),

            // Note importante
            Card(
              color: AppColors.warning.withAlpha(26),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_outlined,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: AppSizes.spacingM),
                    Expanded(
                      child: Text(
                        l10n.warningDisclaimer,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(
    BuildContext context,
    auth.AuthProvider authProvider,
    FeedbackService feedbackService,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () {
              feedbackService.click();
              Navigator.of(context).pop(false);
            },
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              feedbackService.click();
              Navigator.of(context).pop(true);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await authProvider.signOutUser();

      if (context.mounted) {
        if (success) {
          await feedbackService.success();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        } else {
          await feedbackService.error();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.errorGeneric)),
          );
        }
      }
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.paddingS,
        bottom: AppSizes.paddingS,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  String _getThemeModeName(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.settingsThemeLight;
      case ThemeMode.dark:
        return l10n.settingsThemeDark;
      case ThemeMode.system:
        return l10n.settingsThemeSystem;
    }
  }

  void _showThemeDialog(
    BuildContext context,
    ThemeProvider themeProvider,
    FeedbackService feedbackService,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsTheme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.settingsThemeLight),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (value) async {
                if (value != null) {
                  await feedbackService.selection();
                  await themeProvider.setThemeMode(value);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.themeChanged),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.settingsThemeDark),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (value) async {
                if (value != null) {
                  await feedbackService.selection();
                  await themeProvider.setThemeMode(value);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.themeChanged),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.settingsThemeSystem),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (value) async {
                if (value != null) {
                  await feedbackService.selection();
                  await themeProvider.setThemeMode(value);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.themeChanged),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await feedbackService.click();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    SettingsProvider settingsProvider,
    FeedbackService feedbackService,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: SettingsProvider.supportedLocales.map((locale) {
            return RadioListTile<Locale>(
              title: Text(settingsProvider.getLanguageName(locale)),
              value: locale,
              groupValue: settingsProvider.locale,
              onChanged: (value) async {
                if (value != null) {
                  await feedbackService.selection();
                  await settingsProvider.setLocale(value);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.languageChanged),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await feedbackService.click();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}

