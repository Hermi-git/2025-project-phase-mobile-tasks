import 'package:flutter/material.dart';
import '../../domain/entities/user.dart'; 

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
              // Later we can wire this up to AuthBloc -> AuthLoggedOut
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome ${user.name}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
