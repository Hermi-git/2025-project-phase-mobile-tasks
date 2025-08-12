// chat_list_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chat.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/repositories/chat_repository.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepository chatRepository;
  late final Stream<Message> _messageStreamSub;

  ChatListBloc({required this.chatRepository}) : super(ChatListLoading()) {
    on<LoadChatsEvent>(_onLoadChats);
    on<ChatUpdatedFromSocketEvent>(_onChatUpdatedFromSocket);

    // Listen to incoming messages from socket
    _messageStreamSub = chatRepository.receivedMessages;
    _messageStreamSub.listen((message) {
      add(ChatUpdatedFromSocketEvent(message));
    });
  }

  Future<void> _onLoadChats(
    LoadChatsEvent event,
    Emitter<ChatListState> emit,
  ) async {
    emit(ChatListLoading());
    final result = await chatRepository.getMyChats();
    result.fold(
      (failure) => emit(const ChatListError('Failed to load chats')),
      (chats) => emit(ChatListLoaded(chats)),
    );
  }

void _onChatUpdatedFromSocket(
  ChatUpdatedFromSocketEvent event,
  Emitter<ChatListState> emit,
) {
  if (state is ChatListLoaded) {
    final currentState = state as ChatListLoaded;

    final updatedChats = currentState.chats.map((chat) {
      if (chat.id == event.message.chat.id) {
        return Chat(
          id: chat.id,
          user1: chat.user1,
          user2: chat.user2,
        );
      }
      return chat;
    }).toList();

    emit(ChatListLoaded(updatedChats));
  }
}
}
