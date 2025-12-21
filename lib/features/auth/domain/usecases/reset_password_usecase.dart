import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mediscanhelper/core/error/failures.dart';
import 'package:mediscanhelper/features/auth/domain/repositories/auth_repository.dart';

/// Use case pour la réinitialisation du mot de passe
class ResetPassword {
  final AuthRepository repository;

  ResetPassword(this.repository);

  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    return await repository.resetPassword(email: params.email);
  }
}

class ResetPasswordParams extends Equatable {
  final String email;

  const ResetPasswordParams({required this.email});

  @override
  List<Object> get props => [email];
}

