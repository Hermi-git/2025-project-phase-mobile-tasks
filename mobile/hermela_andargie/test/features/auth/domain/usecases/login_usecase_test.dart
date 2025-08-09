import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/features/auth/domain/entities/auth_tokens.dart';
import 'package:hermela_andargie/features/auth/domain/repositories/auth_repository.dart';
import 'package:hermela_andargie/features/auth/domain/usecases/login_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late LoginUseCase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUseCase(mockRepository);
  });

  final tEmail = 'test@example.com';
  final tPassword = 'password123';
  final tTokens = AuthTokens(
    accessToken: 'token123',
    refreshToken: 'refresh123',
  );

  test(
    'should get AuthTokens from repository when login is successful',
    () async {
      when(
        mockRepository.login(email: tEmail, password: tPassword),
      ).thenAnswer((_) async => Right(tTokens));

     final result = await usecase.call(
        LoginParams(email: tEmail, password: tPassword),
      );

      expect(result, Right(tTokens));
      verify(mockRepository.login(email: tEmail, password: tPassword));
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
