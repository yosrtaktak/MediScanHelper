import 'package:dartz/dartz.dart';
import 'package:mediscanhelper/core/error/failures.dart';
import 'package:mediscanhelper/features/auth/domain/entities/user_entity.dart';
import 'package:mediscanhelper/features/auth/domain/repositories/auth_repository.dart';

/// Use case pour récupérer l'utilisateur actuel
class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  Future<Either<Failure, UserEntity?>> call() async {
    return await repository.getCurrentUser();
  }
}

