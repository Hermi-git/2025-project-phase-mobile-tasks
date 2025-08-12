import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/exception.dart';
import 'package:hermela_andargie/core/errors/failures.dart';
import 'package:hermela_andargie/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:hermela_andargie/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:hermela_andargie/features/chat/data/datasources/chat_socket_data_source.dart';
import 'package:hermela_andargie/features/chat/data/models/chat_model.dart';
import 'package:hermela_andargie/features/chat/data/models/message_model.dart';
import 'package:hermela_andargie/features/chat/data/models/user_model.dart';
import 'package:hermela_andargie/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:hermela_andargie/features/chat/domain/entities/chat.dart';
import 'package:hermela_andargie/features/chat/domain/entities/message.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chat_repository_impl_test.mocks.dart';

@GenerateMocks([
  ChatRemoteDataSource,
  ChatLocalDataSource,
  ChatSocketDataSource,
])
void main() {
  late MockChatRemoteDataSource mockRemoteDataSource;
  late MockChatLocalDataSource mockLocalDataSource;
  late MockChatSocketDataSource mockSocketDataSource;
  late ChatRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockChatRemoteDataSource();
    mockLocalDataSource = MockChatLocalDataSource();
    mockSocketDataSource = MockChatSocketDataSource();

    repository = ChatRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      socketDataSource: mockSocketDataSource,
    );
  });

  // Sample users/chat/message used across tests
  final tUser1 = const UserModel(
    id: 'u1',
    name: 'User One',
    email: 'one@example.com',
  );
  final tUser2 = const UserModel(
    id: 'u2',
    name: 'User Two',
    email: 'two@example.com',
  );
  final tChatModel = ChatModel(id: 'chat1', user1: tUser1, user2: tUser2);
  final tChatModelList = <ChatModel>[tChatModel];
  final tMessageModel = MessageModel(
    id: 'm1',
    sender: tUser1,
    chat: tChatModel,
    content: 'Hello',
    type: 'text',
  );
  final tMessageModelList = <MessageModel>[tMessageModel];

  group('getMyChats', () {
    test('should return remote chats and cache them on success', () async {
      when(
        mockRemoteDataSource.getMyChats(),
      ).thenAnswer((_) async => tChatModelList);

      final result = await repository.getMyChats();

      expect(result, Right(tChatModelList));
      verify(mockRemoteDataSource.getMyChats());
      verify(mockLocalDataSource.cacheChats(tChatModelList));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test(
      'should return cached chats when remote throws ServerException',
      () async {
        when(mockRemoteDataSource.getMyChats()).thenThrow(ServerException());
        when(
          mockLocalDataSource.getCachedChats(),
        ).thenAnswer((_) async => tChatModelList);

        final result = await repository.getMyChats();

        expect(result, Right(tChatModelList));
        verify(mockRemoteDataSource.getMyChats());
        verify(mockLocalDataSource.getCachedChats());
      },
    );

    test(
      'should return ServerFailure when both remote and local fail',
      () async {
        when(mockRemoteDataSource.getMyChats()).thenThrow(ServerException());
        when(mockLocalDataSource.getCachedChats()).thenThrow(Exception());

        final result = await repository.getMyChats();

        expect(result, Left(ServerFailure()));
        verify(mockRemoteDataSource.getMyChats());
        verify(mockLocalDataSource.getCachedChats());
      },
    );
  });

  group('getChatMessages', () {
    const chatId = 'chat1';

    test('should return remote messages and cache them on success', () async {
      when(
        mockRemoteDataSource.getChatMessages(chatId),
      ).thenAnswer((_) async => tMessageModelList);

      final result = await repository.getChatMessages(chatId);

      expect(result, Right(tMessageModelList));
      verify(mockRemoteDataSource.getChatMessages(chatId));
      verify(mockLocalDataSource.cacheMessages(chatId, tMessageModelList));
    });

    test(
      'should return cached messages when remote throws ServerException',
      () async {
        when(
          mockRemoteDataSource.getChatMessages(chatId),
        ).thenThrow(ServerException());
        when(
          mockLocalDataSource.getCachedMessages(chatId),
        ).thenAnswer((_) async => tMessageModelList);

        final result = await repository.getChatMessages(chatId);

        expect(result, Right(tMessageModelList));
        verify(mockRemoteDataSource.getChatMessages(chatId));
        verify(mockLocalDataSource.getCachedMessages(chatId));
      },
    );

    test(
      'should return ServerFailure when both remote and local fail',
      () async {
        when(
          mockRemoteDataSource.getChatMessages(chatId),
        ).thenThrow(ServerException());
        when(
          mockLocalDataSource.getCachedMessages(chatId),
        ).thenThrow(Exception());

        final result = await repository.getChatMessages(chatId);

        expect(result, Left(ServerFailure()));
        verify(mockRemoteDataSource.getChatMessages(chatId));
        verify(mockLocalDataSource.getCachedMessages(chatId));
      },
    );
  });

  group('sendMessage', () {
    const chatId = 'chat1';
    const content = 'Hello';
    const type = 'text';

    test(
      'should send message via socket and remote and return sent message',
      () async {
        // Remote returns the persisted message
        when(
          mockRemoteDataSource.sendMessage(
            chatId: chatId,
            content: content,
            type: type,
          ),
        ).thenAnswer((_) async => tMessageModel);

        final result = await repository.sendMessage(
          chatId: chatId,
          content: content,
          type: type,
        );

        expect(result, Right(tMessageModel));
        verify(
          mockSocketDataSource.sendMessage(
            chatId: chatId,
            content: content,
            type: type,
          ),
        );
        verify(
          mockRemoteDataSource.sendMessage(
            chatId: chatId,
            content: content,
            type: type,
          ),
        );
      },
    );

    test(
      'should return ServerFailure when remote send throws ServerException',
      () async {
        when(
          mockRemoteDataSource.sendMessage(
            chatId: chatId,
            content: content,
            type: type,
          ),
        ).thenThrow(ServerException());

        final result = await repository.sendMessage(
          chatId: chatId,
          content: content,
          type: type,
        );

        expect(result, Left(ServerFailure()));
        verify(
          mockSocketDataSource.sendMessage(
            chatId: chatId,
            content: content,
            type: type,
          ),
        );
        verify(
          mockRemoteDataSource.sendMessage(
            chatId: chatId,
            content: content,
            type: type,
          ),
        );
      },
    );
  });

  group('initiateChat', () {
    const userId = 'u2';
    test('should call remote and return Chat on success', () async {
      when(
        mockRemoteDataSource.initiateChat(userId),
      ).thenAnswer((_) async => tChatModel);

      final result = await repository.initiateChat(userId);

      expect(result, Right(tChatModel));
      verify(mockRemoteDataSource.initiateChat(userId));
    });

    test('should return ServerFailure when remote throws', () async {
      when(
        mockRemoteDataSource.initiateChat(userId),
      ).thenThrow(ServerException());

      final result = await repository.initiateChat(userId);

      expect(result, Left(ServerFailure()));
      verify(mockRemoteDataSource.initiateChat(userId));
    });
  });

  group('deleteChat', () {
    const chatId = 'chat1';
    test('should call remote delete and return success', () async {
      when(
        mockRemoteDataSource.deleteChat(chatId),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.deleteChat(chatId);

      expect(result, Right(null));
      verify(mockRemoteDataSource.deleteChat(chatId));
    });

    test('should return ServerFailure when remote throws', () async {
      when(
        mockRemoteDataSource.deleteChat(chatId),
      ).thenThrow(ServerException());

      final result = await repository.deleteChat(chatId);

      expect(result, Left(ServerFailure()));
      verify(mockRemoteDataSource.deleteChat(chatId));
    });
  });

  group('socket lifecycle & streams', () {
    test('initSocketConnection calls socketDataSource.connect', () {
      repository.initSocketConnection();
      verify(mockSocketDataSource.connect());
    });

    test('disposeSocketConnection calls socketDataSource.disconnect', () {
      repository.disposeSocketConnection();
      verify(mockSocketDataSource.disconnect());
    });

    test('deliveredMessages exposes socket stream', () {
      final stream = Stream<Message>.value(tMessageModel);
      when(mockSocketDataSource.onMessageDelivered).thenAnswer((_) => stream);

      expect(repository.deliveredMessages, stream);
    });

    test('receivedMessages exposes socket stream', () {
      final stream = Stream<Message>.value(tMessageModel);
      when(mockSocketDataSource.onMessageReceived).thenAnswer((_) => stream);

      expect(repository.receivedMessages, stream);
    });
  });
}
