import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О приложении'),
        flexibleSpace: FlexibleSpaceBar(
          background: Image.asset('assets/Header.png', fit: BoxFit.cover),
        ),
      ),
      body: const Center(
        child: Text(
          'Z V ликвидация💩💩💩.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
