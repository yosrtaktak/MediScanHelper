import 'package:equatable/equatable.dart';

/// Entité ReminderHistory - Représente l'historique d'un rappel
class ReminderHistory extends Equatable {
  final String id;
  final String medicationId;
  final DateTime scheduledTime;
  final DateTime? takenTime;
  final ReminderStatus status;
  final String? note;

  const ReminderHistory({
    required this.id,
    required this.medicationId,
    required this.scheduledTime,
    this.takenTime,
    required this.status,
    this.note,
  });

  /// Crée une copie avec les champs modifiés
  ReminderHistory copyWith({
    String? id,
    String? medicationId,
    DateTime? scheduledTime,
    DateTime? takenTime,
    ReminderStatus? status,
    String? note,
  }) {
    return ReminderHistory(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      takenTime: takenTime ?? this.takenTime,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [
        id,
        medicationId,
        scheduledTime,
        takenTime,
        status,
        note,
      ];
}

/// Enum pour le statut d'un rappel
enum ReminderStatus {
  taken, // Pris
  missed, // Manqué
  snoozed, // Reporté
  skipped, // Ignoré
}

