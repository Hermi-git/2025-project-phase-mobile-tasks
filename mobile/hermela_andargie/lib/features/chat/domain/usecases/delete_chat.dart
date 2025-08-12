import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class DeleteChatParams {
  final String chatId;

  DeleteChatParams(this.chatId);
}

class DeleteChatUseCase extends UseCase<void, DeleteChatParams> {
  final ChatRepository repository;

  DeleteChatUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteChatParams params) {
    return repository.deleteChat(params.chatId);
  }
}
