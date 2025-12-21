import 'package:mediscanhelper/core/constants/app_strings.dart';

/// Classe de validation des champs de formulaire
class Validators {
  Validators._();

  /// Valide un champ requis
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName ${AppStrings.validationRequired.toLowerCase()}'
          : AppStrings.validationRequired;
    }
    return null;
  }

  /// Valide un email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validationRequired;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return AppStrings.validationInvalidEmail;
    }

    return null;
  }

  /// Valide un nombre minimum de caractères
  static String? minLength(String? value, int minLength) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validationRequired;
    }

    if (value.length < minLength) {
      return 'Minimum $minLength caractères requis';
    }

    return null;
  }

  /// Valide un nombre maximum de caractères
  static String? maxLength(String? value, int maxLength) {
    if (value == null) return null;

    if (value.length > maxLength) {
      return 'Maximum $maxLength caractères autorisés';
    }

    return null;
  }

  /// Valide un nombre
  static String? number(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validationRequired;
    }

    if (double.tryParse(value) == null) {
      return 'Veuillez entrer un nombre valide';
    }

    return null;
  }

  /// Valide un numéro de téléphone
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validationRequired;
    }

    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s-]'), ''))) {
      return 'Numéro de téléphone invalide';
    }

    return null;
  }

  /// Combine plusieurs validateurs
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final result = validator();
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}

