import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/features/auth/data/models/auth_credential_model.dart';
import 'package:hermela_andargie/features/auth/domain/entities/auth_credentials.dart';

void main() {
  const tAuthCredentialModel = AuthCredentialModel(
    email: 'test@example.com',
    password: 'password123',
  );

  final tAuthCredentialJson = {
    'email': 'test@example.com',
    'password': 'password123',
  };

  test('should be a subclass of AuthCredential entity', () {
    expect(tAuthCredentialModel, isA<AuthCredentials>());
  });

  test('fromJson should return valid model', () {
    final result = AuthCredentialModel.fromJson(tAuthCredentialJson);
    expect(result, tAuthCredentialModel);
  });

  test('toJson should return valid map', () {
    final result = tAuthCredentialModel.toJson();
    expect(result, tAuthCredentialJson);
  });
}
