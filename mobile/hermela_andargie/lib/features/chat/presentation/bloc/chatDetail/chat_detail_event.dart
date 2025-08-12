
part of 'chat_detail_bloc.dart';

abstract class ChatDetailEvent extends Equatable {
  const ChatDetailEvent();
  @override
  List<Object?> get props => [];
}

class LoadMessagesEvent extends ChatDetailEvent {}

class SendMessageEvent extends ChatDetailEvent {
  final String content;
  final String type;
  const SendMessageEvent(this.content, this.type);

  @override
  List<Object?> get props => [content, type];
}

class MessageReceivedFromSocketEvent extends ChatDetailEvent {
  final Message message;
  const MessageReceivedFromSocketEvent(this.message);

  @override
  List<Object?> get props => [message];
}
