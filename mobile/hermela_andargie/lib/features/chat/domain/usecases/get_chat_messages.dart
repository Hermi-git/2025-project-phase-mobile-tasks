import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetChatMessagesParams {
  final String chatId;

  GetChatMessagesParams(this.chatId);
}

class GetChatMessagesUseCase
    extends UseCase<List<Message>, GetChatMessagesParams> {
  final ChatRepository repository;

  GetChatMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(GetChatMessagesParams params) {
    return repository.getChatMessages(params.chatId);
  }
}
