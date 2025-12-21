// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'MediScan Helper';

  @override
  String get appDescription => 'Smart Personal Health Assistant';

  @override
  String get splashWelcome => 'Welcome';

  @override
  String get splashLoading => 'Loading...';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeWelcome => 'Hello';

  @override
  String get homeStats => 'Statistics';

  @override
  String get homeTotalMeds => 'Medications';

  @override
  String get homeActiveReminders => 'Active Reminders';

  @override
  String get homeTodayMeds => 'To take today';

  @override
  String get menuScanPrescription => 'Scan Prescription';

  @override
  String get menuMyMedications => 'My Medications';

  @override
  String get menuReminders => 'Reminders';

  @override
  String get remindersTitle => 'Reminders';

  @override
  String get menuHistory => 'History';

  @override
  String get menuSettings => 'Settings';

  @override
  String get scanTitle => 'Scan Prescription';

  @override
  String get scanButton => 'Start Scan';

  @override
  String get scanProcessing => 'Processing...';

  @override
  String get scanSuccess => 'Scan successful!';

  @override
  String get scanError => 'Scan error';

  @override
  String get scanExtractedText => 'Extracted Text';

  @override
  String get scanExtractedEntities => 'Detected Information';

  @override
  String get scanSaveButton => 'Save';

  @override
  String get medsTitle => 'My Medications';

  @override
  String get medsAdd => 'Add Medication';

  @override
  String get medsEdit => 'Edit';

  @override
  String get medsDelete => 'Delete';

  @override
  String get medsEmpty => 'No medications';

  @override
  String get medsActiveLabel => 'Active';

  @override
  String get medsInactiveLabel => 'Completed';

  @override
  String get medFormName => 'Medication Name';

  @override
  String get medFormDosage => 'Dosage';

  @override
  String get medFormFrequency => 'Frequency';

  @override
  String get medFormTimes => 'Times';

  @override
  String get medFormStartDate => 'Start Date';

  @override
  String get medFormEndDate => 'End Date';

  @override
  String get medFormExpiryDate => 'Expiry Date';

  @override
  String get medFormBarcode => 'Barcode';

  @override
  String get medFormImage => 'Photo';

  @override
  String get medFormSave => 'Save';

  @override
  String get medFormCancel => 'Cancel';

  @override
  String get freq1x => 'Once a day';

  @override
  String get freq2x => 'Twice a day';

  @override
  String get freq3x => '3 times a day';

  @override
  String get freq4x => '4 times a day';

  @override
  String get remindersUpcoming => 'Upcoming';

  @override
  String get remindersToday => 'Today';

  @override
  String get remindersEmpty => 'No reminders';

  @override
  String get remindersActive => 'Active';

  @override
  String get notifActionTaken => 'Taken';

  @override
  String get notifActionSnooze => 'Snooze 15 min';

  @override
  String get notifActionSkip => 'Skip';

  @override
  String get notifTitle => 'Medication Reminder';

  @override
  String get notifBody => 'Time to take your medication';

  @override
  String get historyTitle => 'Treatment History';

  @override
  String get historyAll => 'All';

  @override
  String get historyActive => 'Active';

  @override
  String get historyCompleted => 'Completed';

  @override
  String get historyEmpty => 'No history';

  @override
  String get historyExport => 'Export';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsSecurityPin => 'PIN Code';

  @override
  String get settingsSecurityBio => 'Biometrics';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsDeveloper => 'Developer';

  @override
  String get settingsSound => 'Sound Effects';

  @override
  String get settingsVibration => 'Vibration';

  @override
  String get settingsSoundDescription => 'Enable sound feedback';

  @override
  String get settingsVibrationDescription => 'Enable haptic feedback';

  @override
  String get langFrench => 'Français';

  @override
  String get langEnglish => 'English';

  @override
  String get langArabic => 'العربية';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationInvalidEmail => 'Invalid email';

  @override
  String get validationInvalidDate => 'Invalid date';

  @override
  String get validationInvalidTime => 'Invalid time';

  @override
  String get errorGeneric => 'An error occurred';

  @override
  String get errorNetwork => 'Connection error';

  @override
  String get errorPermission => 'Permission denied';

  @override
  String get errorCamera => 'Camera access error';

  @override
  String get errorStorage => 'Storage access error';

  @override
  String get errorNotification => 'Notification error';

  @override
  String get successSaved => 'Saved successfully';

  @override
  String get successDeleted => 'Deleted successfully';

  @override
  String get successUpdated => 'Updated successfully';

  @override
  String get expiryGood => 'Valid';

  @override
  String get expiryWarning => 'Expires soon';

  @override
  String get expiryExpired => 'Expired';

  @override
  String get permissionCamera => 'Camera permission required';

  @override
  String get permissionStorage => 'Storage permission required';

  @override
  String get permissionNotifications => 'Notification permission required';

  @override
  String get accountSection => 'Account';

  @override
  String get appearanceSection => 'Appearance';

  @override
  String get notificationsSection => 'Notifications';

  @override
  String get languageSection => 'Language';

  @override
  String get securitySection => 'Security';

  @override
  String get aboutSection => 'About';

  @override
  String get feedbackSection => 'Feedback';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to logout?';

  @override
  String get notificationRemindersDescription => 'Enable medication reminders';

  @override
  String get pinCodeDescription => 'Protect app with PIN code';

  @override
  String get biometricsDescription => 'Enable biometric authentication';

  @override
  String get version => 'Version';

  @override
  String get developedWith => 'Developed with ❤️';

  @override
  String get license => 'License';

  @override
  String get mitLicense => 'MIT License';

  @override
  String get warningDisclaimer =>
      'This app is an assistant and does not replace professional medical advice.';

  @override
  String get user => 'User';

  @override
  String get soundEnabled => 'Sound enabled';

  @override
  String get soundDisabled => 'Sound disabled';

  @override
  String get vibrationEnabled => 'Vibration enabled';

  @override
  String get vibrationDisabled => 'Vibration disabled';

  @override
  String get notificationsEnabled => 'Notifications enabled';

  @override
  String get notificationsDisabled => 'Notifications disabled';

  @override
  String get languageChanged => 'Language changed';

  @override
  String get themeChanged => 'Theme changed';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get multilingualInDevelopment => 'Multilingual - In Development';

  @override
  String get pinCodeInDevelopment => 'PIN Code - In Development';

  @override
  String get biometricsInDevelopment => 'Biometrics - In Development';

  @override
  String get profile => 'My Profile';

  @override
  String get homeGreetingQuestion => 'How are you today?';

  @override
  String get menuTitle => 'Menu';

  @override
  String get statActiveMeds => 'Active Medications';

  @override
  String get statInactiveMeds => 'Inactive Medications';

  @override
  String get statDosesToday => 'Doses Today';

  @override
  String get statExpiryAlerts => 'Expiry Alerts';

  @override
  String get expiryAlertsTitle => 'Expiry Alerts';

  @override
  String get expiryAlertsNoneTitle => 'Everything is in order!';

  @override
  String get expiryAlertsNoneBody => 'No medications expire in the next 3 days';

  @override
  String get expiryAlertsClickToView => 'Tap to view list';

  @override
  String get expiryPreview => 'Preview:';

  @override
  String get expiryExpiredToday => 'Expired today';

  @override
  String expiryExpiredDaysAgo(Object days) {
    return 'Expired $days days ago';
  }

  @override
  String get expiryExpiresTomorrow => 'Expires tomorrow';

  @override
  String expiryExpiresInDays(Object days) {
    return 'Expires in $days days';
  }

  @override
  String expiryOthers(Object count) {
    return '+$count others';
  }

  @override
  String expirySummaryExpired(Object count) {
    return '$count expired medication';
  }

  @override
  String expirySummaryExpiring(Object count) {
    return '$count expiring soon';
  }

  @override
  String get medsTitleInactive => 'Inactive Medications';

  @override
  String get medsTitleActive => 'Active Medications';

  @override
  String get medsTitleExpiring => 'Expiry Alerts';

  @override
  String get searchHint => 'Search for a medication...';

  @override
  String get filterAll => 'All';

  @override
  String get filterActiveOnly => 'Show active only';

  @override
  String get searchCloseTooltip => 'Close search';

  @override
  String get searchOpenTooltip => 'Search';

  @override
  String get loadingMeds => 'Loading medications...';

  @override
  String get errorTitle => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get medsEmptyTitle => 'No medications';

  @override
  String get medsEmptyBody => 'Start by adding your first medication';

  @override
  String get medsNoInactiveTitle => 'No inactive medications';

  @override
  String get medsNoInactiveBody =>
      'All your medications are active!\nThat\'s good news.';

  @override
  String get medsNoActiveTitle => 'No active medications';

  @override
  String get medsNoActiveBody =>
      'All your medications are disabled.\nEnable them to start reminders.';

  @override
  String get medsNoSearchTitle => 'No results';

  @override
  String medsNoSearchBody(Object query) {
    return 'No medication matches your search\n\"$query\"';
  }

  @override
  String get clearSearch => 'Clear search';

  @override
  String get medsNoExpiringTitle => 'No expiry alerts';

  @override
  String get medsNoExpiringBody =>
      'All your medications are strictly valid!\nNo medication expires in the next 3 days.';

  @override
  String get back => 'Back';

  @override
  String get statTotal => 'Total';

  @override
  String get statLabelActive => 'Active';

  @override
  String get statLabelInactive => 'Inactive';

  @override
  String get statLabelAlerts => 'Alerts';

  @override
  String get medFormTitleAdd => 'Add Medication';

  @override
  String get medFormTitleEdit => 'Edit Medication';

  @override
  String get medFormSaving => 'Saving...';

  @override
  String get medFormFillInfo => 'Fill in medication details';

  @override
  String get medFormBasicInfo => 'Basic Information';

  @override
  String get medFormNameRequired => 'Name is required';

  @override
  String get medFormDosageHint => 'Ex: 500mg, 10ml';

  @override
  String get medFormDosageRequired => 'Dosage is required';

  @override
  String get medFormActive => 'Active Medication';

  @override
  String get medFormActiveDesc => 'Treatment in progress';

  @override
  String get medFormInactiveDesc => 'Treatment completed';

  @override
  String get medFormFreqAndTimes => 'Frequency & Schedule';

  @override
  String get medFormFreqLabel => 'Frequency per day';

  @override
  String medFormFreqPerDay(Object count) {
    return '$count times per day';
  }

  @override
  String get medFormTimesLabel => 'Intake Times';

  @override
  String medFormTimeIndex(Object index) {
    return 'Intake $index';
  }

  @override
  String get medFormDatesLabel => 'Dates';

  @override
  String get medFormEndDateOptional => 'End Date (Optional)';

  @override
  String get medFormExpiryDateOptional => 'Expiry Date (Optional)';

  @override
  String get medFormSelectDate => 'Select a date';

  @override
  String get medFormAdditionalInfo => 'Additional Information';

  @override
  String get medFormBarcodeOptional => 'Barcode (Optional)';

  @override
  String get medFormBarcodeHint => 'Scan or enter code';

  @override
  String get medFormScan => 'Scan';

  @override
  String get medFormScanCancelled => 'Scan cancelled';

  @override
  String get medFormSearching => 'Searching for medication...';

  @override
  String get medFormConsultingDb => 'Consulting database...';

  @override
  String get medFormFound => 'Medication found!';

  @override
  String get medFormSaved => 'Medication added successfully';

  @override
  String get medFormChangesSaved => 'Changes saved';

  @override
  String medFormManufacturer(Object name) {
    return 'Manufacturer: $name';
  }

  @override
  String get medFormSaveChanges => 'Save Changes';

  @override
  String get medFormAddBtn => 'Add Medication';

  @override
  String get medFormCancelBtn => 'Cancel';

  @override
  String get remindersNotificationsEnabled => 'Notifications enabled';

  @override
  String get remindersNotificationsDisabled => 'Notifications disabled';

  @override
  String get remindersEnabledDesc =>
      'You will receive reminders for your medications';

  @override
  String get remindersDisabledDesc =>
      'Enable notifications to receive reminders';

  @override
  String get activate => 'Activate';

  @override
  String get remindersTestTitle => 'Test Notifications';

  @override
  String get remindersTestBody =>
      'Send a test notification to check functionality';

  @override
  String get remindersTestBtn => 'Send test notification';

  @override
  String remindersMyMeds(Object count) {
    return 'My Medications ($count)';
  }

  @override
  String get remindersHint => 'Tap a time to toggle reminder';

  @override
  String get remindersNoActiveMeds => 'No active medications';

  @override
  String get remindersAddMedsHint => 'Add medications to set up reminders';

  @override
  String get refresh => 'Refresh';

  @override
  String get remindersScheduled => 'Notifications checked and scheduled';

  @override
  String get markAsTaken => 'Mark as taken';

  @override
  String get markAsSkipped => 'Mark as skipped';

  @override
  String get remindersNoTimesConfigured => 'No intake times configured';

  @override
  String get remindersAllTaken => 'All doses marked as taken';

  @override
  String get remindersAllSkipped => 'All doses marked as skipped';

  @override
  String get remindersSelectTime => 'Select intake time:';

  @override
  String get remindersAllCompleted => 'All doses for today are completed';

  @override
  String notificationTimeForMed(Object dosage) {
    return 'It\'s time to take your medication ($dosage)';
  }

  @override
  String get filterHistory => 'Filter History';

  @override
  String get filterTaken => 'Taken';

  @override
  String get filterMissed => 'Missed';

  @override
  String get filterSkipped => 'Skipped';

  @override
  String get historyToday => 'Today';

  @override
  String get historyWeek => 'This Week';

  @override
  String get historyAllTime => 'All Time';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get historyEmptyTitle => 'No history available';

  @override
  String get historyEmptyBody => 'Your medication records will appear here';

  @override
  String get historyYesterday => 'Yesterday';

  @override
  String dateRangeSelected(Object end, Object start) {
    return 'Selected period: $start - $end';
  }

  @override
  String get statsDetailed => 'Detailed Statistics';

  @override
  String get statsOverview => 'Overview';

  @override
  String get statsTotal => 'Total Doses';

  @override
  String get statsCompleted => 'Completed Doses';

  @override
  String get statsPending => 'Pending';

  @override
  String get statsDetails => 'Dose Details';

  @override
  String get statsSuccess => 'Successful Doses';

  @override
  String get statsMissed => 'Missed Doses';

  @override
  String get statsSkipped => 'Skipped Doses';

  @override
  String get statsLate => 'Late Doses (>5min)';

  @override
  String get complianceRate => 'Compliance Rate';

  @override
  String get complianceExcellent => 'Excellent';

  @override
  String get complianceGood => 'Good';

  @override
  String get complianceAverage => 'Average';

  @override
  String get compliancePoor => 'Needs Improvement';

  @override
  String get status => 'Status';

  @override
  String get scheduledTime => 'Scheduled Time';

  @override
  String get takenTime => 'Taken Time';

  @override
  String get delay => 'Delay';

  @override
  String get note => 'Note';

  @override
  String minutesLate(Object minutes) {
    return '$minutes minutes late';
  }

  @override
  String get minutesLabel => 'minutes';

  @override
  String get scanHeader => 'Scan Prescription';

  @override
  String get scanSubtitle => 'Use AI to automatically extract information';

  @override
  String get scanMethodTitle => 'Choose a method';

  @override
  String get scanTakePhoto => 'Take a photo';

  @override
  String get scanCameraSubtitle => 'Scan with camera';

  @override
  String get scanPickImage => 'Pick an image';

  @override
  String get scanGallerySubtitle => 'From your gallery';

  @override
  String get scanTipsTitle => 'Tips for a better scan';

  @override
  String get scanTipLight => 'Good lighting';

  @override
  String get scanTipSharp => 'Sharp image';

  @override
  String get scanTipFlat => 'Document flat';

  @override
  String get scanTipHandwriting => 'Handwriting supported';

  @override
  String get scanCaptured => 'Captured';

  @override
  String get scanCapturedTitle => 'Prescription captured';

  @override
  String get scanCapturedSubtitle => 'Ready for analysis';

  @override
  String scanDetectedMeds(Object count) {
    return '$count medication(s) detected';
  }

  @override
  String get scanNoText => 'No text detected';

  @override
  String get scanConfirmTitle => 'Confirm addition';

  @override
  String scanConfirmBody(Object count) {
    return 'You are about to add $count medication(s):';
  }

  @override
  String get scanScheduleWarning =>
      'Intake times will be generated automatically. You can modify them later.';

  @override
  String get scanNoMedsToSave => 'No medication detected to save';

  @override
  String get scanNew => 'New scan';

  @override
  String get frequencyDay => 'day';

  @override
  String get seeAll => 'See all';

  @override
  String seeMoreMeds(Object count) {
    return 'See $count more';
  }

  @override
  String homeMedsSummary(Object active, Object total) {
    return '$total total • $active active';
  }

  @override
  String get homeUpcomingReminders => 'Upcoming Reminders';

  @override
  String commonInMin(Object min) {
    return 'In $min min';
  }

  @override
  String commonInHoursMin(Object hours, Object min) {
    return 'In ${hours}h ${min}min';
  }

  @override
  String dosesPerDay(Object count) {
    return '$count doses/day';
  }

  @override
  String get commonActive => 'Active';

  @override
  String get commonInactive => 'Inactive';

  @override
  String get profileTitle => 'My Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get editProfileComingSoon => 'Edit Profile - Coming soon';

  @override
  String memberSince(Object date) {
    return 'Member since $date';
  }

  @override
  String get statTotalMeds => 'Total Medications';

  @override
  String get emailLabel => 'Email';

  @override
  String get displayNameLabel => 'Display Name';

  @override
  String get userIdLabel => 'User ID';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changePasswordComingSoon => 'Change Password - Coming soon';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirmTitle => 'Delete Account';

  @override
  String get deleteAccountConfirmBody =>
      'Are you sure you want to delete your account? This action is irreversible and all your data will be lost.';

  @override
  String get deleteAccountComingSoon => 'Account Deletion - Coming soon';

  @override
  String get unknown => 'Unknown';

  @override
  String untilDate(Object date) {
    return 'Until $date';
  }

  @override
  String get deactivate => 'Deactivate';

  @override
  String get confirmDeactivateTitle => 'Deactivate Medication';

  @override
  String get confirmActivateTitle => 'Activate Medication';

  @override
  String confirmDeactivateBody(Object name) {
    return 'Do you want to deactivate \"$name\"?\n\nReminders will be paused and it will no longer appear in active medications.';
  }

  @override
  String confirmActivateBody(Object name) {
    return 'Do you want to activate \"$name\"?\n\nReminders will be reactivated and it will appear in active medications.';
  }

  @override
  String medicationDeactivated(Object name) {
    return '✅ $name disabled';
  }

  @override
  String medicationActivated(Object name) {
    return '✅ $name enabled';
  }

  @override
  String get confirmDeleteTitle => 'Delete Confirmation';

  @override
  String confirmDeleteBody(Object name) {
    return 'Are you sure you want to delete $name?';
  }

  @override
  String detailsComingSoon(Object name) {
    return 'Details of $name - In development';
  }

  @override
  String get homeTimelineTitle => 'Today\'s Timeline';

  @override
  String get homeTimelineEmpty => 'No schedule today';
}
