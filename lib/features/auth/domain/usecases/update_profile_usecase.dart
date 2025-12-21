import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mediscanhelper/core/error/failures.dart';
import 'package:mediscanhelper/features/auth/domain/repositories/auth_repository.dart';

/// Use case pour la mise à jour du profil
class UpdateProfile {
  final AuthRepository repository;

  UpdateProfile(this.repository);

  Future<Either<Failure, void>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(displayName: params.displayName);
  }
}

class UpdateProfileParams extends Equatable {
  final String displayName;

  const UpdateProfileParams({required this.displayName});

  @override
  List<Object> get props => [displayName];
}
