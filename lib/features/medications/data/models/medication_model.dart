import 'package:flutter/material.dart';
import 'package:mediscanhelper/features/medications/domain/entities/medication.dart';

/// Model pour Medication avec conversion JSON et Database
class MedicationModel extends Medication {
  const MedicationModel({
    required super.id,
    required super.name,
    required super.dosage,
    required super.frequency,
    required super.times,
    required super.startDate,
    super.endDate,
    super.expiryDate,
    super.barcode,
    super.imagePath,
    super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Créé depuis un Medication entity
  factory MedicationModel.fromEntity(Medication medication) {
    return MedicationModel(
      id: medication.id,
      name: medication.name,
      dosage: medication.dosage,
      frequency: medication.frequency,
      times: medication.times,
      startDate: medication.startDate,
      endDate: medication.endDate,
      expiryDate: medication.expiryDate,
      barcode: medication.barcode,
      imagePath: medication.imagePath,
      isActive: medication.isActive,
      createdAt: medication.createdAt,
      updatedAt: medication.updatedAt,
    );
  }

  /// Créé depuis JSON
  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as int,
      times: _parseTimes(json['times'] as String),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'] as String)
          : null,
      barcode: json['barcode'] as String?,
      imagePath: json['image_path'] as String?,
      isActive: (json['is_active'] as int) == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convertit en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'times': _timesToString(times),
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'expiry_date': expiryDate?.toIso8601String(),
      'barcode': barcode,
      'image_path': imagePath,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Parse les heures depuis une chaîne "HH:mm,HH:mm"
  static List<TimeOfDay> _parseTimes(String timesString) {
    if (timesString.isEmpty) return [];
    return timesString.split(',').map((timeStr) {
      final parts = timeStr.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }).toList();
  }

  /// Convertit les heures en chaîne "HH:mm,HH:mm"
  static String _timesToString(List<TimeOfDay> times) {
    return times
        .map((time) =>
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}')
        .join(',');
  }

  /// Crée une copie avec les champs modifiés
  @override
  MedicationModel copyWith({
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
    return MedicationModel(
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
}

