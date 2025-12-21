import 'package:equatable/equatable.dart';

/// Entité TreatmentHistory - Représente l'historique d'un traitement
class TreatmentHistory extends Equatable {
  final String id;
  final String medicationId;
  final String medicationName;
  final String dosage;
  final DateTime scheduledTime;
  final DateTime? takenTime;
  final TreatmentStatus status;
  final String? note;
  final DateTime createdAt;

  const TreatmentHistory({
    required this.id,
    required this.medicationId,
    required this.medicationName,
    required this.dosage,
    required this.scheduledTime,
    this.takenTime,
    required this.status,
    this.note,
    required this.createdAt,
  });

  /// Vérifie si le traitement a été pris
  bool get wasTaken => status == TreatmentStatus.taken;

  /// Vérifie si le traitement a été manqué
  bool get wasMissed => status == TreatmentStatus.missed;

  /// Retourne le délai de prise (en minutes)
  int? get delayInMinutes {
    if (takenTime == null) return null;
    return takenTime!.difference(scheduledTime).inMinutes;
  }

  /// Crée une copie avec les champs modifiés
  TreatmentHistory copyWith({
    String? id,
    String? medicationId,
    String? medicationName,
    String? dosage,
    DateTime? scheduledTime,
    DateTime? takenTime,
    TreatmentStatus? status,
    String? note,
    DateTime? createdAt,
  }) {
    return TreatmentHistory(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      medicationName: medicationName ?? this.medicationName,
      dosage: dosage ?? this.dosage,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      takenTime: takenTime ?? this.takenTime,
      status: status ?? this.status,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        medicationId,
        medicationName,
        dosage,
        scheduledTime,
        takenTime,
        status,
        note,
        createdAt,
      ];
}

/// Enum pour le statut d'un traitement
enum TreatmentStatus {
  taken, // Pris
  missed, // Manqué
  skipped, // Ignoré
  pending, // En attente
}

/// Extensions pour TreatmentStatus
extension TreatmentStatusExtension on TreatmentStatus {
  String get label {
    switch (this) {
      case TreatmentStatus.taken:
        return 'Pris';
      case TreatmentStatus.missed:
        return 'Manqué';
      case TreatmentStatus.skipped:
        return 'Ignoré';
      case TreatmentStatus.pending:
        return 'En attente';
    }
  }

  String get icon {
    switch (this) {
      case TreatmentStatus.taken:
        return '✓';
      case TreatmentStatus.missed:
        return '✗';
      case TreatmentStatus.skipped:
        return '—';
      case TreatmentStatus.pending:
        return '⏰';
    }
  }
}

