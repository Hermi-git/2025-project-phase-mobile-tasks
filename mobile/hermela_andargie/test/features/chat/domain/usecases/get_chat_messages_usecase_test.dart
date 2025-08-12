import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/failures.dart';
import 'package:hermela_andargie/features/chat/domain/entities/chat.dart';
import 'package:hermela_andargie/features/chat/domain/entities/chat_user.dart';
import 'package:hermela_andargie/features/chat/domain/entities/message.dart';
import 'package:hermela_andargie/features/chat/domain/repositories/chat_repository.dart';
import 'package:hermela_andargie/features/chat/domain/usecases/get_chat_messages.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_chat_messages_usecase_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late GetChatMessagesUseCase useCase;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    useCase = GetChatMessagesUseCase(mockRepository);
  });

  const tChatId = 'chat_1';
  final tSender = const ChatUser(
    id: 'u1',
    name: 'Sender',
    email: 'sender@example.com',
  );
  final tReceiver = const ChatUser(
    id: 'u2',
    name: 'Receiver',
    email: 'receiver@example.com',
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

  final tMessages = [
  Message(
    id: 'm1',
    sender: tSender,
    chat: tChat,
    content: 'Hello',
    type: 'text',
  ),
   Message(
    id: 'm2',
    sender: tReceiver,
    chat: tChat,
    content: 'Hi there',
    type: 'text',
  ),
  ];

  test('should get chat messages from repository', () async {
    when(
      mockRepository.getChatMessages(tChatId),
    ).thenAnswer((_) async => Right(tMessages));

    final result = await useCase(GetChatMessagesParams(tChatId));

    expect(result, Right(tMessages));
    verify(mockRepository.getChatMessages(tChatId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository fails', () async {
    when(
      mockRepository.getChatMessages(tChatId),
    ).thenAnswer((_) async => Left(ServerFailure()));

    final result = await useCase(GetChatMessagesParams(tChatId));

    expect(result, Left(ServerFailure()));
    verify(mockRepository.getChatMessages(tChatId));
    verifyNoMoreInteractions(mockRepository);
  });
}
