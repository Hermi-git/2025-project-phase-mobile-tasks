// chat_detail_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chat.dart';
import '../../../domain/entities/chat_user.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/repositories/chat_repository.dart';

part 'chat_detail_event.dart';
part 'chat_detail_state.dart';

class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState> {
  final ChatRepository chatRepository;
  final String chatId;
  final ChatUser currentUser;
  final Chat currentChat;

  late final Stream<Message> _messageStreamSub;

  ChatDetailBloc({
    required this.chatRepository,
    required this.chatId,
    required this.currentUser,
    required this.currentChat,
  }) : super(ChatDetailLoading()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<MessageReceivedFromSocketEvent>(_onMessageReceivedFromSocket);

    _messageStreamSub = chatRepository.receivedMessages;
    _messageStreamSub.listen((message) {
      if (message.chat.id == chatId) {
        add(MessageReceivedFromSocketEvent(message));
      }
    });
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    emit(ChatDetailLoading());
    final result = await chatRepository.getChatMessages(chatId);
    result.fold(
      (failure) => emit(const ChatDetailError('Failed to load messages')),
      (messages) => emit(ChatDetailLoaded(messages)),
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    if (state is ChatDetailLoaded) {
      final currentState = state as ChatDetailLoaded;

      // Optimistic UI message using dynamic values
      final optimisticMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: currentUser,
        chat: currentChat,
        content: event.content,
        type: event.type,
      );

      emit(ChatDetailLoaded([...currentState.messages, optimisticMessage]));

      await chatRepository.sendMessage(
        chatId: chatId,
        content: event.content,
        type: event.type,
      );
    }
  }

  void _onMessageReceivedFromSocket(
    MessageReceivedFromSocketEvent event,
    Emitter<ChatDetailState> emit,
  ) {
    if (state is ChatDetailLoaded) {
      final currentState = state as ChatDetailLoaded;
      emit(ChatDetailLoaded([...currentState.messages, event.message]));
    }
  }
}
