import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class SendMessageParams {
  final String chatId;
  final String content;
  final String type;

  SendMessageParams({
    required this.chatId,
    required this.content,
    required this.type,
  });
}

class SendMessageUseCase extends UseCase<Message, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) {
    return repository.sendMessage(
      chatId: params.chatId,
      content: params.content,
      type: params.type,
    );
  }
}
