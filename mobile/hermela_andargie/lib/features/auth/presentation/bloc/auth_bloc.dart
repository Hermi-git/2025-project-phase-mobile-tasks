import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_authstatus_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
    required this.checkAuthStatusUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoggedIn>(_onAuthLoggedIn);
    on<AuthSignedUp>(_onAuthSignedUp);
    on<AuthLoggedOut>(_onAuthLoggedOut);
    on<AuthUserRequested>(_onAuthUserRequested);
  }

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final authStatusEither = await checkAuthStatusUseCase(NoParams());

    authStatusEither.fold((failure) => emit(AuthUnauthenticated()), (
      isLoggedIn,
    ) async {
      if (isLoggedIn) {
        final userEither = await getCurrentUserUseCase(NoParams());
        userEither.fold(
          (_) => emit(AuthUnauthenticated()),
          (user) => emit(AuthAuthenticated(user)),
        );
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> _onAuthLoggedIn(
    AuthLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final loginEither = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    loginEither.fold(
      (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
      (tokens) async {
        final userEither = await getCurrentUserUseCase(NoParams());
        userEither.fold(
          (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
          (user) => emit(AuthAuthenticated(user)),
        );
      },
    );
  }

  Future<void> _onAuthSignedUp(
    AuthSignedUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final signUpEither = await signUpUseCase(
      SignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    signUpEither.fold(
      (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
      (user) => emit(AuthSignedUpSuccess(user)),
    );
  }

  Future<void> _onAuthLoggedOut(
    AuthLoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final logoutEither = await logoutUseCase(NoParams());

    logoutEither.fold(
      (_) => emit(AuthUnauthenticated()),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthUserRequested(
    AuthUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final userEither = await getCurrentUserUseCase(NoParams());

    userEither.fold(
      (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (CacheFailure):
        return 'Cache error occurred';
      case const (ServerFailure):
        return 'Server error occurred';
      case const (InvalidCredentialsFailure):
        return 'Invalid email or password';
      default:
        return 'Unexpected error occurred';
    }
  }
}
