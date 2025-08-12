import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/failures.dart';
import 'package:hermela_andargie/features/chat/domain/repositories/chat_repository.dart';
import 'package:hermela_andargie/features/chat/domain/usecases/delete_chat.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_chat_usecase_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late DeleteChatUseCase useCase;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    useCase = DeleteChatUseCase(mockRepository);
  });

  final tChatId = 'abc';

  test('should delete chat for given chatId from repository', () async {
    // arrange
    when(
      mockRepository.deleteChat(tChatId),
    ).thenAnswer((_) async => const Right(null));

    // act
    final result = await useCase(DeleteChatParams(tChatId));

    // assert
    expect(result, const Right(null));
    verify(mockRepository.deleteChat(tChatId));
    verifyNoMoreInteractions(mockRepository);
  });
}
