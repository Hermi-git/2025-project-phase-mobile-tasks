import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class InitiateChatParams {
  final String userId;

  InitiateChatParams(this.userId);
}

class InitiateChatUseCase extends UseCase<Chat, InitiateChatParams> {
  final ChatRepository repository;

  InitiateChatUseCase(this.repository);

  @override
  Future<Either<Failure, Chat>> call(InitiateChatParams params) {
    return repository.initiateChat(params.userId);
  }
}
