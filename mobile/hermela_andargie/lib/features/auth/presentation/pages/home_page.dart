import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../chat/domain/entities/chat_user.dart';
import '../../../chat/presentation/bloc/chatList/chat_list_bloc.dart';
import '../../../chat/presentation/pages/chat_detail_screen.dart';
import '../../domain/entities/user.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

extension UserMapper on User {
  ChatUser toChatUser() {
    return ChatUser(id: id, name: name, email: email);
  }
}

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLoggedOut());
            },
          ),
        ],
      ),
      body: BlocBuilder<ChatListBloc, ChatListState>(
        builder: (context, state) {
          if (state is ChatListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatListLoaded) {
            final chats = state.chats;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final otherUser =
                    chat.user1.id == user.id ? chat.user2 : chat.user1;
                return ListTile(
                  title: Text(otherUser.name),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/chatDetail',
                      arguments: {
                        'currentUser': user.toChatUser(),
                        'chat': chat,
                        'page': ChatDetailScreen(
                          chat: chat,
                          currentUserId: user.id,
                        ),
                      },
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
