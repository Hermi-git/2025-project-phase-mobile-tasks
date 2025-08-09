import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/models/auth_tokens_model.dart';
import '../../features/auth/domain/entities/auth_tokens.dart';
import './secure_storage.dart';

class SecuredStorageImpl implements SecuredStorage {
  final FlutterSecureStorage storage;
  static const _tokenKey = 'auth_tokens';

  SecuredStorageImpl({required this.storage});

  @override
  Future<void> writeToken(AuthTokens tokens) async {
    final jsonString = jsonEncode(
      AuthTokensModel(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      ).toJson(),
    );
    await storage.write(key: _tokenKey, value: jsonString);
  }

  @override
  Future<AuthTokens?> readToken() async {
    final jsonString = await storage.read(key: _tokenKey);
    if (jsonString == null) return null;
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return AuthTokensModel.fromJson(jsonMap);
  }

  @override
  Future<void> deleteToken() async {
    await storage.delete(key: _tokenKey);
  }
}
