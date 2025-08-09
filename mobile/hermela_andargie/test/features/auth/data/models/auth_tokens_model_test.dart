import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/features/auth/data/models/auth_tokens_model.dart';
import 'package:hermela_andargie/features/auth/domain/entities/auth_tokens.dart';

void main() {
  const tAuthTokensModel = AuthTokensModel(
    accessToken: 'abc123',
    refreshToken: 'xyz789',
  );

  final tAuthTokensJson = {
    'accessToken': 'abc123',
    'refreshToken': 'xyz789',
    'expiresAt': null,
  };

  test('should be a subclass of AuthTokens entity', () {
    expect(tAuthTokensModel, isA<AuthTokens>());
  });

  test('fromJson should return valid model', () {
    final result = AuthTokensModel.fromJson(tAuthTokensJson);
    expect(result, tAuthTokensModel);
  });

  test('toJson should return valid map', () {
    final result = tAuthTokensModel.toJson();
    expect(result, tAuthTokensJson);
  });
}
