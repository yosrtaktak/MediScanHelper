import 'package:dartz/dartz.dart';
import 'package:mediscanhelper/core/error/failures.dart';
import 'package:mediscanhelper/features/medications/domain/entities/medication.dart';
import 'package:mediscanhelper/features/medications/domain/repositories/medication_repository.dart';

/// UseCase pour récupérer tous les médicaments
class GetMedications {
  final MedicationRepository repository;

  GetMedications(this.repository);

  Future<Either<Failure, List<Medication>>> call() async {
    return await repository.getMedications();
  }
}

/// UseCase pour récupérer les médicaments actifs
class GetActiveMedications {
  final MedicationRepository repository;

  GetActiveMedications(this.repository);

  Future<Either<Failure, List<Medication>>> call() async {
    return await repository.getActiveMedications();
  }
}

/// UseCase pour récupérer un médicament par son ID
class GetMedicationById {
  final MedicationRepository repository;

  GetMedicationById(this.repository);

  Future<Either<Failure, Medication>> call(String id) async {
    return await repository.getMedicationById(id);
  }
}

/// UseCase pour ajouter un médicament
class AddMedication {
  final MedicationRepository repository;

  AddMedication(this.repository);

  Future<Either<Failure, void>> call(Medication medication) async {
    return await repository.addMedication(medication);
  }
}

/// UseCase pour mettre à jour un médicament
class UpdateMedication {
  final MedicationRepository repository;

  UpdateMedication(this.repository);

  Future<Either<Failure, void>> call(Medication medication) async {
    return await repository.updateMedication(medication);
  }
}

/// UseCase pour supprimer un médicament
class DeleteMedication {
  final MedicationRepository repository;

  DeleteMedication(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteMedication(id);
  }
}

/// UseCase pour récupérer les médicaments à prendre aujourd'hui
class GetTodayMedications {
  final MedicationRepository repository;

  GetTodayMedications(this.repository);

  Future<Either<Failure, List<Medication>>> call() async {
    return await repository.getTodayMedications();
  }
}

/// UseCase pour récupérer les médicaments expirant bientôt
class GetExpiringMedications {
  final MedicationRepository repository;

  GetExpiringMedications(this.repository);

  Future<Either<Failure, List<Medication>>> call() async {
    return await repository.getExpiringMedications();
  }
}

