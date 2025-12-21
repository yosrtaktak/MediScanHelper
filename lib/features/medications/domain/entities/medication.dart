import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Entité Medication - Représente un médicament
class Medication extends Equatable {
  final String id;
  final String name;
  final String dosage;
  final int frequency; // fois par jour
  final List<TimeOfDay> times;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? expiryDate;
  final String? barcode;
  final String? imagePath;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.times,
    required this.startDate,
    this.endDate,
    this.expiryDate,
    this.barcode,
    this.imagePath,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Vérifie si le médicament est expiré
  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  /// Vérifie si le médicament expire bientôt (< 3 mois)
  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final threeMonthsFromNow = DateTime.now().add(const Duration(days: 90));
    return expiryDate!.isBefore(threeMonthsFromNow) && !isExpired;
  }

  /// Retourne le statut d'expiration
  ExpiryStatus get expiryStatus {
    if (isExpired) return ExpiryStatus.expired;
    if (isExpiringSoon) return ExpiryStatus.expiringSoon;
    return ExpiryStatus.good;
  }

  /// Vérifie si le traitement est terminé
  bool get isTreatmentCompleted {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!);
  }

  /// Crée une copie avec les champs modifiés
  Medication copyWith({
    String? id,
    String? name,
    String? dosage,
    int? frequency,
    List<TimeOfDay>? times,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? expiryDate,
    String? barcode,
    String? imagePath,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      times: times ?? this.times,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      expiryDate: expiryDate ?? this.expiryDate,
      barcode: barcode ?? this.barcode,
      imagePath: imagePath ?? this.imagePath,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        dosage,
        frequency,
        times,
        startDate,
        endDate,
        expiryDate,
        barcode,
        imagePath,
        isActive,
        createdAt,
        updatedAt,
      ];
}

/// Enum pour le statut d'expiration
enum ExpiryStatus {
  good, // > 3 mois
  expiringSoon, // < 3 mois
  expired, // expiré
}

