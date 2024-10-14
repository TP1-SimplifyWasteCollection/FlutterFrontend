import 'package:flutter/material.dart';
import 'pages/main_page.dart';
import 'package:provider/provider.dart';
import 'mapbox_map_provider.dart';


void main() async {

  runApp(
    ChangeNotifierProvider(
      create: (_) => MapboxMapProvider(),
      child: RecycleMeApp(),
    ),
  );
}

class RecycleMeApp extends StatelessWidget {
  const RecycleMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecycleMeMain(),
    );
  }
}
