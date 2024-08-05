import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        flexibleSpace: FlexibleSpaceBar(
          background: Image.asset('assets/Header.png', fit: BoxFit.cover),
        ),
      ),
      body: const Center(
        child: Text('будут настройки'),
      ),
    );
  }
}
