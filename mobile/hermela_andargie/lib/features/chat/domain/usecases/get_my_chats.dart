import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class GetMyChatsUseCase extends UseCase<List<Chat>, NoParams> {
  final ChatRepository repository;

  GetMyChatsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Chat>>> call(NoParams params) {
    return repository.getMyChats();
  }
}
