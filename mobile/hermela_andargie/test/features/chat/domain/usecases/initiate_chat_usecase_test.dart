import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/failures.dart';
import 'package:hermela_andargie/features/chat/domain/entities/chat.dart';
import 'package:hermela_andargie/features/chat/domain/entities/chat_user.dart';
import 'package:hermela_andargie/features/chat/domain/repositories/chat_repository.dart';
import 'package:hermela_andargie/features/chat/domain/usecases/initiate_chat.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'initiate_chat_usecase_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late InitiateChatUseCase useCase;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    useCase = InitiateChatUseCase(mockRepository);
  });

  final tUserId = '123';
  final tChat = const Chat(
    id: 'abc',
    user1: ChatUser(
      id: 'u1',
      name: 'Sender',
      email: 'sender@example.com',
    ),
    user2: ChatUser(
      id: 'u2',
      name: 'Receiver',
      email: 'receiver@example.com',
    ),
  );

  test('should initiate chat for given userId from repository', () async {
    // arrange
    when(mockRepository.initiateChat(tUserId))
        .thenAnswer((_) async => Right(tChat));

    // act
    final result = await useCase(InitiateChatParams(tUserId));

    // assert
    expect(result, Right(tChat));
    verify(mockRepository.initiateChat(tUserId));
    verifyNoMoreInteractions(mockRepository);
  });
}
