import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatusUseCase extends UseCase<bool, NoParams> {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    try {
      final hasToken = await repository.hasToken();
      return Right(hasToken);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
