import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chatDetail/chat_detail_bloc.dart';
import '../bloc/chatList/chat_list_bloc.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<ChatListBloc, ChatListState>(
        builder: (context, state) {
          if (state is ChatListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatListLoaded) {
            if (state.chats.isEmpty) {
              return const Center(child: Text('No chats yet.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(8),
              separatorBuilder: (_, __) => const Divider(),
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                final chat = state.chats[index];

                // You must decide who is "me" here — for now just using user1
                final otherUser = chat.user2;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Text(otherUser.name[0].toUpperCase()),
                  ),
                  title: Text(
                    otherUser.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    '', // lastMessage not available in your Chat entity
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: null, // unreadCount not in your Chat entity
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => BlocProvider(
                              create:
                                  (ctx) => ChatDetailBloc(
                                    chatRepository:
                                        context
                                            .read<ChatListBloc>()
                                            .chatRepository,
                                    chatId: chat.id,
                                    currentUser:
                                        chat.user1, // you can change logic here
                                    currentChat: chat,
                                  )..add(LoadMessagesEvent()),
                              child: ChatDetailScreen(chat: chat),
                            ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is ChatListError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
