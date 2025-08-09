import 'package:dartz/dartz.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    try {
      final tokensModel = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await localDataSource.cacheTokens(tokensModel);

      final tokensEntity = AuthTokens(
        accessToken: tokensModel.accessToken,
        refreshToken: tokensModel.refreshToken,
      );

      return Right(tokensEntity);
    } on InvalidCredentialsException catch (e) {
      return Left(InvalidCredentialsFailure(e.message));
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );

      final userEntity = User(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
      );

      return Right(userEntity);
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearTokens();
      return const Right(null);
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final tokensModel = await localDataSource.getTokens();
      if (tokensModel == null) return Left(CacheFailure());

      final userModel = await remoteDataSource.getCurrentUser(
        tokensModel.accessToken,
      );

      final userEntity = User(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
      );

      return Right(userEntity);
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }

 @override
  Future<bool> hasToken() async {
    try {
      final tokens = await localDataSource.getTokens();
      return tokens != null;
    } catch (_) {
      return false;
    }
  }

}
