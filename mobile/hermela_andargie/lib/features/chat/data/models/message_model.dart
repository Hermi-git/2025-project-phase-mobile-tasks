import '../../domain/entities/message.dart';
import 'chat_model.dart';
import 'user_model.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required UserModel super.sender,
    required ChatModel super.chat,
    required super.content,
    required super.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final id = (json['_id'] ?? json['id'] ?? '') as String;
    final senderJson = json['sender'] as Map<String, dynamic>? ?? {};
    final chatJson = json['chat'] as Map<String, dynamic>? ?? {};
    final content = (json['content'] ?? '') as String;
    final type = (json['type'] ?? 'text') as String;

    return MessageModel(
      id: id,
      sender: UserModel.fromJson(senderJson),
      chat: ChatModel.fromJson(chatJson),
      content: content,
      type: type,
    );
  }

  Map<String, dynamic> toSendPayload({required String chatId}) => {
    'chatId': chatId,
    'content': content,
    'type': type,
  };

  Map<String, dynamic> toJson() => {
    '_id': id,
    'sender': (sender as UserModel).toJson(),
    'chat': (chat as ChatModel).toJson(),
    'content': content,
    'type': type,
  };
}
