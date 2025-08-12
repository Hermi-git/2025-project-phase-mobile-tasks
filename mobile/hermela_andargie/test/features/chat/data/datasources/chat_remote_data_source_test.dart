import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/constants/api_constants.dart';
import 'package:hermela_andargie/core/constants/endpoints.dart';
import 'package:hermela_andargie/core/errors/exception.dart';
import 'package:hermela_andargie/features/chat/data/datasources/chat_remote_data_source_impl.dart';
import 'package:hermela_andargie/features/chat/data/models/chat_model.dart';
import 'package:hermela_andargie/features/chat/data/models/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chat_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ChatRemoteDataSourceImpl dataSource;
  late MockClient mockClient;
  const tToken = 'dummy_token_123';

  setUp(() {
    mockClient = MockClient();
    dataSource = ChatRemoteDataSourceImpl(client: mockClient, token: tToken);
  });

  final headersWithAuth = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $tToken',
  };
group('getMyChats', () {
    final tChatListJson = {
      "statusCode": 200,
      "message": "",
      "data": [
        {
          "_id": "chat1",
          "user1": {
            "_id": "u1",
            "name": "User One",
            "email": "one@example.com",
          },
          "user2": {
            "_id": "u2",
            "name": "User Two",
            "email": "two@example.com",
          },
        },
      ],
    };

    final tChatModels =
        (tChatListJson['data'] as List)
            .map((json) => ChatModel.fromJson(json))
            .toList();

    test(
      'should perform GET request and return list of ChatModel on success',
      () async {
        when(
          mockClient.get(
            Uri.parse('${ApiConstants.baseUrl}${Endpoints.getMyChats}'),
            headers: headersWithAuth,
          ),
        ).thenAnswer(
          (_) async => http.Response(jsonEncode(tChatListJson), 200),
        );

        final result = await dataSource.getMyChats();

        expect(result, equals(tChatModels));
        verify(
          mockClient.get(
            Uri.parse('${ApiConstants.baseUrl}${Endpoints.getMyChats}'),
            headers: headersWithAuth,
          ),
        );
      },
    );

    test('should throw UnauthenticatedException on 401', () async {
      when(
        mockClient.get(
          Uri.parse('${ApiConstants.baseUrl}${Endpoints.getMyChats}'),
          headers: headersWithAuth,
        ),
      ).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(
        () => dataSource.getMyChats(),
        throwsA(isA<UnauthenticatedException>()),
      );
    });

    test('should throw ServerException on other errors', () async {
      when(
        mockClient.get(
          Uri.parse('${ApiConstants.baseUrl}${Endpoints.getMyChats}'),
          headers: headersWithAuth,
        ),
      ).thenAnswer((_) async => http.Response('Error', 500));

      expect(() => dataSource.getMyChats(), throwsA(isA<ServerException>()));
    });
  });

  group('getChatMessages', () {
    final tChatId = 'chat1';
    final tMessagesJson = {
      "statusCode": 200,
      "message": "",
      "data": [
        {
          "_id": "msg1",
          "sender": {
            "_id": "u1",
            "name": "User One",
            "email": "one@example.com",
          },
          "chat": {
            "_id": tChatId,
            "user1": {
              "_id": "u1",
              "name": "User One",
              "email": "one@example.com",
            },
            "user2": {
              "_id": "u2",
              "name": "User Two",
              "email": "two@example.com",
            },
          },
          "content": 'Hello',
          "type": "text",
        },
      ],
    };

    final tMessageModels =
        (tMessagesJson['data'] as List)
            .map((json) => MessageModel.fromJson(json))
            .toList();

    test(
      'should perform GET request and return list of MessageModel on success',
      () async {
        when(
          mockClient.get(
            Uri.parse(
              '${ApiConstants.baseUrl}${Endpoints.getChatMessages(tChatId)}',
            ),
            headers: headersWithAuth,
          ),
        ).thenAnswer(
          (_) async => http.Response(jsonEncode(tMessagesJson), 200),
        );

        final result = await dataSource.getChatMessages(tChatId);

        expect(result, equals(tMessageModels));
        verify(
          mockClient.get(
            Uri.parse(
              '${ApiConstants.baseUrl}${Endpoints.getChatMessages(tChatId)}',
            ),
            headers: headersWithAuth,
          ),
        );
      },
    );

    test('should throw UnauthenticatedException on 401', () async {
      when(
        mockClient.get(
          Uri.parse(
            '${ApiConstants.baseUrl}${Endpoints.getChatMessages(tChatId)}',
          ),
          headers: headersWithAuth,
        ),
      ).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(
        () => dataSource.getChatMessages(tChatId),
        throwsA(isA<UnauthenticatedException>()),
      );
    });

    test('should throw ServerException on other errors', () async {
      when(
        mockClient.get(
          Uri.parse(
            '${ApiConstants.baseUrl}${Endpoints.getChatMessages(tChatId)}',
          ),
          headers: headersWithAuth,
        ),
      ).thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => dataSource.getChatMessages(tChatId),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('sendMessage', () {
    final tChatId = 'chat1';
    const tContent = 'Hello';
    const tType = 'text';

    final tMessageJson = {
      "_id": "msg1",
      "sender": {"_id": "u1", "name": "User One", "email": "one@example.com"},
      "chat": {
        "_id": tChatId,
        "user1": {"_id": "u1", "name": "User One", "email": "one@example.com"},
        "user2": {"_id": "u2", "name": "User Two", "email": "two@example.com"},
      },
      "content": tContent,
      "type": tType,
    };

    final tMessageModel = MessageModel.fromJson(tMessageJson);

    test(
      'should perform POST request and return MessageModel on success',
      () async {
        when(
          mockClient.post(
            Uri.parse(
              '${ApiConstants.baseUrl}${Endpoints.getChatMessages(tChatId)}',
            ),
            headers: headersWithAuth,
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response(jsonEncode(tMessageJson), 201));

        final result = await dataSource.sendMessage(
          chatId: tChatId,
          content: tContent,
          type: tType,
        );

        expect(result, equals(tMessageModel));
        verify(
          mockClient.post(
            Uri.parse(
              '${ApiConstants.baseUrl}${Endpoints.getChatMessages(tChatId)}',
            ),
            headers: headersWithAuth,
            body: jsonEncode({'content': tContent, 'type': tType}),
          ),
        );
      },
    );

    test('should throw UnauthenticatedException on 401', () async {
      when(
        mockClient.post(
          Uri.parse(
            '${ApiConstants.baseUrl}${Endpoints.getChatMessages(tChatId)}',
          ),
          headers: headersWithAuth,
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(
        () => dataSource.sendMessage(
          chatId: tChatId,
          content: tContent,
          type: tType,
        ),
        throwsA(isA<UnauthenticatedException>()),
      );
    });

    test('should throw ServerException on other errors', () async {
      when(
        mockClient.post(
          Uri.parse(
            '${ApiConstants.baseUrl}${Endpoints.getChatMessages(tChatId)}',
          ),
          headers: headersWithAuth,
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => dataSource.sendMessage(
          chatId: tChatId,
          content: tContent,
          type: tType,
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('initiateChat', () {
    const tUserId = 'user1';

    final tChatJson = {
      '_id': 'chat1',
      'user1': {'_id': 'u1', 'name': 'User One', 'email': 'one@example.com'},
      'user2': {'_id': 'u2', 'name': 'User Two', 'email': 'two@example.com'},
    };

    final tChatModel = ChatModel.fromJson(tChatJson);

    test(
      'should perform POST request and return ChatModel on success',
      () async {
        when(
          mockClient.post(
            Uri.parse('${ApiConstants.baseUrl}${Endpoints.initiateChat}'),
            headers: headersWithAuth,
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response(jsonEncode(tChatJson), 201));

        final result = await dataSource.initiateChat(tUserId);

        expect(result, equals(tChatModel));
        verify(
          mockClient.post(
            Uri.parse('${ApiConstants.baseUrl}${Endpoints.initiateChat}'),
            headers: headersWithAuth,
            body: jsonEncode({'userId': tUserId}),
          ),
        );
      },
    );

    test('should throw UnauthenticatedException on 401', () async {
      when(
        mockClient.post(
          Uri.parse('${ApiConstants.baseUrl}${Endpoints.initiateChat}'),
          headers: headersWithAuth,
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(
        () => dataSource.initiateChat(tUserId),
        throwsA(isA<UnauthenticatedException>()),
      );
    });

    test('should throw ServerException on other errors', () async {
      when(
        mockClient.post(
          Uri.parse('${ApiConstants.baseUrl}${Endpoints.initiateChat}'),
          headers: headersWithAuth,
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => dataSource.initiateChat(tUserId),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('deleteChat', () {
    const tChatId = 'chat1';

    test('should perform DELETE request and complete on success', () async {
      when(
        mockClient.delete(
          Uri.parse('${ApiConstants.baseUrl}${Endpoints.deleteChat(tChatId)}'),
          headers: headersWithAuth,
        ),
      ).thenAnswer((_) async => http.Response('', 204));

      await dataSource.deleteChat(tChatId);

      verify(
        mockClient.delete(
          Uri.parse('${ApiConstants.baseUrl}${Endpoints.deleteChat(tChatId)}'),
          headers: headersWithAuth,
        ),
      );
    });

    test('should throw UnauthenticatedException on 401', () async {
      when(
        mockClient.delete(
          Uri.parse('${ApiConstants.baseUrl}${Endpoints.deleteChat(tChatId)}'),
          headers: headersWithAuth,
        ),
      ).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(
        () => dataSource.deleteChat(tChatId),
        throwsA(isA<UnauthenticatedException>()),
      );
    });

    test('should throw ServerException on other errors', () async {
      when(
        mockClient.delete(
          Uri.parse('${ApiConstants.baseUrl}${Endpoints.deleteChat(tChatId)}'),
          headers: headersWithAuth,
        ),
      ).thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => dataSource.deleteChat(tChatId),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
