import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../facad/auth_facade.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthFacade authFacade;

  AuthBloc({required this.authFacade}) : super(AuthInitial()) {
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

    final loggedIn = await authFacade.isLoggedIn();
    if (loggedIn) {
      final userOpt = await authFacade.getCurrentUser();
      userOpt.fold(
        () => emit(AuthUnauthenticated()),
        (user) => emit(AuthAuthenticated(user)),
      );
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoggedIn(
    AuthLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await authFacade.login(event.email, event.password);
    await result.fold(
      (failure) async => emit(AuthFailure(_mapFailureToMessage(failure))),
      (authTokens) async {
        // Optionally store/use authTokens here if needed

        final userOpt = await authFacade.getCurrentUser();
        userOpt.fold(
          () => emit(const AuthFailure('Could not fetch user')),
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

    final result = await authFacade.signUp(
      event.name,
      event.email,
      event.password,
    );

    result.fold(
      (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
      (user) => emit(AuthSignedUpSuccess(user)),
    );
  }

  Future<void> _onAuthLoggedOut(
    AuthLoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await authFacade.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onAuthUserRequested(
    AuthUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final userOpt = await authFacade.getCurrentUser();
    userOpt.fold(
      () => emit(const AuthFailure('Could not fetch user')),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case CacheFailure _:
        return 'Cache error occurred';
      case ServerFailure _:
        return 'Server error occurred';
      case InvalidCredentialsFailure _:
        return 'Invalid email or password';
      default:
        return 'Unexpected error occurred';
    }
  }
}
