import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/features/chat/data/models/chat_model.dart';
import 'package:hermela_andargie/features/chat/data/models/user_model.dart';

void main() {
  const user1Json = {'_id': 'u1', 'name': 'User 1', 'email': 'u1@example.com'};

  const user2Json = {'_id': 'u2', 'name': 'User 2', 'email': 'u2@example.com'};

  final sampleJson = {'_id': 'chat123', 'user1': user1Json, 'user2': user2Json};

  test('fromJson should return a valid model', () {
    final model = ChatModel.fromJson(sampleJson);

    expect(model.id, 'chat123');
    expect(model.user1, UserModel.fromJson(user1Json));
    expect(model.user2, UserModel.fromJson(user2Json));
  });

  test('toJson should return map matching input', () {
    final model = ChatModel.fromJson(sampleJson);
    expect(model.toJson(), sampleJson);
  });

  test('Equatable should consider identical models equal', () {
    final m1 = ChatModel.fromJson(sampleJson);
    final m2 = ChatModel.fromJson(sampleJson);
    expect(m1, m2);
  });
}
