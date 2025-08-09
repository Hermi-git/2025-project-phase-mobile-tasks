class ServerException implements Exception {}

class CacheException implements Exception {}

class InvalidCredentialsException implements Exception {
  final String message;
  InvalidCredentialsException(this.message);
}

class UnauthenticatedException implements Exception {}
