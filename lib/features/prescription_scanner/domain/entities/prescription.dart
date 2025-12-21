import 'package:equatable/equatable.dart';
import 'package:mediscanhelper/features/medications/domain/entities/medication.dart';

/// Entité Prescription - Représente une ordonnance scannée
class Prescription extends Equatable {
  final String id;
  final DateTime scanDate;
  final String imagePath;
  final String extractedText;
  final List<Medication> medications;
  final Map<String, dynamic>? extractedEntities; // Entités extraites par ML Kit

  const Prescription({
    required this.id,
    required this.scanDate,
    required this.imagePath,
    required this.extractedText,
    required this.medications,
    this.extractedEntities,
  });

  /// Crée une copie avec les champs modifiés
  Prescription copyWith({
    String? id,
    DateTime? scanDate,
    String? imagePath,
    String? extractedText,
    List<Medication>? medications,
    Map<String, dynamic>? extractedEntities,
  }) {
    return Prescription(
      id: id ?? this.id,
      scanDate: scanDate ?? this.scanDate,
      imagePath: imagePath ?? this.imagePath,
      extractedText: extractedText ?? this.extractedText,
      medications: medications ?? this.medications,
      extractedEntities: extractedEntities ?? this.extractedEntities,
    );
  }

  @override
  List<Object?> get props => [
        id,
        scanDate,
        imagePath,
        extractedText,
        medications,
        extractedEntities,
      ];
}

