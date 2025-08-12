import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/features/chat/data/models/user_model.dart';

void main() {
  const sampleJson = {
    '_id': '66bde36e9bbe07fc39034cdd',
    'name': 'Mr. User',
    'email': 'user@gmail.com',
  };

  test('fromJson should return a valid model', () {
    final model = UserModel.fromJson(sampleJson);

    expect(model.id, '66bde36e9bbe07fc39034cdd');
    expect(model.name, 'Mr. User');
    expect(model.email, 'user@gmail.com');
  });

  test('toJson should return a map matching input', () {
    final model = UserModel.fromJson(sampleJson);
    expect(model.toJson(), sampleJson);
  });

  test('Equatable should consider identical models equal', () {
    final m1 = UserModel.fromJson(sampleJson);
    final m2 = UserModel.fromJson(sampleJson);
    expect(m1, m2);
  });
}
