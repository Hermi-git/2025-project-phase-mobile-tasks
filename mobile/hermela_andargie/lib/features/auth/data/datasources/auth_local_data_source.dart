import '../../../../core/errors/exception.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/auth_tokens_model.dart';


abstract class AuthLocalDataSource {
  Future<void> cacheTokens(AuthTokensModel tokens);
  Future<AuthTokensModel?> getTokens();
  Future<void> clearTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecuredStorage securedStorage;

  AuthLocalDataSourceImpl({required this.securedStorage});

  @override
  Future<void> cacheTokens(AuthTokensModel tokens) async {
    try {
      await securedStorage.writeToken(tokens);
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<AuthTokensModel?> getTokens() async {
    try {
      final tokens = await securedStorage.readToken();
      if (tokens == null) return null;
      return AuthTokensModel(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await securedStorage.deleteToken();
    } catch (_) {
      throw CacheException();
    }
  }
}
