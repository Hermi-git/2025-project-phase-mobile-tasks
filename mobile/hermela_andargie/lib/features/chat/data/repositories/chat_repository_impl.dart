import 'package:dartz/dartz.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_data_source.dart';
import '../datasources/chat_remote_data_source.dart';
import '../datasources/chat_socket_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  final ChatSocketDataSource socketDataSource;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.socketDataSource,
  });

  /// Connect socket when repository is created
  void initSocketConnection() {
    socketDataSource.connect();
  }

  /// Disconnect socket (on logout or app close)
  void disposeSocketConnection() {
    socketDataSource.disconnect();
  }

  @override
  Future<Either<Failure, List<Chat>>> getMyChats() async {
    try {
      final chats = await remoteDataSource.getMyChats();

      // Cache for offline usage
      await localDataSource.cacheChats(chats);

      return Right(chats);
    } on ServerException {
      // On failure, try loading cached chats
      try {
        final cached = await localDataSource.getCachedChats();
        return Right(cached);
      } catch (_) {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId) async {
    try {
      final messages = await remoteDataSource.getChatMessages(chatId);

      // Cache for offline usage
      await localDataSource.cacheMessages(chatId, messages);

      return Right(messages);
    } on ServerException {
      try {
        final cached = await localDataSource.getCachedMessages(chatId);
        return Right(cached);
      } catch (_) {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String chatId,
    required String content,
    required String type,
  }) async {
    try {
      // 1. Send through socket
      socketDataSource.sendMessage(
        chatId: chatId,
        content: content,
        type: type,
      );

      // 2. Also call REST API to persist (optional if server already persists from socket)
      final sentMessage = await remoteDataSource.sendMessage(
        chatId: chatId,
        content: content,
        type: type,
      );

      return Right(sentMessage);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Chat>> initiateChat(String userId) async {
    try {
      final chat = await remoteDataSource.initiateChat(userId);
      return Right(chat);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteChat(String chatId) async {
    try {
      await remoteDataSource.deleteChat(chatId);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  /// Expose delivered messages stream
  Stream<Message> get deliveredMessages => socketDataSource.onMessageDelivered;

  /// Expose received messages stream
  Stream<Message> get receivedMessages => socketDataSource.onMessageReceived;
}
