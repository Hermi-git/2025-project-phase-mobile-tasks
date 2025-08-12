import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/endpoints.dart';
import '../../../../core/errors/exception.dart';
import '../../../auth/domain/repositories/auth_repository.dart'; 
import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'chat_remote_data_source.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  final AuthRepository authRepository;

  ChatRemoteDataSourceImpl({
    required this.client,
    required this.authRepository,
  });

  Future<Map<String, String>> get _headers async {
    // get token dynamically
    final hasToken = await authRepository.hasToken();
    if (!hasToken) {
      throw UnauthenticatedException();
    }

    
    final tokensResult = await authRepository.getCurrentUser();

    final tokens = await authRepository.getTokens(); 
    if (tokens == null) {
      throw UnauthenticatedException();
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${tokens.accessToken}',
    };
  }

  @override
  Future<List<ChatModel>> getMyChats() async {
    final headers = await _headers;
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${Endpoints.getMyChats}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final List<dynamic> dataList = decoded['data'];
      return dataList.map((e) => ChatModel.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      throw UnauthenticatedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MessageModel>> getChatMessages(String chatId) async {
    final headers = await _headers;
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${Endpoints.getChatMessages(chatId)}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final List<dynamic> dataList = decoded['data'];
      return dataList.map((e) => MessageModel.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      throw UnauthenticatedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    required String type,
  }) async {
    final headers = await _headers;
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}${Endpoints.getChatMessages(chatId)}'),
      headers: headers,
      body: jsonEncode({'content': content, 'type': type}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return MessageModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthenticatedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ChatModel> initiateChat(String userId) async {
    final headers = await _headers;
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}${Endpoints.initiateChat}'),
      headers: headers,
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return ChatModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthenticatedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final headers = await _headers;
    final response = await client.delete(
      Uri.parse('${ApiConstants.baseUrl}${Endpoints.deleteChat(chatId)}'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    } else if (response.statusCode == 401) {
      throw UnauthenticatedException();
    } else {
      throw ServerException();
    }
  }
}
