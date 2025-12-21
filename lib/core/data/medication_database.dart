import 'package:mediscanhelper/core/models/medication_database_model.dart';

/// Static database of medications with their barcodes
class MedicationDatabase {
  // Singleton pattern
  static final MedicationDatabase _instance = MedicationDatabase._internal();
  factory MedicationDatabase() => _instance;
  MedicationDatabase._internal();

  /// Static list of medications with their barcodes
  /// These are common medications with realistic EAN-13 barcodes
  static final List<MedicationDatabaseEntry> _medications = [
    // Paracétamol / Acetaminophen
    const MedicationDatabaseEntry(
      barcode: '6118000040354',
      name: 'Doliprane',
      dosage: '500mg',
      manufacturer: 'Sanofi',
      category: 'Analgésique',
      description: 'Paracétamol pour douleurs et fièvre',
    ),
    const MedicationDatabaseEntry(
      barcode: '3400936014138',
      name: 'Efferalgan',
      dosage: '500mg',
      manufacturer: 'Bristol-Myers Squibb',
      category: 'Analgésique',
      description: 'Paracétamol effervescent',
    ),
    const MedicationDatabaseEntry(
      barcode: '3400935892119',
      name: 'Dafalgan',
      dosage: '1000mg',
      manufacturer: 'Bristol-Myers Squibb',
      category: 'Analgésique',
      description: 'Paracétamol pour douleurs modérées',
    ),

    // Anti-inflammatoires
    const MedicationDatabaseEntry(
      barcode: '3400933989095',
      name: 'Advil',
      dosage: '400mg',
      manufacturer: 'Pfizer',
      category: 'Anti-inflammatoire',
      description: 'Ibuprofène pour douleurs et inflammation',
    ),
    const MedicationDatabaseEntry(
      barcode: '3400934599095',
      name: 'Nurofen',
      dosage: '200mg',
      manufacturer: 'Reckitt Benckiser',
      category: 'Anti-inflammatoire',
      description: 'Ibuprofène pour douleurs légères à modérées',
    ),
    const MedicationDatabaseEntry(
      barcode: '3400935555069',
      name: 'Voltarène',
      dosage: '50mg',
      manufacturer: 'Novartis',
      category: 'Anti-inflammatoire',
      description: 'Diclofénac pour douleurs articulaires',
    ),

    // Antibiotiques
    const MedicationDatabaseEntry(
      barcode: '3400936014145',
      name: 'Amoxicilline',
      dosage: '500mg',
      manufacturer: 'Biogaran',
      category: 'Antibiotique',
      description: 'Antibiotique à large spectre',
    ),
    const MedicationDatabaseEntry(
      barcode: '3400937445061',
      name: 'Augmentin',
      dosage: '1g',
      manufacturer: 'GlaxoSmithKline',
      category: 'Antibiotique',
      description: 'Amoxicilline + acide clavulanique',
    ),
    const MedicationDatabaseEntry(
      barcode: '3400938888096',
      name: 'Azithromycine',
      dosage: '250mg',
      manufacturer: 'Pfizer',
      category: 'Antibiotique',
      description: 'Antibiotique macrolide',
    ),

    // Antihistaminiques
    const MedicationDatabaseEntry(
      barcode: '3400934111136',
      name: 'Clarityne',
      dosage: '10mg',
      manufacturer: 'Bayer',
      category: 'Antihistaminique',
      description: 'Loratadine pour allergies',
    ),
    const MedicationDatabaseEntry(
      barcode: '3400935666082',
      name: 'Zyrtec',
      dosage: '10mg',
      manufacturer: 'UCB Pharma',
      category: 'Antihistaminique',
      description: 'Cétirizine pour rhinite allergique',
    ),

    // Antiacides
    const MedicationDatabaseEntry(
      barcode: '3400933777098',
      name: 'Maalox',
      dosage: '400mg',
      manufacturer: 'Sanofi',
      category: 'Antiacide',
      description: 'Pour brûlures d\'estomac',
    ),
    const MedicationDatabaseEntry(
      barcode: '3400934222143',
      name: 'Gaviscon',
      dosage: '500mg',
      manufacturer: 'Reckitt Benckiser',
      category: 'Antiacide',
      description: 'Suspension buvable pour reflux',
    ),

    // Vitamines et suppléments
    const MedicationDatabaseEntry(
      barcode: '3400935555076',
      name: 'Vitamine C',
      dosage: '1000mg',
      manufacturer: 'Upsa',
      category: 'Vitamine',
      description: 'Acide ascorbique effervescent',
    ),
    const MedicationDatabaseEntry(
      barcode: '3400936666089',
      name: 'Vitamine D',
      dosage: '1000 UI',
      manufacturer: 'Crinex',
      category: 'Vitamine',
      description: 'Cholécalciférol',
    ),

    // Autres médicaments courants
    const MedicationDatabaseEntry(
      barcode: '3400937777092',
      name: 'Spasfon',
      dosage: '80mg',
      manufacturer: 'Teva',
      category: 'Antispasmodique',
      description: 'Phloroglucinol pour douleurs abdominales',
    ),
    const MedicationDatabaseEntry(
      barcode: '3400938888103',
      name: 'Smecta',
      dosage: '3g',
      manufacturer: 'Ipsen',
      category: 'Antidiarrhéique',
      description: 'Diosmectite pour diarrhée',
    ),
    const MedicationDatabaseEntry(
      barcode: '3400939999110',
      name: 'Humex',
      dosage: '600mg',
      manufacturer: 'Urgo',
      category: 'Décongestionnant',
      description: 'Pour symptômes du rhume',
    ),
  ];

  /// Look up a medication by barcode
  MedicationDatabaseEntry? findByBarcode(String barcode) {
    try {
      return _medications.firstWhere(
        (med) => med.barcode == barcode,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get all medications in the database
  List<MedicationDatabaseEntry> getAllMedications() {
    return List.unmodifiable(_medications);
  }

  /// Search medications by name (case-insensitive)
  List<MedicationDatabaseEntry> searchByName(String query) {
    final lowerQuery = query.toLowerCase();
    return _medications
        .where((med) => med.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Get medications by category
  List<MedicationDatabaseEntry> getByCategory(String category) {
    return _medications
        .where((med) => med.category?.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Get total count of medications in database
  int get count => _medications.length;
}
