import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final String email;
  final String password;

  const AuthLoggedIn({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignedUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthSignedUp({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

/// Triggered when user logs out
class AuthLoggedOut extends AuthEvent {}

/// Optional: Trigger refresh user info (e.g. after login/signup)
class AuthUserRequested extends AuthEvent {}
