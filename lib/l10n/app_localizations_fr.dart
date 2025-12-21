// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'MediScan Helper';

  @override
  String get appDescription => 'Assistant santé personnel intelligent';

  @override
  String get splashWelcome => 'Bienvenue';

  @override
  String get splashLoading => 'Chargement...';

  @override
  String get homeTitle => 'Accueil';

  @override
  String get homeWelcome => 'Bonjour';

  @override
  String get homeStats => 'Statistiques';

  @override
  String get homeTotalMeds => 'Médicaments';

  @override
  String get homeActiveReminders => 'Rappels actifs';

  @override
  String get homeTodayMeds => 'À prendre aujourd\'hui';

  @override
  String get menuScanPrescription => 'Scanner ordonnance';

  @override
  String get menuMyMedications => 'Mes médicaments';

  @override
  String get menuReminders => 'Rappels';

  @override
  String get remindersTitle => 'Rappels';

  @override
  String get menuHistory => 'Historique';

  @override
  String get menuSettings => 'Paramètres';

  @override
  String get scanTitle => 'Scanner ordonnance';

  @override
  String get scanButton => 'Démarrer le scan';

  @override
  String get scanProcessing => 'Traitement en cours...';

  @override
  String get scanSuccess => 'Scan réussi !';

  @override
  String get scanError => 'Erreur lors du scan';

  @override
  String get scanExtractedText => 'Texte extrait';

  @override
  String get scanExtractedEntities => 'Informations détectées';

  @override
  String get scanSaveButton => 'Enregistrer';

  @override
  String get medsTitle => 'Mes médicaments';

  @override
  String get medsAdd => 'Ajouter un médicament';

  @override
  String get medsEdit => 'Modifier';

  @override
  String get medsDelete => 'Supprimer';

  @override
  String get medsEmpty => 'Aucun médicament';

  @override
  String get medsActiveLabel => 'En cours';

  @override
  String get medsInactiveLabel => 'Terminé';

  @override
  String get medFormName => 'Nom du médicament';

  @override
  String get medFormDosage => 'Dosage';

  @override
  String get medFormFrequency => 'Fréquence';

  @override
  String get medFormTimes => 'Heures de prise';

  @override
  String get medFormStartDate => 'Date de début';

  @override
  String get medFormEndDate => 'Date de fin';

  @override
  String get medFormExpiryDate => 'Date d\'expiration';

  @override
  String get medFormBarcode => 'Code-barres';

  @override
  String get medFormImage => 'Photo';

  @override
  String get medFormSave => 'Enregistrer';

  @override
  String get medFormCancel => 'Annuler';

  @override
  String get freq1x => '1 fois par jour';

  @override
  String get freq2x => '2 fois par jour';

  @override
  String get freq3x => '3 fois par jour';

  @override
  String get freq4x => '4 fois par jour';

  @override
  String get remindersUpcoming => 'À venir';

  @override
  String get remindersToday => 'Aujourd\'hui';

  @override
  String get remindersEmpty => 'Aucun rappel';

  @override
  String get remindersActive => 'Actifs';

  @override
  String get notifActionTaken => 'Pris';

  @override
  String get notifActionSnooze => 'Reporter 15 min';

  @override
  String get notifActionSkip => 'Ignorer';

  @override
  String get notifTitle => 'Rappel de médicament';

  @override
  String get notifBody => 'Il est temps de prendre votre médicament';

  @override
  String get historyTitle => 'Historique des traitements';

  @override
  String get historyAll => 'Tous';

  @override
  String get historyActive => 'En cours';

  @override
  String get historyCompleted => 'Terminés';

  @override
  String get historyEmpty => 'Aucun historique';

  @override
  String get historyExport => 'Exporter';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsSecurity => 'Sécurité';

  @override
  String get settingsSecurityPin => 'Code PIN';

  @override
  String get settingsSecurityBio => 'Biométrie';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsDeveloper => 'Développeur';

  @override
  String get settingsSound => 'Effets sonores';

  @override
  String get settingsVibration => 'Vibration';

  @override
  String get settingsSoundDescription => 'Activer le retour sonore';

  @override
  String get settingsVibrationDescription => 'Activer le retour haptique';

  @override
  String get langFrench => 'Français';

  @override
  String get langEnglish => 'English';

  @override
  String get langArabic => 'العربية';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get add => 'Ajouter';

  @override
  String get search => 'Rechercher';

  @override
  String get filter => 'Filtrer';

  @override
  String get close => 'Fermer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get validationRequired => 'Ce champ est requis';

  @override
  String get validationInvalidEmail => 'Email invalide';

  @override
  String get validationInvalidDate => 'Date invalide';

  @override
  String get validationInvalidTime => 'Heure invalide';

  @override
  String get errorGeneric => 'Une erreur s\'est produite';

  @override
  String get errorNetwork => 'Erreur de connexion';

  @override
  String get errorPermission => 'Permission refusée';

  @override
  String get errorCamera => 'Erreur d\'accès à la caméra';

  @override
  String get errorStorage => 'Erreur d\'accès au stockage';

  @override
  String get errorNotification => 'Erreur de notification';

  @override
  String get successSaved => 'Enregistré avec succès';

  @override
  String get successDeleted => 'Supprimé avec succès';

  @override
  String get successUpdated => 'Mis à jour avec succès';

  @override
  String get expiryGood => 'Valide';

  @override
  String get expiryWarning => 'Expire bientôt';

  @override
  String get expiryExpired => 'Expiré';

  @override
  String get permissionCamera => 'Permission caméra nécessaire';

  @override
  String get permissionStorage => 'Permission stockage nécessaire';

  @override
  String get permissionNotifications => 'Permission notifications nécessaire';

  @override
  String get accountSection => 'Compte';

  @override
  String get appearanceSection => 'Apparence';

  @override
  String get notificationsSection => 'Notifications';

  @override
  String get languageSection => 'Langue';

  @override
  String get securitySection => 'Sécurité';

  @override
  String get aboutSection => 'À propos';

  @override
  String get feedbackSection => 'Retour';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get logoutConfirmTitle => 'Déconnexion';

  @override
  String get logoutConfirmMessage =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get notificationRemindersDescription =>
      'Activer les rappels de médicaments';

  @override
  String get pinCodeDescription => 'Protéger l\'app avec un code PIN';

  @override
  String get biometricsDescription => 'Activer l\'authentification biométrique';

  @override
  String get version => 'Version';

  @override
  String get developedWith => 'Développé avec ❤️';

  @override
  String get license => 'Licence';

  @override
  String get mitLicense => 'Licence MIT';

  @override
  String get warningDisclaimer =>
      'Cette application est un assistant et ne remplace pas l\'avis médical professionnel.';

  @override
  String get user => 'Utilisateur';

  @override
  String get soundEnabled => 'Son activé';

  @override
  String get soundDisabled => 'Son désactivé';

  @override
  String get vibrationEnabled => 'Vibration activée';

  @override
  String get vibrationDisabled => 'Vibration désactivée';

  @override
  String get notificationsEnabled => 'Notifications activées';

  @override
  String get notificationsDisabled => 'Notifications désactivées';

  @override
  String get languageChanged => 'Langue modifiée';

  @override
  String get themeChanged => 'Thème modifié';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get selectTheme => 'Sélectionner le thème';

  @override
  String get multilingualInDevelopment => 'Multilingue - En développement';

  @override
  String get pinCodeInDevelopment => 'Code PIN - En développement';

  @override
  String get biometricsInDevelopment => 'Biométrie - En développement';

  @override
  String get profile => 'Mon profil';

  @override
  String get homeGreetingQuestion => 'Comment allez-vous aujourd\'hui ?';

  @override
  String get menuTitle => 'Menu';

  @override
  String get statActiveMeds => 'Médicaments actifs';

  @override
  String get statInactiveMeds => 'Médicaments inactifs';

  @override
  String get statDosesToday => 'Prises aujourd\'hui';

  @override
  String get statExpiryAlerts => 'Alertes expiration';

  @override
  String get expiryAlertsTitle => 'Alertes d\'expiration';

  @override
  String get expiryAlertsNoneTitle => 'Tout est en ordre !';

  @override
  String get expiryAlertsNoneBody =>
      'Aucun médicament n\'expire dans les 3 prochains jours';

  @override
  String get expiryAlertsClickToView => 'Appuyez pour voir la liste';

  @override
  String get expiryPreview => 'Aperçu:';

  @override
  String get expiryExpiredToday => 'Expiré aujourd\'hui';

  @override
  String expiryExpiredDaysAgo(Object days) {
    return 'Expiré il y a $days jours';
  }

  @override
  String get expiryExpiresTomorrow => 'Expire demain';

  @override
  String expiryExpiresInDays(Object days) {
    return 'Expire dans $days jours';
  }

  @override
  String expiryOthers(Object count) {
    return '+$count autre(s)';
  }

  @override
  String expirySummaryExpired(Object count) {
    return '$count médicament(s) expiré(s)';
  }

  @override
  String expirySummaryExpiring(Object count) {
    return '$count expirant bientôt';
  }

  @override
  String get medsTitleInactive => 'Médicaments inactifs';

  @override
  String get medsTitleActive => 'Médicaments actifs';

  @override
  String get medsTitleExpiring => 'Alertes d\'expiration';

  @override
  String get searchHint => 'Rechercher un médicament...';

  @override
  String get filterAll => 'Tous';

  @override
  String get filterActiveOnly => 'Afficher actifs uniquement';

  @override
  String get searchCloseTooltip => 'Fermer la recherche';

  @override
  String get searchOpenTooltip => 'Rechercher';

  @override
  String get loadingMeds => 'Chargement des médicaments...';

  @override
  String get errorTitle => 'Erreur';

  @override
  String get retry => 'Réessayer';

  @override
  String get medsEmptyTitle => 'Aucun médicament';

  @override
  String get medsEmptyBody => 'Commencez par ajouter votre premier médicament';

  @override
  String get medsNoInactiveTitle => 'Aucun médicament inactif';

  @override
  String get medsNoInactiveBody =>
      'Tous vos médicaments sont actifs !\nC\'est une bonne nouvelle.';

  @override
  String get medsNoActiveTitle => 'Aucun médicament actif';

  @override
  String get medsNoActiveBody =>
      'Tous vos médicaments sont désactivés.\nActivez-les pour commencer les rappels.';

  @override
  String get medsNoSearchTitle => 'Aucun résultat';

  @override
  String medsNoSearchBody(Object query) {
    return 'Aucun médicament ne correspond à votre recherche\n\"$query\"';
  }

  @override
  String get clearSearch => 'Effacer la recherche';

  @override
  String get medsNoExpiringTitle => 'Aucune alerte d\'expiration';

  @override
  String get medsNoExpiringBody =>
      'Tous vos médicaments sont en bon état !\nAucun médicament n\'expire dans les 3 prochains jours.';

  @override
  String get back => 'Retour';

  @override
  String get statTotal => 'Total';

  @override
  String get statLabelActive => 'Actifs';

  @override
  String get statLabelInactive => 'Inactifs';

  @override
  String get statLabelAlerts => 'En alerte';

  @override
  String get medFormTitleAdd => 'Ajouter le médicament';

  @override
  String get medFormTitleEdit => 'Modifier le médicament';

  @override
  String get medFormSaving => 'Enregistrement...';

  @override
  String get medFormFillInfo => 'Remplissez les informations du médicament';

  @override
  String get medFormBasicInfo => 'Informations de base';

  @override
  String get medFormNameRequired => 'Le nom est obligatoire';

  @override
  String get medFormDosageHint => 'Ex: 500mg, 10ml';

  @override
  String get medFormDosageRequired => 'Le dosage est obligatoire';

  @override
  String get medFormActive => 'Médicament actif';

  @override
  String get medFormActiveDesc => 'En cours de traitement';

  @override
  String get medFormInactiveDesc => 'Traitement terminé';

  @override
  String get medFormFreqAndTimes => 'Fréquence et horaires';

  @override
  String get medFormFreqLabel => 'Fréquence par jour';

  @override
  String medFormFreqPerDay(Object count) {
    return '$count fois par jour';
  }

  @override
  String get medFormTimesLabel => 'Horaires de prise';

  @override
  String medFormTimeIndex(Object index) {
    return 'Prise $index';
  }

  @override
  String get medFormDatesLabel => 'Dates';

  @override
  String get medFormEndDateOptional => 'Date de fin (optionnelle)';

  @override
  String get medFormExpiryDateOptional => 'Date d\'expiration (optionnelle)';

  @override
  String get medFormSelectDate => 'Sélectionner une date';

  @override
  String get medFormAdditionalInfo => 'Informations supplémentaires';

  @override
  String get medFormBarcodeOptional => 'Code-barres (optionnel)';

  @override
  String get medFormBarcodeHint => 'Scannez ou saisissez le code';

  @override
  String get medFormScan => 'Scanner';

  @override
  String get medFormScanCancelled => 'Scan annulé';

  @override
  String get medFormSearching => 'Recherche du médicament...';

  @override
  String get medFormConsultingDb => 'Consultation de la base de données...';

  @override
  String get medFormFound => 'Médicament trouvé !';

  @override
  String get medFormSaved => 'Médicament ajouté avec succès';

  @override
  String get medFormChangesSaved => 'Modifications enregistrées';

  @override
  String medFormManufacturer(Object name) {
    return 'Fabricant: $name';
  }

  @override
  String get medFormSaveChanges => 'Enregistrer les modifications';

  @override
  String get medFormAddBtn => 'Ajouter le médicament';

  @override
  String get medFormCancelBtn => 'Annuler';

  @override
  String get remindersNotificationsEnabled => 'Notifications activées';

  @override
  String get remindersNotificationsDisabled => 'Notifications désactivées';

  @override
  String get remindersEnabledDesc =>
      'Vous recevrez des rappels pour vos médicaments';

  @override
  String get remindersDisabledDesc =>
      'Activez les notifications pour recevoir des rappels';

  @override
  String get activate => 'Activer';

  @override
  String get remindersTestTitle => 'Test des notifications';

  @override
  String get remindersTestBody =>
      'Envoyez une notification de test pour vérifier que tout fonctionne';

  @override
  String get remindersTestBtn => 'Envoyer une notification de test';

  @override
  String remindersMyMeds(Object count) {
    return 'Mes médicaments ($count)';
  }

  @override
  String get remindersHint =>
      'Appuyez sur une heure pour activer/désactiver le rappel';

  @override
  String get remindersNoActiveMeds => 'Aucun médicament actif';

  @override
  String get remindersAddMedsHint =>
      'Ajoutez des médicaments pour configurer vos rappels';

  @override
  String get refresh => 'Actualiser';

  @override
  String get remindersScheduled => 'Notifications vérifiées et planifiées';

  @override
  String get markAsTaken => 'Marquer comme pris';

  @override
  String get markAsSkipped => 'Marquer comme ignoré';

  @override
  String get remindersNoTimesConfigured =>
      'Aucune heure de prise configurée pour ce médicament';

  @override
  String get remindersAllTaken =>
      'Toutes les prises ont déjà été marquées comme prises';

  @override
  String get remindersAllSkipped =>
      'Toutes les prises ont déjà été marquées comme ignorées';

  @override
  String get remindersSelectTime => 'Sélectionnez l\'heure de prise:';

  @override
  String get remindersAllCompleted =>
      'Toutes les prises d\'aujourd\'hui sont complétées';

  @override
  String notificationTimeForMed(Object dosage) {
    return 'Il est temps de prendre votre médicament ($dosage)';
  }

  @override
  String get filterHistory => 'Filtrer l\'historique';

  @override
  String get filterTaken => 'Pris';

  @override
  String get filterMissed => 'Manqués';

  @override
  String get filterSkipped => 'Ignorés';

  @override
  String get historyToday => 'Aujourd\'hui';

  @override
  String get historyWeek => 'Cette semaine';

  @override
  String get historyAllTime => 'Tout';

  @override
  String get statsTitle => 'Statistiques';

  @override
  String get historyEmptyTitle => 'Aucun historique disponible';

  @override
  String get historyEmptyBody => 'Vos prises de médicaments apparaîtront ici';

  @override
  String get historyYesterday => 'Hier';

  @override
  String dateRangeSelected(Object end, Object start) {
    return 'Période sélectionnée: $start - $end';
  }

  @override
  String get statsDetailed => 'Statistiques détaillées';

  @override
  String get statsOverview => 'Vue d\'ensemble';

  @override
  String get statsTotal => 'Total de prises';

  @override
  String get statsCompleted => 'Prises complétées';

  @override
  String get statsPending => 'En attente';

  @override
  String get statsDetails => 'Détails des prises';

  @override
  String get statsSuccess => 'Prises réussies';

  @override
  String get statsMissed => 'Prises manquées';

  @override
  String get statsSkipped => 'Prises ignorées';

  @override
  String get statsLate => 'Prises en retard (>5min)';

  @override
  String get complianceRate => 'Taux d\'observance';

  @override
  String get complianceExcellent => 'Excellent';

  @override
  String get complianceGood => 'Bon';

  @override
  String get complianceAverage => 'Moyen';

  @override
  String get compliancePoor => 'À améliorer';

  @override
  String get status => 'Statut';

  @override
  String get scheduledTime => 'Heure prévue';

  @override
  String get takenTime => 'Heure de prise';

  @override
  String get delay => 'Retard';

  @override
  String get note => 'Note';

  @override
  String minutesLate(Object minutes) {
    return '$minutes minutes de retard';
  }

  @override
  String get minutesLabel => 'minutes';

  @override
  String get scanHeader => 'Scanner votre ordonnance';

  @override
  String get scanSubtitle =>
      'Utilisez l\'IA pour extraire automatiquement les informations';

  @override
  String get scanMethodTitle => 'Choisissez une méthode';

  @override
  String get scanTakePhoto => 'Prendre une photo';

  @override
  String get scanCameraSubtitle => 'Scanner avec la caméra';

  @override
  String get scanPickImage => 'Choisir une image';

  @override
  String get scanGallerySubtitle => 'Depuis votre galerie';

  @override
  String get scanTipsTitle => 'Conseils pour un meilleur scan';

  @override
  String get scanTipLight => 'Bonne lumière';

  @override
  String get scanTipSharp => 'Image nette';

  @override
  String get scanTipFlat => 'Document à plat';

  @override
  String get scanTipHandwriting => 'Écriture manuscrite supportée';

  @override
  String get scanCaptured => 'Capturée';

  @override
  String get scanCapturedTitle => 'Ordonnance capturée';

  @override
  String get scanCapturedSubtitle => 'Prête pour l\'analyse';

  @override
  String scanDetectedMeds(Object count) {
    return '$count médicament(s) détecté(s)';
  }

  @override
  String get scanNoText => 'Aucun texte détecté';

  @override
  String get scanConfirmTitle => 'Confirmer l\'ajout';

  @override
  String scanConfirmBody(Object count) {
    return 'Vous allez ajouter $count médicament(s):';
  }

  @override
  String get scanScheduleWarning =>
      'Les horaires de prise seront générés automatiquement. Vous pourrez les modifier ensuite.';

  @override
  String get scanNoMedsToSave => 'Aucun médicament détecté à enregistrer';

  @override
  String get scanNew => 'Nouveau scan';

  @override
  String get frequencyDay => 'jour';

  @override
  String get seeAll => 'Voir tout';

  @override
  String seeMoreMeds(Object count) {
    return 'Voir $count de plus';
  }

  @override
  String homeMedsSummary(Object active, Object total) {
    return '$total médicaments • $active actifs';
  }

  @override
  String get homeUpcomingReminders => 'Prochains rappels';

  @override
  String commonInMin(Object min) {
    return 'Dans $min min';
  }

  @override
  String commonInHoursMin(Object hours, Object min) {
    return 'Dans ${hours}h ${min}min';
  }

  @override
  String dosesPerDay(Object count) {
    return '$count prises/jour';
  }

  @override
  String get commonActive => 'Actif';

  @override
  String get commonInactive => 'Inactif';

  @override
  String get profileTitle => 'Mon Profil';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get editProfileComingSoon => 'Modifier le profil - À venir';

  @override
  String memberSince(Object date) {
    return 'Membre depuis $date';
  }

  @override
  String get statTotalMeds => 'Total de médicaments';

  @override
  String get emailLabel => 'Email';

  @override
  String get displayNameLabel => 'Nom d\'affichage';

  @override
  String get userIdLabel => 'ID Utilisateur';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get changePasswordComingSoon => 'Changer le mot de passe - À venir';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountConfirmTitle => 'Supprimer le compte';

  @override
  String get deleteAccountConfirmBody =>
      'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible et toutes vos données seront perdues.';

  @override
  String get deleteAccountComingSoon => 'Suppression du compte - À venir';

  @override
  String get unknown => 'Inconnu';

  @override
  String untilDate(Object date) {
    return 'Jusqu\'au $date';
  }

  @override
  String get deactivate => 'Désactiver';

  @override
  String get confirmDeactivateTitle => 'Désactiver le médicament';

  @override
  String get confirmActivateTitle => 'Activer le médicament';

  @override
  String confirmDeactivateBody(Object name) {
    return 'Voulez-vous désactiver \"$name\" ?\n\nLes rappels seront suspendus et le médicament n\'apparaîtra plus dans vos médicaments actifs.';
  }

  @override
  String confirmActivateBody(Object name) {
    return 'Voulez-vous activer \"$name\" ?\n\nLes rappels seront réactivés et le médicament apparaîtra dans vos médicaments actifs.';
  }

  @override
  String medicationDeactivated(Object name) {
    return '✅ $name a été désactivé';
  }

  @override
  String medicationActivated(Object name) {
    return '✅ $name a été activé';
  }

  @override
  String get confirmDeleteTitle => 'Confirmation';

  @override
  String confirmDeleteBody(Object name) {
    return 'Voulez-vous vraiment supprimer $name ?';
  }

  @override
  String detailsComingSoon(Object name) {
    return 'Détails de $name - En développement';
  }

  @override
  String get homeTimelineTitle => 'Programme du jour';

  @override
  String get homeTimelineEmpty => 'Aucun programme aujourd\'hui';
}
