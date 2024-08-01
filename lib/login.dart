import 'package:flutter/material.dart';

class LoginWindow extends StatefulWidget {
  const LoginWindow({super.key});

  @override
  State<LoginWindow> createState() => _LoginWindowState();
}

class _LoginWindowState extends State<LoginWindow> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.login_rounded),
      tooltip: 'Войти в аккаунт',
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('По нажатии будет вход в акк\nПока разрабу похуй')));
      },
    );
  }
}
