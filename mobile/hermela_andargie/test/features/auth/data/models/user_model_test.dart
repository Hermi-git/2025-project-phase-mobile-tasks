import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/features/auth/data/models/user_model.dart';
import 'package:hermela_andargie/features/auth/domain/entities/user.dart';

void main() {
  const tUserModel = UserModel(
    id: '123',
    name: 'Test User',
    email: 'test@example.com',
  );

  final tUserJson = {
    '_id': '123',
    'name': 'Test User',
    'email': 'test@example.com',
  };

  test('should be a subclass of User entity', () {
    expect(tUserModel, isA<User>());
  });

  test('fromJson should return valid model', () {
    final result = UserModel.fromJson(tUserJson);
    expect(result, tUserModel);
  });

  test('toJson should return valid map', () {
    final result = tUserModel.toJson();
    expect(result, tUserJson);
  });
}
