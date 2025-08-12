import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getMyChats();
  Future<List<MessageModel>> getChatMessages(String chatId);
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    required String type,
  });
  Future<ChatModel> initiateChat(String userId);
  Future<void> deleteChat(String chatId);
}
