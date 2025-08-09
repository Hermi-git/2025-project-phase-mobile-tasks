import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/exception.dart';
import 'package:hermela_andargie/core/errors/failures.dart';
import 'package:hermela_andargie/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:hermela_andargie/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hermela_andargie/features/auth/data/models/auth_tokens_model.dart';
import 'package:hermela_andargie/features/auth/data/models/user_model.dart';
import 'package:hermela_andargie/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:hermela_andargie/features/auth/domain/entities/auth_tokens.dart';
import 'package:hermela_andargie/features/auth/domain/entities/user.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource, AuthLocalDataSource])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tEmail = 'test@example.com';
  final tPassword = 'password123';
  final tName = 'Test User';

  // Use Models here for mocking datasources
  final tTokensModel = const AuthTokensModel(
    accessToken: 'access123',
    refreshToken: 'refresh123',
  );
  final tUserModel = UserModel(id: '1', name: tName, email: tEmail);

  // Domain entities for expect() and repo results
  final tTokensEntity = AuthTokens(
    accessToken: tTokensModel.accessToken,
    refreshToken: tTokensModel.refreshToken,
  );

  final tUserEntity = User(
    id: tUserModel.id,
    name: tUserModel.name,
    email: tUserModel.email,
  );


  group('login', () {
    test('should return tokens when login is successful', () async {
      when(
        mockRemoteDataSource.login(email: tEmail, password: tPassword),
      ).thenAnswer((_) async => tTokensModel);

      when(
        mockLocalDataSource.cacheTokens(tTokensModel),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.login(email: tEmail, password: tPassword);

      expect(result, Right(tTokensEntity));
      verify(mockRemoteDataSource.login(email: tEmail, password: tPassword));
      verify(mockLocalDataSource.cacheTokens(tTokensModel));
    });

    test(
      'should return InvalidCredentialsFailure when invalid credentials',
      () async {
        when(
          mockRemoteDataSource.login(email: tEmail, password: tPassword),
        ).thenThrow(InvalidCredentialsException('Invalid credentials'));

        final result = await repository.login(
          email: tEmail,
          password: tPassword,
        );

        expect(result, Left(InvalidCredentialsFailure('Invalid credentials')));
        verify(mockRemoteDataSource.login(email: tEmail, password: tPassword));
        verifyZeroInteractions(mockLocalDataSource);
      },
    );

    test('should return ServerFailure when server error', () async {
      when(
        mockRemoteDataSource.login(email: tEmail, password: tPassword),
      ).thenThrow(ServerException());

      final result = await repository.login(email: tEmail, password: tPassword);

      expect(result, Left(ServerFailure()));
      verify(mockRemoteDataSource.login(email: tEmail, password: tPassword));
      verifyZeroInteractions(mockLocalDataSource);
    });
  });

  group('register', () {
    test('should return user when registration is successful', () async {
      when(
        mockRemoteDataSource.register(
          name: tName,
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => tUserModel);

      final result = await repository.register(
        name: tName,
        email: tEmail,
        password: tPassword,
      );

      expect(result, Right(tUserEntity));
      verify(
        mockRemoteDataSource.register(
          name: tName,
          email: tEmail,
          password: tPassword,
        ),
      );
    });

    test('should return ServerFailure when server error', () async {
      when(
        mockRemoteDataSource.register(
          name: tName,
          email: tEmail,
          password: tPassword,
        ),
      ).thenThrow(ServerException());

      final result = await repository.register(
        name: tName,
        email: tEmail,
        password: tPassword,
      );

      expect(result, Left(ServerFailure()));
      verify(
        mockRemoteDataSource.register(
          name: tName,
          email: tEmail,
          password: tPassword,
        ),
      );
    });
  });

  group('logout', () {
    test('should delete tokens successfully', () async {
      when(
        mockLocalDataSource.clearTokens(),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.logout();

      expect(result, const Right(null));
      verify(mockLocalDataSource.clearTokens());
    });

    test('should return CacheFailure when error deleting tokens', () async {
      when(mockLocalDataSource.clearTokens()).thenThrow(Exception());

      final result = await repository.logout();

      expect(result, Left(CacheFailure()));
      verify(mockLocalDataSource.clearTokens());
    });
  });

  group('getCurrentUser', () {
    test(
      'should return user when token exists and remote call successful',
      () async {
        when(
          mockLocalDataSource.getTokens(),
        ).thenAnswer((_) async => tTokensModel);
        when(
          mockRemoteDataSource.getCurrentUser(tTokensModel.accessToken),
        ).thenAnswer((_) async => tUserModel);

        final result = await repository.getCurrentUser();

        expect(result, Right(tUserEntity));
        verify(mockLocalDataSource.getTokens());
        verify(mockRemoteDataSource.getCurrentUser(tTokensModel.accessToken));
      },
    );

    test('should return CacheFailure when no token found', () async {
      when(mockLocalDataSource.getTokens()).thenAnswer((_) async => null);

      final result = await repository.getCurrentUser();

      expect(result, Left(CacheFailure()));
      verify(mockLocalDataSource.getTokens());
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('should return ServerFailure when remote server error', () async {
      when(
        mockLocalDataSource.getTokens(),
      ).thenAnswer((_) async => tTokensModel);
      when(
        mockRemoteDataSource.getCurrentUser(tTokensModel.accessToken),
      ).thenThrow(ServerException());

      final result = await repository.getCurrentUser();

      expect(result, Left(ServerFailure()));
      verify(mockLocalDataSource.getTokens());
      verify(mockRemoteDataSource.getCurrentUser(tTokensModel.accessToken));
    });
  });

  group('hasToken', () {
  test('should return true when tokens exist', () async {
    when(
      mockLocalDataSource.getTokens(),
    ).thenAnswer((_) async => tTokensModel);

    final result = await repository.hasToken();

    expect(result, true); // plain bool expected
    verify(mockLocalDataSource.getTokens());
  });

  test('should return false when tokens do not exist', () async {
    when(mockLocalDataSource.getTokens()).thenAnswer((_) async => null);

    final result = await repository.hasToken();

    expect(result, false); // plain bool expected
    verify(mockLocalDataSource.getTokens());
  });

  test('should return false on exception', () async {
    when(mockLocalDataSource.getTokens()).thenThrow(Exception());

    final result = await repository.hasToken();

    expect(result, false); 
    verify(mockLocalDataSource.getTokens());
  });
});
}