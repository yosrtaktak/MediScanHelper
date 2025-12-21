import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mediscanhelper/core/error/failures.dart';
import 'package:mediscanhelper/features/auth/domain/entities/user_entity.dart';
import 'package:mediscanhelper/features/auth/domain/repositories/auth_repository.dart';

/// Use case pour la connexion
class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<Either<Failure, UserEntity>> call(SignInParams params) async {
    return await repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

