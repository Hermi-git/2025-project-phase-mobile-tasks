import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../core/constants/api_constants.dart';
import '../models/message_model.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

abstract class ChatSocketDataSource {
  void connect();
  void disconnect();

  void sendMessage({
    required String chatId,
    required String content,
    required String type,
  });

  Stream<MessageModel> get onMessageDelivered;
  Stream<MessageModel> get onMessageReceived;
}

class ChatSocketDataSourceImpl implements ChatSocketDataSource {
  final AuthRepository authRepository;
  late IO.Socket _socket;

  final _deliveredMessageController =
      StreamController<MessageModel>.broadcast();
  final _receivedMessageController = StreamController<MessageModel>.broadcast();

  ChatSocketDataSourceImpl({required this.authRepository});

  @override
  void connect() async {
    final tokens = await authRepository.getTokens();
    if (tokens == null) {
      throw Exception('No token found for socket connection');
    }
    final token = tokens.accessToken;

    _socket = IO.io(
      ApiConstants.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _socket.onConnect((_) {
      print('[Socket] Connected');
    });

    _socket.onDisconnect((_) {
      print('[Socket] Disconnected');
    });

    _socket.onError((error) {
      print('[Socket] Error: $error');
    });

    _socket.on('message:delivered', (data) {
      try {
        final message = MessageModel.fromJson(Map<String, dynamic>.from(data));
        _deliveredMessageController.add(message);
      } catch (e) {
        print('[Socket] Failed to parse delivered message: $e');
      }
    });

    _socket.on('message:received', (data) {
      try {
        final message = MessageModel.fromJson(Map<String, dynamic>.from(data));
        _receivedMessageController.add(message);
      } catch (e) {
        print('[Socket] Failed to parse received message: $e');
      }
    });
  }

  @override
  void sendMessage({
    required String chatId,
    required String content,
    required String type,
  }) {
    final payload = {'chatId': chatId, 'content': content, 'type': type};
    print('[Socket] Sending message: $payload');
    _socket.emit('message:send', payload);
  }

  @override
  void disconnect() {
    _socket.dispose();
    _deliveredMessageController.close();
    _receivedMessageController.close();
  }

  @override
  Stream<MessageModel> get onMessageDelivered =>
      _deliveredMessageController.stream;

  @override
  Stream<MessageModel> get onMessageReceived =>
      _receivedMessageController.stream;
}
