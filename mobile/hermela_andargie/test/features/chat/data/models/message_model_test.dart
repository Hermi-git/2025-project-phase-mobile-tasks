import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/features/chat/data/models/chat_model.dart';
import 'package:hermela_andargie/features/chat/data/models/message_model.dart';
import 'package:hermela_andargie/features/chat/data/models/user_model.dart';

void main() {
  const senderJson = {
    '_id': 'sender123',
    'name': 'Sender User',
    'email': 'sender@example.com',
  };

  const user1Json = {'_id': 'u1', 'name': 'User 1', 'email': 'u1@example.com'};

  const user2Json = {'_id': 'u2', 'name': 'User 2', 'email': 'u2@example.com'};

  final chatJson = {'_id': 'chat123', 'user1': user1Json, 'user2': user2Json};

  final sampleJson = {
    '_id': 'msg123',
    'sender': senderJson,
    'chat': chatJson,
    'content': 'Hello, world!',
    'type': 'text',
  };

  test('fromJson should return valid model', () {
    final model = MessageModel.fromJson(sampleJson);

    expect(model.id, 'msg123');
    expect(model.sender, UserModel.fromJson(senderJson));
    expect(model.chat, ChatModel.fromJson(chatJson));
    expect(model.content, 'Hello, world!');
    expect(model.type, 'text');
  });

  test('toJson should return map matching input', () {
    final model = MessageModel.fromJson(sampleJson);
    expect(model.toJson(), sampleJson);
  });

  test('toSendPayload should return expected map', () {
    final model = MessageModel.fromJson(sampleJson);
    expect(model.toSendPayload(chatId: 'chat123'), {
      'chatId': 'chat123',
      'content': 'Hello, world!',
      'type': 'text',
    });
  });

  test('Equatable should consider identical models equal', () {
    final m1 = MessageModel.fromJson(sampleJson);
    final m2 = MessageModel.fromJson(sampleJson);
    expect(m1, m2);
  });
}
