
part of 'chat_detail_bloc.dart';

abstract class ChatDetailState extends Equatable {
  const ChatDetailState();
  @override
  List<Object?> get props => [];
}

class ChatDetailLoading extends ChatDetailState {}

class ChatDetailLoaded extends ChatDetailState {
  final List<Message> messages;
  const ChatDetailLoaded(this.messages);
  @override
  List<Object?> get props => [messages];
}

class ChatDetailError extends ChatDetailState {
  final String message;
  const ChatDetailError(this.message);
  @override
  List<Object?> get props => [message];
}
