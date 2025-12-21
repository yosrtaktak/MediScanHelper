import 'package:equatable/equatable.dart';

/// Entité Reminder
class Reminder extends Equatable {
  final String id;
  final String medicationId;
  final String medicationName;
  final String time; // Format HH:mm
  final bool isActive;
  final int notificationId;
  final String? customMessage;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final DateTime createdAt;

  const Reminder({
    required this.id,
    required this.medicationId,
    required this.medicationName,
    required this.time,
    required this.isActive,
    required this.notificationId,
    this.customMessage,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        medicationId,
        medicationName,
        time,
        isActive,
        notificationId,
        customMessage,
        soundEnabled,
        vibrationEnabled,
        createdAt,
      ];

  Reminder copyWith({
    String? id,
    String? medicationId,
    String? medicationName,
    String? time,
    bool? isActive,
    int? notificationId,
    String? customMessage,
    bool? soundEnabled,
    bool? vibrationEnabled,
    DateTime? createdAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      medicationName: medicationName ?? this.medicationName,
      time: time ?? this.time,
      isActive: isActive ?? this.isActive,
      notificationId: notificationId ?? this.notificationId,
      customMessage: customMessage ?? this.customMessage,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

