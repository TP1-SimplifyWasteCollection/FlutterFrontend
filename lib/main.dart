import 'package:flutter/material.dart';
import 'package:testmap/pages/about.dart';
import 'package:testmap/pages/settings.dart';
import 'theme.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'pages/main_page.dart';

void main() {
  runApp(const RecycleMeApp());
}

class RecycleMeApp extends StatelessWidget {
  const RecycleMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: mainAppTheme,
            home: RecycleMeMain(),
            routes: {
              '/aboutpage': (context) => AboutPage(),
              '/settingspage' :(context) => SettingsPage(),
            },
            );
      },
    );
  }
}
