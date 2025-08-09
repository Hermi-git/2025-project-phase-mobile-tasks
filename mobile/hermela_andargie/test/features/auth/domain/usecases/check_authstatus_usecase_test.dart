import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/failures.dart';
import 'package:hermela_andargie/core/usecases/usecase.dart';
import 'package:hermela_andargie/features/auth/domain/repositories/auth_repository.dart';
import 'package:hermela_andargie/features/auth/domain/usecases/check_authstatus_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';



import 'check_authstatus_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late CheckAuthStatusUseCase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = CheckAuthStatusUseCase(mockRepository);
  });

  test('should return true when token exists', () async {
    when(mockRepository.hasToken()).thenAnswer((_) async => true);

    final result = await usecase(NoParams());

    expect(result, const Right(true));
    verify(mockRepository.hasToken());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return false when no token exists', () async {
    when(mockRepository.hasToken()).thenAnswer((_) async => false);

    final result = await usecase(NoParams());

    expect(result, const Right(false));
  });

  test('should return CacheFailure when an exception occurs', () async {
    when(mockRepository.hasToken()).thenThrow(Exception());

    final result = await usecase(NoParams());

    expect(result, Left(CacheFailure()));
  });
}
