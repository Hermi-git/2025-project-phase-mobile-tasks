import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/failures.dart';
import 'package:hermela_andargie/features/chat/domain/entities/chat.dart';
import 'package:hermela_andargie/features/chat/domain/entities/chat_user.dart';
import 'package:hermela_andargie/features/chat/domain/entities/message.dart';
import 'package:hermela_andargie/features/chat/domain/repositories/chat_repository.dart';
import 'package:hermela_andargie/features/chat/domain/usecases/send_message.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'send_message_usecase_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late SendMessageUseCase useCase;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    useCase = SendMessageUseCase(mockRepository);
  });

  const tChatId = 'chat_1';
  const tContent = 'Test message';
  const tType = 'text';

  final tSender = const ChatUser(
    id: 'u1',
    name: 'Sender',
    email: 'sender@example.com',
  );

  final tChat = Chat(
    id: tChatId,
    user1: tSender,
    user2: const ChatUser(
      id: 'u2',
      name: 'Receiver',
      email: 'receiver@example.com',
    ),
  );


  final tMessage = Message(
    id: 'm1',
    sender: tSender,
    chat: tChat,
    content: tContent,
    type: tType,
    chatId: tChatId,
  );

  test('should send message through repository', () async {
    when(
      mockRepository.sendMessage(
        chatId: tChatId,
        content: tContent,
        type: tType,
      ),
    ).thenAnswer((_) async => Right(tMessage));

    final result = await useCase(
      SendMessageParams(chatId: tChatId, content: tContent, type: tType),
    );

    expect(result, Right(tMessage));
    verify(
      mockRepository.sendMessage(
        chatId: tChatId,
        content: tContent,
        type: tType,
      ),
    );
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository fails', () async {
    when(
      mockRepository.sendMessage(
        chatId: tChatId,
        content: tContent,
        type: tType,
      ),
    ).thenAnswer((_) async => Left(ServerFailure()));

    final result = await useCase(
      SendMessageParams(chatId: tChatId, content: tContent, type: tType),
    );

    expect(result, Left(ServerFailure()));
    verify(
      mockRepository.sendMessage(
        chatId: tChatId,
        content: tContent,
        type: tType,
      ),
    );
    verifyNoMoreInteractions(mockRepository);
  });
}
