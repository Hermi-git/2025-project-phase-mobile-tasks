import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../domain/entities/auth_tokens.dart';
import '../domain/entities/user.dart';
import '../domain/usecases/check_authstatus_usecase.dart';
import '../domain/usecases/get_current_user_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/sign_up_usecase.dart';
import 'auth_facade.dart';

class AuthFacadeImpl implements AuthFacade {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckAuthStatusUseCase hasTokenUseCase;
  final GetCurrentUserUseCase getUserUseCase;

  AuthFacadeImpl({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
    required this.hasTokenUseCase,
    required this.getUserUseCase,
  });

  @override
  Future<bool> isLoggedIn() async {
    final result = await hasTokenUseCase(NoParams());
    return result.fold((failure) => false, (hasToken) => hasToken);
  }

  // Now returns User entity wrapped in Either
  @override
  Future<Either<Failure, AuthTokens>> login(
    String email,
    String password,
  ) async {
    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );
    return result; // pass through the AuthTokens or Failure
  }

  // Now returns User entity wrapped in Either
  @override
  Future<Either<Failure, User>> signUp(
    String name,
    String email,
    String password,
  ) async {
    final result = await signUpUseCase(
      SignUpParams(name: name, email: email, password: password),
    );
    return result; // pass through the User or Failure
  }

  @override
  Future<void> logout() async {
    final result = await logoutUseCase(NoParams());
    result.fold((_) {}, (_) {});
  }

  @override
  Future<Option<User>> getCurrentUser() async {
    final result = await getUserUseCase(NoParams());
    return result.fold((_) => none(), (user) => some(user));
  }
}
