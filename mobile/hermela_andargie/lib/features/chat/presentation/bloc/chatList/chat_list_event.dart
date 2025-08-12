// chat_list_event.dart
part of 'chat_list_bloc.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();
  @override
  List<Object?> get props => [];
}

class LoadChatsEvent extends ChatListEvent {}

class ChatUpdatedFromSocketEvent extends ChatListEvent {
  final Message message;
  const ChatUpdatedFromSocketEvent(this.message);

  @override
  List<Object?> get props => [message];
}
