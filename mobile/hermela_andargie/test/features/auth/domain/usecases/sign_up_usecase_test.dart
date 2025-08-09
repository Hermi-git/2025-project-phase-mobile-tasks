import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/features/auth/domain/entities/user.dart';
import 'package:hermela_andargie/features/auth/domain/repositories/auth_repository.dart';
import 'package:hermela_andargie/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_up_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignUpUseCase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = SignUpUseCase(mockRepository);
  });

  final tName = 'Test User';
  final tEmail = 'test@example.com';
  final tPassword = 'password123';

  final tUser = User(id: '1', name: tName, email: tEmail);

  final tParams = SignUpParams(name: tName, email: tEmail, password: tPassword);

  test(
    'should get User from repository when registration is successful',
    () async {
      when(
        mockRepository.register(
          name: tName,
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => Right(tUser));

      final result = await usecase.call(tParams);

      expect(result, Right(tUser));
      verify(
        mockRepository.register(
          name: tName,
          email: tEmail,
          password: tPassword,
        ),
      );
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
