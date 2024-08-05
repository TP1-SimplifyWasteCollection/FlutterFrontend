import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text('Вход в аккаунт'),
        flexibleSpace: FlexibleSpaceBar(
          background: Image.asset('assets/Header.png', fit: BoxFit.cover),
        ),
      ),
      body: Center(child: Text('будет логин'),),
    );
  }
}
