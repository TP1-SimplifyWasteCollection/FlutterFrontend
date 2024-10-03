import 'package:flutter/material.dart';
import 'package:testmap/pages/about.dart';
import 'package:testmap/pages/settings.dart';
import 'pages/main_page.dart';

void main() async {

  runApp(const RecycleMeApp());
}

class RecycleMeApp extends StatelessWidget {
  const RecycleMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecycleMeMain(),
      routes: {
        '/aboutpage': (context) => AboutPage(),
        '/settingspage': (context) => SettingsPage(),
      },
    );
  }
}
