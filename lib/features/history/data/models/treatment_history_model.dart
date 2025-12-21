import 'package:mediscanhelper/features/history/domain/entities/treatment_history.dart';

/// Model pour TreatmentHistory avec sérialisation JSON
class TreatmentHistoryModel extends TreatmentHistory {
  const TreatmentHistoryModel({
    required super.id,
    required super.medicationId,
    required super.medicationName,
    required super.dosage,
    required super.scheduledTime,
    super.takenTime,
    required super.status,
    super.note,
    required super.createdAt,
  });

  /// Crée un modèle depuis une entité
  factory TreatmentHistoryModel.fromEntity(TreatmentHistory entity) {
    return TreatmentHistoryModel(
      id: entity.id,
      medicationId: entity.medicationId,
      medicationName: entity.medicationName,
      dosage: entity.dosage,
      scheduledTime: entity.scheduledTime,
      takenTime: entity.takenTime,
      status: entity.status,
      note: entity.note,
      createdAt: entity.createdAt,
    );
  }

  /// Crée un modèle depuis un JSON
  factory TreatmentHistoryModel.fromJson(Map<String, dynamic> json) {
    return TreatmentHistoryModel(
      id: json['id'] as String,
      medicationId: json['medicationId'] as String,
      medicationName: json['medicationName'] as String,
      dosage: json['dosage'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      takenTime: json['takenTime'] != null 
          ? DateTime.parse(json['takenTime'] as String)
          : null,
      status: TreatmentStatus.values.firstWhere(
        (e) => e.toString() == 'TreatmentStatus.${json['status']}',
      ),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convertit en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicationId': medicationId,
      'medicationName': medicationName,
      'dosage': dosage,
      'scheduledTime': scheduledTime.toIso8601String(),
      'takenTime': takenTime?.toIso8601String(),
      'status': status.toString().split('.').last,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Convertit en entité
  TreatmentHistory toEntity() {
    return TreatmentHistory(
      id: id,
      medicationId: medicationId,
      medicationName: medicationName,
      dosage: dosage,
      scheduledTime: scheduledTime,
      takenTime: takenTime,
      status: status,
      note: note,
      createdAt: createdAt,
    );
  }
}
