import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'MediScan Helper'**
  String get appName;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Smart Personal Health Assistant'**
  String get appDescription;

  /// No description provided for @splashWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get splashWelcome;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get splashLoading;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get homeWelcome;

  /// No description provided for @homeStats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get homeStats;

  /// No description provided for @homeTotalMeds.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get homeTotalMeds;

  /// No description provided for @homeActiveReminders.
  ///
  /// In en, this message translates to:
  /// **'Active Reminders'**
  String get homeActiveReminders;

  /// No description provided for @homeTodayMeds.
  ///
  /// In en, this message translates to:
  /// **'To take today'**
  String get homeTodayMeds;

  /// No description provided for @menuScanPrescription.
  ///
  /// In en, this message translates to:
  /// **'Scan Prescription'**
  String get menuScanPrescription;

  /// No description provided for @menuMyMedications.
  ///
  /// In en, this message translates to:
  /// **'My Medications'**
  String get menuMyMedications;

  /// No description provided for @menuReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get menuReminders;

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersTitle;

  /// No description provided for @menuHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get menuHistory;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Prescription'**
  String get scanTitle;

  /// No description provided for @scanButton.
  ///
  /// In en, this message translates to:
  /// **'Start Scan'**
  String get scanButton;

  /// No description provided for @scanProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get scanProcessing;

  /// No description provided for @scanSuccess.
  ///
  /// In en, this message translates to:
  /// **'Scan successful!'**
  String get scanSuccess;

  /// No description provided for @scanError.
  ///
  /// In en, this message translates to:
  /// **'Scan error'**
  String get scanError;

  /// No description provided for @scanExtractedText.
  ///
  /// In en, this message translates to:
  /// **'Extracted Text'**
  String get scanExtractedText;

  /// No description provided for @scanExtractedEntities.
  ///
  /// In en, this message translates to:
  /// **'Detected Information'**
  String get scanExtractedEntities;

  /// No description provided for @scanSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get scanSaveButton;

  /// No description provided for @medsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Medications'**
  String get medsTitle;

  /// No description provided for @medsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Medication'**
  String get medsAdd;

  /// No description provided for @medsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get medsEdit;

  /// No description provided for @medsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get medsDelete;

  /// No description provided for @medsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No medications'**
  String get medsEmpty;

  /// No description provided for @medsActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get medsActiveLabel;

  /// No description provided for @medsInactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get medsInactiveLabel;

  /// No description provided for @medFormName.
  ///
  /// In en, this message translates to:
  /// **'Medication Name'**
  String get medFormName;

  /// No description provided for @medFormDosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get medFormDosage;

  /// No description provided for @medFormFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get medFormFrequency;

  /// No description provided for @medFormTimes.
  ///
  /// In en, this message translates to:
  /// **'Times'**
  String get medFormTimes;

  /// No description provided for @medFormStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get medFormStartDate;

  /// No description provided for @medFormEndDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get medFormEndDate;

  /// No description provided for @medFormExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get medFormExpiryDate;

  /// No description provided for @medFormBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get medFormBarcode;

  /// No description provided for @medFormImage.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get medFormImage;

  /// No description provided for @medFormSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get medFormSave;

  /// No description provided for @medFormCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get medFormCancel;

  /// No description provided for @freq1x.
  ///
  /// In en, this message translates to:
  /// **'Once a day'**
  String get freq1x;

  /// No description provided for @freq2x.
  ///
  /// In en, this message translates to:
  /// **'Twice a day'**
  String get freq2x;

  /// No description provided for @freq3x.
  ///
  /// In en, this message translates to:
  /// **'3 times a day'**
  String get freq3x;

  /// No description provided for @freq4x.
  ///
  /// In en, this message translates to:
  /// **'4 times a day'**
  String get freq4x;

  /// No description provided for @remindersUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get remindersUpcoming;

  /// No description provided for @remindersToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get remindersToday;

  /// No description provided for @remindersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reminders'**
  String get remindersEmpty;

  /// No description provided for @remindersActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get remindersActive;

  /// No description provided for @notifActionTaken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get notifActionTaken;

  /// No description provided for @notifActionSnooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze 15 min'**
  String get notifActionSnooze;

  /// No description provided for @notifActionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get notifActionSkip;

  /// No description provided for @notifTitle.
  ///
  /// In en, this message translates to:
  /// **'Medication Reminder'**
  String get notifTitle;

  /// No description provided for @notifBody.
  ///
  /// In en, this message translates to:
  /// **'Time to take your medication'**
  String get notifBody;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Treatment History'**
  String get historyTitle;

  /// No description provided for @historyAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get historyAll;

  /// No description provided for @historyActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get historyActive;

  /// No description provided for @historyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get historyCompleted;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No history'**
  String get historyEmpty;

  /// No description provided for @historyExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get historyExport;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsSecurityPin.
  ///
  /// In en, this message translates to:
  /// **'PIN Code'**
  String get settingsSecurityPin;

  /// No description provided for @settingsSecurityBio.
  ///
  /// In en, this message translates to:
  /// **'Biometrics'**
  String get settingsSecurityBio;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get settingsDeveloper;

  /// No description provided for @settingsSound.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get settingsSound;

  /// No description provided for @settingsVibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get settingsVibration;

  /// No description provided for @settingsSoundDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable sound feedback'**
  String get settingsSoundDescription;

  /// No description provided for @settingsVibrationDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable haptic feedback'**
  String get settingsVibrationDescription;

  /// No description provided for @langFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get langFrench;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get langArabic;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get validationInvalidEmail;

  /// No description provided for @validationInvalidDate.
  ///
  /// In en, this message translates to:
  /// **'Invalid date'**
  String get validationInvalidDate;

  /// No description provided for @validationInvalidTime.
  ///
  /// In en, this message translates to:
  /// **'Invalid time'**
  String get validationInvalidTime;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get errorNetwork;

  /// No description provided for @errorPermission.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get errorPermission;

  /// No description provided for @errorCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera access error'**
  String get errorCamera;

  /// No description provided for @errorStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage access error'**
  String get errorStorage;

  /// No description provided for @errorNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification error'**
  String get errorNotification;

  /// No description provided for @successSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get successSaved;

  /// No description provided for @successDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get successDeleted;

  /// No description provided for @successUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get successUpdated;

  /// No description provided for @expiryGood.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get expiryGood;

  /// No description provided for @expiryWarning.
  ///
  /// In en, this message translates to:
  /// **'Expires soon'**
  String get expiryWarning;

  /// No description provided for @expiryExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expiryExpired;

  /// No description provided for @permissionCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera permission required'**
  String get permissionCamera;

  /// No description provided for @permissionStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage permission required'**
  String get permissionStorage;

  /// No description provided for @permissionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notification permission required'**
  String get permissionNotifications;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @appearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSection;

  /// No description provided for @notificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSection;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSection;

  /// No description provided for @securitySection.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securitySection;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @feedbackSection.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackSection;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmMessage;

  /// No description provided for @notificationRemindersDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable medication reminders'**
  String get notificationRemindersDescription;

  /// No description provided for @pinCodeDescription.
  ///
  /// In en, this message translates to:
  /// **'Protect app with PIN code'**
  String get pinCodeDescription;

  /// No description provided for @biometricsDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable biometric authentication'**
  String get biometricsDescription;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @developedWith.
  ///
  /// In en, this message translates to:
  /// **'Developed with ❤️'**
  String get developedWith;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @mitLicense.
  ///
  /// In en, this message translates to:
  /// **'MIT License'**
  String get mitLicense;

  /// No description provided for @warningDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This app is an assistant and does not replace professional medical advice.'**
  String get warningDisclaimer;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @soundEnabled.
  ///
  /// In en, this message translates to:
  /// **'Sound enabled'**
  String get soundEnabled;

  /// No description provided for @soundDisabled.
  ///
  /// In en, this message translates to:
  /// **'Sound disabled'**
  String get soundDisabled;

  /// No description provided for @vibrationEnabled.
  ///
  /// In en, this message translates to:
  /// **'Vibration enabled'**
  String get vibrationEnabled;

  /// No description provided for @vibrationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Vibration disabled'**
  String get vibrationDisabled;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationsEnabled;

  /// No description provided for @notificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notificationsDisabled;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed'**
  String get languageChanged;

  /// No description provided for @themeChanged.
  ///
  /// In en, this message translates to:
  /// **'Theme changed'**
  String get themeChanged;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @multilingualInDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Multilingual - In Development'**
  String get multilingualInDevelopment;

  /// No description provided for @pinCodeInDevelopment.
  ///
  /// In en, this message translates to:
  /// **'PIN Code - In Development'**
  String get pinCodeInDevelopment;

  /// No description provided for @biometricsInDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Biometrics - In Development'**
  String get biometricsInDevelopment;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profile;

  /// No description provided for @homeGreetingQuestion.
  ///
  /// In en, this message translates to:
  /// **'How are you today?'**
  String get homeGreetingQuestion;

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @statActiveMeds.
  ///
  /// In en, this message translates to:
  /// **'Active Medications'**
  String get statActiveMeds;

  /// No description provided for @statInactiveMeds.
  ///
  /// In en, this message translates to:
  /// **'Inactive Medications'**
  String get statInactiveMeds;

  /// No description provided for @statDosesToday.
  ///
  /// In en, this message translates to:
  /// **'Doses Today'**
  String get statDosesToday;

  /// No description provided for @statExpiryAlerts.
  ///
  /// In en, this message translates to:
  /// **'Expiry Alerts'**
  String get statExpiryAlerts;

  /// No description provided for @expiryAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Expiry Alerts'**
  String get expiryAlertsTitle;

  /// No description provided for @expiryAlertsNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Everything is in order!'**
  String get expiryAlertsNoneTitle;

  /// No description provided for @expiryAlertsNoneBody.
  ///
  /// In en, this message translates to:
  /// **'No medications expire in the next 3 days'**
  String get expiryAlertsNoneBody;

  /// No description provided for @expiryAlertsClickToView.
  ///
  /// In en, this message translates to:
  /// **'Tap to view list'**
  String get expiryAlertsClickToView;

  /// No description provided for @expiryPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview:'**
  String get expiryPreview;

  /// No description provided for @expiryExpiredToday.
  ///
  /// In en, this message translates to:
  /// **'Expired today'**
  String get expiryExpiredToday;

  /// No description provided for @expiryExpiredDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Expired {days} days ago'**
  String expiryExpiredDaysAgo(Object days);

  /// No description provided for @expiryExpiresTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Expires tomorrow'**
  String get expiryExpiresTomorrow;

  /// No description provided for @expiryExpiresInDays.
  ///
  /// In en, this message translates to:
  /// **'Expires in {days} days'**
  String expiryExpiresInDays(Object days);

  /// No description provided for @expiryOthers.
  ///
  /// In en, this message translates to:
  /// **'+{count} others'**
  String expiryOthers(Object count);

  /// No description provided for @expirySummaryExpired.
  ///
  /// In en, this message translates to:
  /// **'{count} expired medication'**
  String expirySummaryExpired(Object count);

  /// No description provided for @expirySummaryExpiring.
  ///
  /// In en, this message translates to:
  /// **'{count} expiring soon'**
  String expirySummaryExpiring(Object count);

  /// No description provided for @medsTitleInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive Medications'**
  String get medsTitleInactive;

  /// No description provided for @medsTitleActive.
  ///
  /// In en, this message translates to:
  /// **'Active Medications'**
  String get medsTitleActive;

  /// No description provided for @medsTitleExpiring.
  ///
  /// In en, this message translates to:
  /// **'Expiry Alerts'**
  String get medsTitleExpiring;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a medication...'**
  String get searchHint;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterActiveOnly.
  ///
  /// In en, this message translates to:
  /// **'Show active only'**
  String get filterActiveOnly;

  /// No description provided for @searchCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get searchCloseTooltip;

  /// No description provided for @searchOpenTooltip.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchOpenTooltip;

  /// No description provided for @loadingMeds.
  ///
  /// In en, this message translates to:
  /// **'Loading medications...'**
  String get loadingMeds;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @medsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No medications'**
  String get medsEmptyTitle;

  /// No description provided for @medsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Start by adding your first medication'**
  String get medsEmptyBody;

  /// No description provided for @medsNoInactiveTitle.
  ///
  /// In en, this message translates to:
  /// **'No inactive medications'**
  String get medsNoInactiveTitle;

  /// No description provided for @medsNoInactiveBody.
  ///
  /// In en, this message translates to:
  /// **'All your medications are active!\nThat\'s good news.'**
  String get medsNoInactiveBody;

  /// No description provided for @medsNoActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'No active medications'**
  String get medsNoActiveTitle;

  /// No description provided for @medsNoActiveBody.
  ///
  /// In en, this message translates to:
  /// **'All your medications are disabled.\nEnable them to start reminders.'**
  String get medsNoActiveBody;

  /// No description provided for @medsNoSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get medsNoSearchTitle;

  /// No description provided for @medsNoSearchBody.
  ///
  /// In en, this message translates to:
  /// **'No medication matches your search\n\"{query}\"'**
  String medsNoSearchBody(Object query);

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @medsNoExpiringTitle.
  ///
  /// In en, this message translates to:
  /// **'No expiry alerts'**
  String get medsNoExpiringTitle;

  /// No description provided for @medsNoExpiringBody.
  ///
  /// In en, this message translates to:
  /// **'All your medications are strictly valid!\nNo medication expires in the next 3 days.'**
  String get medsNoExpiringBody;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @statTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get statTotal;

  /// No description provided for @statLabelActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statLabelActive;

  /// No description provided for @statLabelInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get statLabelInactive;

  /// No description provided for @statLabelAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get statLabelAlerts;

  /// No description provided for @medFormTitleAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Medication'**
  String get medFormTitleAdd;

  /// No description provided for @medFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Medication'**
  String get medFormTitleEdit;

  /// No description provided for @medFormSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get medFormSaving;

  /// No description provided for @medFormFillInfo.
  ///
  /// In en, this message translates to:
  /// **'Fill in medication details'**
  String get medFormFillInfo;

  /// No description provided for @medFormBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get medFormBasicInfo;

  /// No description provided for @medFormNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get medFormNameRequired;

  /// No description provided for @medFormDosageHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: 500mg, 10ml'**
  String get medFormDosageHint;

  /// No description provided for @medFormDosageRequired.
  ///
  /// In en, this message translates to:
  /// **'Dosage is required'**
  String get medFormDosageRequired;

  /// No description provided for @medFormActive.
  ///
  /// In en, this message translates to:
  /// **'Active Medication'**
  String get medFormActive;

  /// No description provided for @medFormActiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Treatment in progress'**
  String get medFormActiveDesc;

  /// No description provided for @medFormInactiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Treatment completed'**
  String get medFormInactiveDesc;

  /// No description provided for @medFormFreqAndTimes.
  ///
  /// In en, this message translates to:
  /// **'Frequency & Schedule'**
  String get medFormFreqAndTimes;

  /// No description provided for @medFormFreqLabel.
  ///
  /// In en, this message translates to:
  /// **'Frequency per day'**
  String get medFormFreqLabel;

  /// No description provided for @medFormFreqPerDay.
  ///
  /// In en, this message translates to:
  /// **'{count} times per day'**
  String medFormFreqPerDay(Object count);

  /// No description provided for @medFormTimesLabel.
  ///
  /// In en, this message translates to:
  /// **'Intake Times'**
  String get medFormTimesLabel;

  /// No description provided for @medFormTimeIndex.
  ///
  /// In en, this message translates to:
  /// **'Intake {index}'**
  String medFormTimeIndex(Object index);

  /// No description provided for @medFormDatesLabel.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get medFormDatesLabel;

  /// No description provided for @medFormEndDateOptional.
  ///
  /// In en, this message translates to:
  /// **'End Date (Optional)'**
  String get medFormEndDateOptional;

  /// No description provided for @medFormExpiryDateOptional.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date (Optional)'**
  String get medFormExpiryDateOptional;

  /// No description provided for @medFormSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get medFormSelectDate;

  /// No description provided for @medFormAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get medFormAdditionalInfo;

  /// No description provided for @medFormBarcodeOptional.
  ///
  /// In en, this message translates to:
  /// **'Barcode (Optional)'**
  String get medFormBarcodeOptional;

  /// No description provided for @medFormBarcodeHint.
  ///
  /// In en, this message translates to:
  /// **'Scan or enter code'**
  String get medFormBarcodeHint;

  /// No description provided for @medFormScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get medFormScan;

  /// No description provided for @medFormScanCancelled.
  ///
  /// In en, this message translates to:
  /// **'Scan cancelled'**
  String get medFormScanCancelled;

  /// No description provided for @medFormSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching for medication...'**
  String get medFormSearching;

  /// No description provided for @medFormConsultingDb.
  ///
  /// In en, this message translates to:
  /// **'Consulting database...'**
  String get medFormConsultingDb;

  /// No description provided for @medFormFound.
  ///
  /// In en, this message translates to:
  /// **'Medication found!'**
  String get medFormFound;

  /// No description provided for @medFormSaved.
  ///
  /// In en, this message translates to:
  /// **'Medication added successfully'**
  String get medFormSaved;

  /// No description provided for @medFormChangesSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get medFormChangesSaved;

  /// No description provided for @medFormManufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer: {name}'**
  String medFormManufacturer(Object name);

  /// No description provided for @medFormSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get medFormSaveChanges;

  /// No description provided for @medFormAddBtn.
  ///
  /// In en, this message translates to:
  /// **'Add Medication'**
  String get medFormAddBtn;

  /// No description provided for @medFormCancelBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get medFormCancelBtn;

  /// No description provided for @remindersNotificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get remindersNotificationsEnabled;

  /// No description provided for @remindersNotificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get remindersNotificationsDisabled;

  /// No description provided for @remindersEnabledDesc.
  ///
  /// In en, this message translates to:
  /// **'You will receive reminders for your medications'**
  String get remindersEnabledDesc;

  /// No description provided for @remindersDisabledDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications to receive reminders'**
  String get remindersDisabledDesc;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @remindersTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Test Notifications'**
  String get remindersTestTitle;

  /// No description provided for @remindersTestBody.
  ///
  /// In en, this message translates to:
  /// **'Send a test notification to check functionality'**
  String get remindersTestBody;

  /// No description provided for @remindersTestBtn.
  ///
  /// In en, this message translates to:
  /// **'Send test notification'**
  String get remindersTestBtn;

  /// No description provided for @remindersMyMeds.
  ///
  /// In en, this message translates to:
  /// **'My Medications ({count})'**
  String remindersMyMeds(Object count);

  /// No description provided for @remindersHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a time to toggle reminder'**
  String get remindersHint;

  /// No description provided for @remindersNoActiveMeds.
  ///
  /// In en, this message translates to:
  /// **'No active medications'**
  String get remindersNoActiveMeds;

  /// No description provided for @remindersAddMedsHint.
  ///
  /// In en, this message translates to:
  /// **'Add medications to set up reminders'**
  String get remindersAddMedsHint;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @remindersScheduled.
  ///
  /// In en, this message translates to:
  /// **'Notifications checked and scheduled'**
  String get remindersScheduled;

  /// No description provided for @markAsTaken.
  ///
  /// In en, this message translates to:
  /// **'Mark as taken'**
  String get markAsTaken;

  /// No description provided for @markAsSkipped.
  ///
  /// In en, this message translates to:
  /// **'Mark as skipped'**
  String get markAsSkipped;

  /// No description provided for @remindersNoTimesConfigured.
  ///
  /// In en, this message translates to:
  /// **'No intake times configured'**
  String get remindersNoTimesConfigured;

  /// No description provided for @remindersAllTaken.
  ///
  /// In en, this message translates to:
  /// **'All doses marked as taken'**
  String get remindersAllTaken;

  /// No description provided for @remindersAllSkipped.
  ///
  /// In en, this message translates to:
  /// **'All doses marked as skipped'**
  String get remindersAllSkipped;

  /// No description provided for @remindersSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Select intake time:'**
  String get remindersSelectTime;

  /// No description provided for @remindersAllCompleted.
  ///
  /// In en, this message translates to:
  /// **'All doses for today are completed'**
  String get remindersAllCompleted;

  /// No description provided for @notificationTimeForMed.
  ///
  /// In en, this message translates to:
  /// **'It\'s time to take your medication ({dosage})'**
  String notificationTimeForMed(Object dosage);

  /// No description provided for @filterHistory.
  ///
  /// In en, this message translates to:
  /// **'Filter History'**
  String get filterHistory;

  /// No description provided for @filterTaken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get filterTaken;

  /// No description provided for @filterMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get filterMissed;

  /// No description provided for @filterSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get filterSkipped;

  /// No description provided for @historyToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get historyToday;

  /// No description provided for @historyWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get historyWeek;

  /// No description provided for @historyAllTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get historyAllTime;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTitle;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No history available'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your medication records will appear here'**
  String get historyEmptyBody;

  /// No description provided for @historyYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get historyYesterday;

  /// No description provided for @dateRangeSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected period: {start} - {end}'**
  String dateRangeSelected(Object end, Object start);

  /// No description provided for @statsDetailed.
  ///
  /// In en, this message translates to:
  /// **'Detailed Statistics'**
  String get statsDetailed;

  /// No description provided for @statsOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get statsOverview;

  /// No description provided for @statsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Doses'**
  String get statsTotal;

  /// No description provided for @statsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed Doses'**
  String get statsCompleted;

  /// No description provided for @statsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statsPending;

  /// No description provided for @statsDetails.
  ///
  /// In en, this message translates to:
  /// **'Dose Details'**
  String get statsDetails;

  /// No description provided for @statsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successful Doses'**
  String get statsSuccess;

  /// No description provided for @statsMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed Doses'**
  String get statsMissed;

  /// No description provided for @statsSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped Doses'**
  String get statsSkipped;

  /// No description provided for @statsLate.
  ///
  /// In en, this message translates to:
  /// **'Late Doses (>5min)'**
  String get statsLate;

  /// No description provided for @complianceRate.
  ///
  /// In en, this message translates to:
  /// **'Compliance Rate'**
  String get complianceRate;

  /// No description provided for @complianceExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get complianceExcellent;

  /// No description provided for @complianceGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get complianceGood;

  /// No description provided for @complianceAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get complianceAverage;

  /// No description provided for @compliancePoor.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement'**
  String get compliancePoor;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @scheduledTime.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Time'**
  String get scheduledTime;

  /// No description provided for @takenTime.
  ///
  /// In en, this message translates to:
  /// **'Taken Time'**
  String get takenTime;

  /// No description provided for @delay.
  ///
  /// In en, this message translates to:
  /// **'Delay'**
  String get delay;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @minutesLate.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes late'**
  String minutesLate(Object minutes);

  /// No description provided for @minutesLabel.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutesLabel;

  /// No description provided for @scanHeader.
  ///
  /// In en, this message translates to:
  /// **'Scan Prescription'**
  String get scanHeader;

  /// No description provided for @scanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use AI to automatically extract information'**
  String get scanSubtitle;

  /// No description provided for @scanMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a method'**
  String get scanMethodTitle;

  /// No description provided for @scanTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get scanTakePhoto;

  /// No description provided for @scanCameraSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan with camera'**
  String get scanCameraSubtitle;

  /// No description provided for @scanPickImage.
  ///
  /// In en, this message translates to:
  /// **'Pick an image'**
  String get scanPickImage;

  /// No description provided for @scanGallerySubtitle.
  ///
  /// In en, this message translates to:
  /// **'From your gallery'**
  String get scanGallerySubtitle;

  /// No description provided for @scanTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tips for a better scan'**
  String get scanTipsTitle;

  /// No description provided for @scanTipLight.
  ///
  /// In en, this message translates to:
  /// **'Good lighting'**
  String get scanTipLight;

  /// No description provided for @scanTipSharp.
  ///
  /// In en, this message translates to:
  /// **'Sharp image'**
  String get scanTipSharp;

  /// No description provided for @scanTipFlat.
  ///
  /// In en, this message translates to:
  /// **'Document flat'**
  String get scanTipFlat;

  /// No description provided for @scanTipHandwriting.
  ///
  /// In en, this message translates to:
  /// **'Handwriting supported'**
  String get scanTipHandwriting;

  /// No description provided for @scanCaptured.
  ///
  /// In en, this message translates to:
  /// **'Captured'**
  String get scanCaptured;

  /// No description provided for @scanCapturedTitle.
  ///
  /// In en, this message translates to:
  /// **'Prescription captured'**
  String get scanCapturedTitle;

  /// No description provided for @scanCapturedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready for analysis'**
  String get scanCapturedSubtitle;

  /// No description provided for @scanDetectedMeds.
  ///
  /// In en, this message translates to:
  /// **'{count} medication(s) detected'**
  String scanDetectedMeds(Object count);

  /// No description provided for @scanNoText.
  ///
  /// In en, this message translates to:
  /// **'No text detected'**
  String get scanNoText;

  /// No description provided for @scanConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm addition'**
  String get scanConfirmTitle;

  /// No description provided for @scanConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You are about to add {count} medication(s):'**
  String scanConfirmBody(Object count);

  /// No description provided for @scanScheduleWarning.
  ///
  /// In en, this message translates to:
  /// **'Intake times will be generated automatically. You can modify them later.'**
  String get scanScheduleWarning;

  /// No description provided for @scanNoMedsToSave.
  ///
  /// In en, this message translates to:
  /// **'No medication detected to save'**
  String get scanNoMedsToSave;

  /// No description provided for @scanNew.
  ///
  /// In en, this message translates to:
  /// **'New scan'**
  String get scanNew;

  /// No description provided for @frequencyDay.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get frequencyDay;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @seeMoreMeds.
  ///
  /// In en, this message translates to:
  /// **'See {count} more'**
  String seeMoreMeds(Object count);

  /// No description provided for @homeMedsSummary.
  ///
  /// In en, this message translates to:
  /// **'{total} total • {active} active'**
  String homeMedsSummary(Object active, Object total);

  /// No description provided for @homeUpcomingReminders.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Reminders'**
  String get homeUpcomingReminders;

  /// No description provided for @commonInMin.
  ///
  /// In en, this message translates to:
  /// **'In {min} min'**
  String commonInMin(Object min);

  /// No description provided for @commonInHoursMin.
  ///
  /// In en, this message translates to:
  /// **'In {hours}h {min}min'**
  String commonInHoursMin(Object hours, Object min);

  /// No description provided for @dosesPerDay.
  ///
  /// In en, this message translates to:
  /// **'{count} doses/day'**
  String dosesPerDay(Object count);

  /// No description provided for @commonActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get commonActive;

  /// No description provided for @commonInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get commonInactive;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileTitle;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @editProfileComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile - Coming soon'**
  String get editProfileComingSoon;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String memberSince(Object date);

  /// No description provided for @statTotalMeds.
  ///
  /// In en, this message translates to:
  /// **'Total Medications'**
  String get statTotalMeds;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @displayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayNameLabel;

  /// No description provided for @userIdLabel.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userIdLabel;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Change Password - Coming soon'**
  String get changePasswordComingSoon;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action is irreversible and all your data will be lost.'**
  String get deleteAccountConfirmBody;

  /// No description provided for @deleteAccountComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Account Deletion - Coming soon'**
  String get deleteAccountComingSoon;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @untilDate.
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String untilDate(Object date);

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @confirmDeactivateTitle.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Medication'**
  String get confirmDeactivateTitle;

  /// No description provided for @confirmActivateTitle.
  ///
  /// In en, this message translates to:
  /// **'Activate Medication'**
  String get confirmActivateTitle;

  /// No description provided for @confirmDeactivateBody.
  ///
  /// In en, this message translates to:
  /// **'Do you want to deactivate \"{name}\"?\n\nReminders will be paused and it will no longer appear in active medications.'**
  String confirmDeactivateBody(Object name);

  /// No description provided for @confirmActivateBody.
  ///
  /// In en, this message translates to:
  /// **'Do you want to activate \"{name}\"?\n\nReminders will be reactivated and it will appear in active medications.'**
  String confirmActivateBody(Object name);

  /// No description provided for @medicationDeactivated.
  ///
  /// In en, this message translates to:
  /// **'✅ {name} disabled'**
  String medicationDeactivated(Object name);

  /// No description provided for @medicationActivated.
  ///
  /// In en, this message translates to:
  /// **'✅ {name} enabled'**
  String medicationActivated(Object name);

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Confirmation'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String confirmDeleteBody(Object name);

  /// No description provided for @detailsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Details of {name} - In development'**
  String detailsComingSoon(Object name);

  /// No description provided for @homeTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Timeline'**
  String get homeTimelineTitle;

  /// No description provided for @homeTimelineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No schedule today'**
  String get homeTimelineEmpty;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
