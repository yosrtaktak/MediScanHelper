/// Chemins des assets de l'application
class AppAssets {
  AppAssets._();

  // Animations
  static const String animationsPath = 'assets/animations/';
  static const String splashAnimation = '${animationsPath}heart_medical.json';
  static const String scanAnimation = '${animationsPath}scan.json';
  static const String successAnimation = '${animationsPath}success.json';
  static const String loadingAnimation = '${animationsPath}loading.json';

  // Images
  static const String imagesPath = 'assets/images/';
  static const String logoImage = '${imagesPath}logo.png';
  static const String placeholderImage = '${imagesPath}placeholder.png';
  static const String emptyStateImage = '${imagesPath}empty_state.png';

  // Note: Les fichiers Lottie devront être téléchargés depuis LottieFiles.com
  // Exemples:
  // - Heart Medical: https://lottiefiles.com/animations/heart-medical
  // - Scanner: https://lottiefiles.com/animations/scanner
  // - Success: https://lottiefiles.com/animations/success
}

