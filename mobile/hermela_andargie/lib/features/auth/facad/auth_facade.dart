import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../domain/entities/auth_tokens.dart';
import '../domain/entities/user.dart';

abstract class AuthFacade {
  Future<bool> isLoggedIn();

  Future<Either<Failure, AuthTokens>> login(String email, String password);

  Future<Either<Failure, User>> signUp(
    String name,
    String email,
    String password,
  );

  Future<void> logout();

  Future<Option<User>> getCurrentUser();
}
