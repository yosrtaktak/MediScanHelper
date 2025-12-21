/// Chaînes de caractères de l'application
class AppStrings {
  AppStrings._();

  // App Info
  static const String appName = 'MediScan Helper';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Assistant santé personnel intelligent';

  // Splash Screen
  static const String splashWelcome = 'Bienvenue';
  static const String splashLoading = 'Chargement...';

  // Home Screen
  static const String homeTitle = 'Accueil';
  static const String homeWelcome = 'Bonjour';
  static const String homeStats = 'Statistiques';
  static const String homeTotalMeds = 'Médicaments';
  static const String homeActiveReminders = 'Rappels actifs';
  static const String homeTodayMeds = 'À prendre aujourd\'hui';

  // Menu Items
  static const String menuScanPrescription = 'Scanner ordonnance';
  static const String menuMyMedications = 'Mes médicaments';
  static const String menuReminders = 'Rappels';
  static const String menuHistory = 'Historique';
  static const String menuSettings = 'Paramètres';

  // Scanner Screen
  static const String scanTitle = 'Scanner ordonnance';
  static const String scanButton = 'Démarrer le scan';
  static const String scanProcessing = 'Traitement en cours...';
  static const String scanSuccess = 'Scan réussi !';
  static const String scanError = 'Erreur lors du scan';
  static const String scanExtractedText = 'Texte extrait';
  static const String scanExtractedEntities = 'Informations détectées';
  static const String scanSaveButton = 'Enregistrer';

  // Medications Screen
  static const String medsTitle = 'Mes médicaments';
  static const String medsAdd = 'Ajouter un médicament';
  static const String medsEdit = 'Modifier';
  static const String medsDelete = 'Supprimer';
  static const String medsEmpty = 'Aucun médicament';
  static const String medsActiveLabel = 'En cours';
  static const String medsInactiveLabel = 'Terminé';

  // Medication Form
  static const String medFormName = 'Nom du médicament';
  static const String medFormDosage = 'Dosage';
  static const String medFormFrequency = 'Fréquence';
  static const String medFormTimes = 'Heures de prise';
  static const String medFormStartDate = 'Date de début';
  static const String medFormEndDate = 'Date de fin';
  static const String medFormExpiryDate = 'Date d\'expiration';
  static const String medFormBarcode = 'Code-barres';
  static const String medFormImage = 'Photo';
  static const String medFormSave = 'Enregistrer';
  static const String medFormCancel = 'Annuler';

  // Frequency Options
  static const String freq1x = '1 fois par jour';
  static const String freq2x = '2 fois par jour';
  static const String freq3x = '3 fois par jour';
  static const String freq4x = '4 fois par jour';

  // Reminders Screen
  static const String remindersTitle = 'Rappels';
  static const String remindersUpcoming = 'À venir';
  static const String remindersToday = 'Aujourd\'hui';
  static const String remindersEmpty = 'Aucun rappel';
  static const String remindersActive = 'Actifs';

  // Notification Actions
  static const String notifActionTaken = 'Pris';
  static const String notifActionSnooze = 'Reporter 15 min';
  static const String notifActionSkip = 'Ignorer';
  static const String notifTitle = 'Rappel de médicament';
  static const String notifBody = 'Il est temps de prendre votre médicament';

  // History Screen
  static const String historyTitle = 'Historique';
  static const String historyAll = 'Tous';
  static const String historyActive = 'En cours';
  static const String historyCompleted = 'Terminés';
  static const String historyEmpty = 'Aucun historique';
  static const String historyExport = 'Exporter';

  // Settings Screen
  static const String settingsTitle = 'Paramètres';
  static const String settingsTheme = 'Thème';
  static const String settingsThemeLight = 'Clair';
  static const String settingsThemeDark = 'Sombre';
  static const String settingsThemeSystem = 'Système';
  static const String settingsLanguage = 'Langue';
  static const String settingsNotifications = 'Notifications';
  static const String settingsSecurity = 'Sécurité';
  static const String settingsSecurityPin = 'Code PIN';
  static const String settingsSecurityBio = 'Biométrie';
  static const String settingsAbout = 'À propos';
  static const String settingsDeveloper = 'Développeur';

  // Languages
  static const String langFrench = 'Français';
  static const String langEnglish = 'English';
  static const String langArabic = 'العربية';

  // Common
  static const String yes = 'Oui';
  static const String no = 'Non';
  static const String ok = 'OK';
  static const String cancel = 'Annuler';
  static const String save = 'Enregistrer';
  static const String delete = 'Supprimer';
  static const String edit = 'Modifier';
  static const String add = 'Ajouter';
  static const String search = 'Rechercher';
  static const String filter = 'Filtrer';
  static const String close = 'Fermer';
  static const String confirm = 'Confirmer';

  // Validation
  static const String validationRequired = 'Ce champ est requis';
  static const String validationInvalidEmail = 'Email invalide';
  static const String validationInvalidDate = 'Date invalide';
  static const String validationInvalidTime = 'Heure invalide';

  // Errors
  static const String errorGeneric = 'Une erreur s\'est produite';
  static const String errorNetwork = 'Erreur de connexion';
  static const String errorPermission = 'Permission refusée';
  static const String errorCamera = 'Erreur d\'accès à la caméra';
  static const String errorStorage = 'Erreur d\'accès au stockage';
  static const String errorNotification = 'Erreur de notification';

  // Success Messages
  static const String successSaved = 'Enregistré avec succès';
  static const String successDeleted = 'Supprimé avec succès';
  static const String successUpdated = 'Mis à jour avec succès';

  // Expiry Status
  static const String expiryGood = 'Valide';
  static const String expiryWarning = 'Expire bientôt';
  static const String expiryExpired = 'Expiré';

  // Permissions
  static const String permissionCamera = 'Permission caméra nécessaire';
  static const String permissionStorage = 'Permission stockage nécessaire';
  static const String permissionNotifications = 'Permission notifications nécessaire';
}

