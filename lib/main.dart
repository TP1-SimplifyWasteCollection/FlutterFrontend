import 'package:flutter/material.dart';
import 'package:testmap/login.dart';
import 'map_screen.dart';
import 'about.dart';
import 'theme.dart';
import 'package:dynamic_color/dynamic_color.dart';

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
            home: RecycleMeMain());
      },
    );
  }
}

class RecycleMeMain extends StatefulWidget {
  const RecycleMeMain({super.key});

  @override
  State<RecycleMeMain> createState() => _RecycleMeMainState();
}

class _RecycleMeMainState extends State<RecycleMeMain> {
  final ValueNotifier<String> _currentScreenNotifier = ValueNotifier('RecycleMeMain');

  @override
  void dispose() {
    _currentScreenNotifier.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecycleME'),
        flexibleSpace: FlexibleSpaceBar(
          background: Image.asset('assets/Header.png', fit: BoxFit.cover),
        ),
        actions: const <Widget>[
          LoginWindow(),
          AboutWindow() 
        ],
      ),
      body: Center(child: FullMap()),
    );
  }
}