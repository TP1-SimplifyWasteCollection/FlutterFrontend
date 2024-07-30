import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class FullScMap extends StatefulWidget {
  const FullScMap({super.key});

  @override
  State createState() => FullScMapState();
}

class FullScMapState extends State<FullScMap> {
  MapboxMapController? mapController;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high); // or use `await _location.getLocation();` for `location` package
    if (mapController != null) {
      // Add a marker with the default location icon
      await mapController!.addImage(
        'custom_marker', // Unique name for the icon
        await _loadIcon(), // Load the icon from assets
      );
      mapController!.addSymbol(
        SymbolOptions(
          geometry: LatLng(position.latitude, position.longitude),
          iconImage: 'custom_marker', // Mapbox's default location icon
          iconSize: 0.1,
        ),
      );

      // Optionally, move the camera to the user's location
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14.0, // Zoom level
        ),
      );
    }
  }
  Future<Uint8List> _loadIcon() async {
    // Load the custom icon from assets
    final ByteData data = await rootBundle.load('assets/icons/location.png');
    return data.buffer.asUint8List();
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    _getUserLocation();
    return Scaffold(
      body: MapboxMap(
        accessToken: 'pk.eyJ1IjoicHJvamVjdGZmb2tpbGRhbSIsImEiOiJjbHVnc2dueGQxMGZqMmpyb3M4M3Zta3diIn0.Wt5JARj1tQmWb4rInzhKBg',
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 10,
        ),
        styleString: 'mapbox://styles/projectffokildam/clz8b3xp4001h01qr406t8mkq',
      ),
    );
  }
}
