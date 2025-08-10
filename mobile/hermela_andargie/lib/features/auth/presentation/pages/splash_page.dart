import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_logo.dart'; 


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {

          if (state is AuthAuthenticated) {
            Navigator.of(
              context,
            ).pushReplacementNamed('/home', arguments: state.user);
          } else if (state is AuthUnauthenticated) {
            Navigator.of(context).pushReplacementNamed('/signin');
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/auth_bg.jpg', fit: BoxFit.cover),
            Container(
              color: Colors.deepPurple.withAlpha(
                (0.6 * 255).toInt(),
              ), // no withOpacity
            ),
            const Center(
              child: AuthLogo(), 
            ),
          ],
        ),
      ),
    );
  }
}
