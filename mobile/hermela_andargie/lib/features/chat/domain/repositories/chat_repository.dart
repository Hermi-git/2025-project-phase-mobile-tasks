import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/chat.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Chat>>> getMyChats();
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId);
  Future<Either<Failure, Message>> sendMessage({
    required String chatId,
    required String content,
    required String type,
  });
  Future<Either<Failure, Chat>> initiateChat(String userId);
  Future<Either<Failure, void>> deleteChat(String chatId);
  Stream<Message> get receivedMessages; 
  Stream<Message> get deliveredMessages;
}
