import 'package:equatable/equatable.dart';

/// Model for medication entries in the static database
class MedicationDatabaseEntry extends Equatable {
  final String barcode;
  final String name;
  final String dosage;
  final String? manufacturer;
  final String? category;
  final String? description;

  const MedicationDatabaseEntry({
    required this.barcode,
    required this.name,
    required this.dosage,
    this.manufacturer,
    this.category,
    this.description,
  });

  @override
  List<Object?> get props => [
        barcode,
        name,
        dosage,
        manufacturer,
        category,
        description,
      ];

  @override
  String toString() {
    return 'MedicationDatabaseEntry(barcode: $barcode, name: $name, dosage: $dosage)';
  }
}
