import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/domain/entities/user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/auth/presentation/pages/sign_up_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/chat/domain/entities/chat.dart';
import 'features/chat/domain/entities/chat_user.dart';
import 'features/chat/presentation/bloc/chatDetail/chat_detail_bloc.dart';
import 'features/chat/presentation/bloc/chatList/chat_list_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => di.sl<AuthBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce App',
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: const SplashPage(),
        routes: {
          '/signin': (context) => const SignInPage(),
          '/signup': (context) => const SignUpPage(),

          // Home Page with ChatListBloc injection
          '/home': (context) {
            final user = ModalRoute.of(context)!.settings.arguments as User;
            return BlocProvider(
              create:
                  (_) =>
                      di.sl<ChatListBloc>()
                        ..add(LoadChatsEvent()),
              child: HomePage(user: user),
            );
          },

          // Chat Detail Page with dynamic bloc injection
          '/chatDetail': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>;
            final currentUser = args['currentUser'] as ChatUser;
            final chat = args['chat'] as Chat;

            return BlocProvider(
              create:
                  (_) => ChatDetailBloc(
                    chatRepository: di.sl(),
                    chatId: chat.id,
                    currentUser: currentUser,
                    currentChat: chat,
                  )..add(LoadMessagesEvent()),
              child: args['page'], // The page widget passed in arguments
            );
          },
        },
      ),
    );
  }
}
