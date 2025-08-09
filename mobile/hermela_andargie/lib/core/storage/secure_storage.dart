import '../../features/auth/domain/entities/auth_tokens.dart';

abstract class SecuredStorage {
  Future<void> writeToken(AuthTokens tokens);
  Future<AuthTokens?> readToken();
  Future<void> deleteToken();
}
