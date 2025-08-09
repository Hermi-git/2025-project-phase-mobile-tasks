import 'package:flutter/material.dart';

class AuthLogo extends StatelessWidget {
  final double size;

  const AuthLogo({Key? key, this.size = 120}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/auth/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
