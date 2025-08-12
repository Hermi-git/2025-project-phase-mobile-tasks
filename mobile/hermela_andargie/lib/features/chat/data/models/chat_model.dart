import '../../domain/entities/chat.dart';
import 'user_model.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.id,
    required UserModel super.user1,
    required UserModel super.user2,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final id = (json['_id'] ?? json['id'] ?? '') as String;
    final user1Json = json['user1'] as Map<String, dynamic>? ?? {};
    final user2Json = json['user2'] as Map<String, dynamic>? ?? {};

    return ChatModel(
      id: id,
      user1: UserModel.fromJson(user1Json),
      user2: UserModel.fromJson(user2Json),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'user1': (user1 as UserModel).toJson(),
    'user2': (user2 as UserModel).toJson(),
  };
}
