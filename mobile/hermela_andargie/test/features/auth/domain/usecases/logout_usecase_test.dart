// logout_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/failures.dart';
import 'package:hermela_andargie/core/usecases/usecase.dart';
import 'package:hermela_andargie/features/auth/domain/repositories/auth_repository.dart';
import 'package:hermela_andargie/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late LogoutUseCase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LogoutUseCase(mockRepository);
  });

  test('should logout successfully', () async {
    when(mockRepository.logout()).thenAnswer((_) async => const Right(null));

    final result = await usecase.call(NoParams());

    expect(result, const Right(null));
    verify(mockRepository.logout());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return CacheFailure on error', () async {
    when(mockRepository.logout()).thenAnswer((_) async => Left(CacheFailure()));

    final result = await usecase.call(NoParams());

    expect(result, Left(CacheFailure()));
    verify(mockRepository.logout());
    verifyNoMoreInteractions(mockRepository);
  });
}
