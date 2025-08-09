import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/failures.dart';
import 'package:hermela_andargie/core/usecases/usecase.dart';
import 'package:hermela_andargie/features/auth/domain/entities/user.dart';
import 'package:hermela_andargie/features/auth/domain/repositories/auth_repository.dart';
import 'package:hermela_andargie/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_current_user_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late GetCurrentUserUseCase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = GetCurrentUserUseCase(mockRepository);
  });

  final tUser = User(id: '1', name: 'John Doe', email: 'john@example.com');

  test('should return current user when available', () async {
    when(mockRepository.getCurrentUser()).thenAnswer((_) async => Right(tUser));

    final result = await usecase(NoParams());

    expect(result, Right(tUser));
    verify(mockRepository.getCurrentUser());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when no current user found', () async {
    when(
      mockRepository.getCurrentUser(),
    ).thenAnswer((_) async => Left(NotFoundFailure('No user')));

    final result = await usecase(NoParams());

    expect(result, Left(NotFoundFailure('No user')));
  });
}
