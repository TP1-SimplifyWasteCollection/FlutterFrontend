import 'package:flutter/material.dart';
//import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Map",
      home: Scaffold(
        body: MapScreen()
      )
    );
  }
}