import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NotFoundFailure extends Failure {
  final String message;

  const NotFoundFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class DuplicateFailure extends Failure {
  final String message;

  const DuplicateFailure(this.message);

  @override
  List<Object?> get props => [message];
}
class UnimplementedFailure extends Failure {}
class NoConnectionFailure extends Failure {}

class InvalidCredentialsFailure extends Failure {
  final String message;
  const InvalidCredentialsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
