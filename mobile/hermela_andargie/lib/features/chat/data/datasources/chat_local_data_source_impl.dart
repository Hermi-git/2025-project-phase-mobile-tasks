import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exception.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'chat_local_data_source.dart';

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  static const cachedChatsKey = 'CACHED_CHATS';
  static const cachedMessagesKeyPrefix = 'CACHED_MESSAGES_';

  final SharedPreferences sharedPreferences;

  ChatLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheChats(List<ChatModel> chats) {
    final jsonString = jsonEncode(chats.map((c) => c.toJson()).toList());
    return sharedPreferences.setString(cachedChatsKey, jsonString);
  }

  @override
  Future<List<ChatModel>> getCachedChats() {
    final jsonString = sharedPreferences.getString(cachedChatsKey);
    if (jsonString == null) throw CacheException();
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return Future.value(jsonList.map((e) => ChatModel.fromJson(e)).toList());
  }

  @override
  Future<void> cacheMessages(String chatId, List<MessageModel> messages) {
    final jsonString = jsonEncode(messages.map((m) => m.toJson()).toList());
    return sharedPreferences.setString(
      '$cachedMessagesKeyPrefix$chatId',
      jsonString,
    );
  }

  @override
  Future<List<MessageModel>> getCachedMessages(String chatId) {
    final jsonString = sharedPreferences.getString(
      '$cachedMessagesKeyPrefix$chatId',
    );
    if (jsonString == null) throw CacheException();
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return Future.value(jsonList.map((e) => MessageModel.fromJson(e)).toList());
  }
}
