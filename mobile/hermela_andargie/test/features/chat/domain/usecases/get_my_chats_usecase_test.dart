import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermela_andargie/core/errors/failures.dart';
import 'package:hermela_andargie/core/usecases/usecase.dart';
import 'package:hermela_andargie/features/chat/domain/entities/chat.dart';
import 'package:hermela_andargie/features/chat/domain/entities/chat_user.dart';
import 'package:hermela_andargie/features/chat/domain/repositories/chat_repository.dart';
import 'package:hermela_andargie/features/chat/domain/usecases/get_my_chats.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_my_chats_usecase_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late GetMyChatsUseCase useCase;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    useCase = GetMyChatsUseCase(mockRepository);
  });

  final tUser1 = const ChatUser(
    id: 'u1',
    name: 'User One',
    email: 'user1@example.com',
  );
  final tUser2 = const ChatUser(
    id: 'u2',
    name: 'User Two',
    email: 'user2@example.com',
  );

  final tChats = [
    Chat(id: 'chat_1', user1: tUser1, user2: tUser2),
    Chat(id: 'chat_2', user1: tUser2, user2: tUser1),
  ];

  test('should get my chats from repository', () async {
    when(mockRepository.getMyChats()).thenAnswer((_) async => Right(tChats));

    final result = await useCase(NoParams());

    expect(result, Right(tChats));
    verify(mockRepository.getMyChats());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository fails', () async {
    when(
      mockRepository.getMyChats(),
    ).thenAnswer((_) async => Left(ServerFailure()));

    final result = await useCase(NoParams());

    expect(result, Left(ServerFailure()));
    verify(mockRepository.getMyChats());
    verifyNoMoreInteractions(mockRepository);
  });
}
