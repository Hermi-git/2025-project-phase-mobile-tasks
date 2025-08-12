import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/exception.dart';
import 'package:hermela_andargie/features/chat/data/datasources/chat_local_data_source_impl.dart';
import 'package:hermela_andargie/features/chat/data/models/chat_model.dart';
import 'package:hermela_andargie/features/chat/data/models/message_model.dart';
import 'package:hermela_andargie/features/chat/data/models/user_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late ChatLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  // Sample Users to use in tests
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

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ChatLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('cacheChats', () {
    final tChats = [ChatModel(id: 'chat1', user1: tUser1, user2: tUser2)];
    final tChatsJsonString = jsonEncode(tChats.map((c) => c.toJson()).toList());

    test('should call SharedPreferences to cache the chats', () async {
      when(
        mockSharedPreferences.setString(
          ChatLocalDataSourceImpl.cachedChatsKey,
          tChatsJsonString,
        ),
      ).thenAnswer((_) async => true);

      await dataSource.cacheChats(tChats);

      verify(
        mockSharedPreferences.setString(
          ChatLocalDataSourceImpl.cachedChatsKey,
          tChatsJsonString,
        ),
      );
    });
  });

  group('getCachedChats', () {
    final tChatsJson = [
      {
        "_id": "chat1",
        "user1": {"_id": "u1", "name": "User One", "email": "one@example.com"},
        "user2": {"_id": "u2", "name": "User Two", "email": "two@example.com"},
      },
    ];
    final tChatsJsonString = jsonEncode(tChatsJson);
    final tChatModels =
        tChatsJson.map((json) => ChatModel.fromJson(json)).toList();

    test('should return list of ChatModel when there is cached data', () async {
      when(
        mockSharedPreferences.getString(ChatLocalDataSourceImpl.cachedChatsKey),
      ).thenReturn(tChatsJsonString);

      final result = await dataSource.getCachedChats();

      verify(
        mockSharedPreferences.getString(ChatLocalDataSourceImpl.cachedChatsKey),
      );
      expect(result, equals(tChatModels));
    });

    test('should throw CacheException when there is no cached data', () async {
      when(
        mockSharedPreferences.getString(ChatLocalDataSourceImpl.cachedChatsKey),
      ).thenReturn(null);

      expect(() => dataSource.getCachedChats(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheMessages', () {
    final tChatId = 'chat1';
    final tMessages = [
      MessageModel(
        id: 'msg1',
        sender: tUser1,
        chat: ChatModel(id: tChatId, user1: tUser1, user2: tUser2),
        content: 'Hello',
        type: 'text',
      ),
    ];
    final tMessagesJsonString = jsonEncode(
      tMessages.map((m) => m.toJson()).toList(),
    );

    test(
      'should call SharedPreferences to cache the messages for given chatId',
      () async {
        when(
          mockSharedPreferences.setString(
            '${ChatLocalDataSourceImpl.cachedMessagesKeyPrefix}$tChatId',
            tMessagesJsonString,
          ),
        ).thenAnswer((_) async => true);

        await dataSource.cacheMessages(tChatId, tMessages);

        verify(
          mockSharedPreferences.setString(
            '${ChatLocalDataSourceImpl.cachedMessagesKeyPrefix}$tChatId',
            tMessagesJsonString,
          ),
        );
      },
    );
  });

  group('getCachedMessages', () {
    final tChatId = 'chat1';
    final tMessagesJson = [
      {
        "_id": "msg1",
        "sender": {"_id": "u1", "name": "User One", "email": "one@example.com"},
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
        "type": 'text',
      },
    ];
    final tMessagesJsonString = jsonEncode(tMessagesJson);
    final tMessageModels =
        tMessagesJson.map((json) => MessageModel.fromJson(json)).toList();

    test(
      'should return list of MessageModel when there is cached data',
      () async {
        when(
          mockSharedPreferences.getString(
            '${ChatLocalDataSourceImpl.cachedMessagesKeyPrefix}$tChatId',
          ),
        ).thenReturn(tMessagesJsonString);

        final result = await dataSource.getCachedMessages(tChatId);

        verify(
          mockSharedPreferences.getString(
            '${ChatLocalDataSourceImpl.cachedMessagesKeyPrefix}$tChatId',
          ),
        );
        expect(result, equals(tMessageModels));
      },
    );

    test('should throw CacheException when there is no cached data', () async {
      when(
        mockSharedPreferences.getString(
          '${ChatLocalDataSourceImpl.cachedMessagesKeyPrefix}$tChatId',
        ),
      ).thenReturn(null);

      expect(
        () => dataSource.getCachedMessages(tChatId),
        throwsA(isA<CacheException>()),
      );
    });
  });
}
