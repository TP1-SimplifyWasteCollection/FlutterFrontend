import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:shared_preferences/shared_preferences.dart';

class FullMap extends StatefulWidget {
  const FullMap({super.key});

  @override
  State<FullMap> createState() => _FullMapState();
}

class _FullMapState extends State<FullMap> {
  MapboxMap? mapboxMap;
  CameraOptions? initialCameraOptions;
  bool isLocationLoaded = false;
  bool isCameraOnUserLocation = false;
  geolocator.Position? currentUserLocation;
  Timer? cameraCheckTimer;

  @override
  void initState() {
    super.initState();
    _loadPreviousLocation();
  }

  @override
  void dispose() {
    cameraCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadPreviousLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final double? longitude = prefs.getDouble('longitude');
    final double? latitude = prefs.getDouble('latitude');

    if (longitude != null && latitude != null) {
      setState(() {
        initialCameraOptions = CameraOptions(
          center: Point(coordinates: Position(longitude, latitude)),
          zoom: 14,
          bearing: 0,
          pitch: 5,
        );
      });
    }
    setState(() {
      isLocationLoaded = true;
    });
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    _getLocation();
  }

  Future<void> _onCameraChangeListener(
      CameraChangedEventData cameraChangedEventData) async {
    if (isCameraOnUserLocation == true) {
      setState(() {
        isCameraOnUserLocation = false;
        print('Dzher Dzher');
      });
    }
  }

  Future<void> _getLocation() async {
    var status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      _enableLocationComponent();
    } else {
      _showPermissionDeniedDialog();
    }
  }

  Future<void> _enableLocationComponent() async {
    if (mapboxMap != null) {
      await mapboxMap!.location.updateSettings(LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        showAccuracyRing: true,
      ));
      _moveCameraToPosition();
    }
  }

  Future<void> _moveCameraToPosition() async {
    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition(
      desiredAccuracy: geolocator.LocationAccuracy.high,
    );
    currentUserLocation = position;

    mapboxMap?.easeTo(
      CameraOptions(
        center: Point(
          coordinates: Position(
            position.longitude,
            position.latitude,
          ),
        ),
        zoom: 14,
        bearing: 0,
        pitch: 5,
      ),
      MapAnimationOptions(duration: 500, startDelay: 0),
    );

    Timer(Duration(milliseconds: 550), () {
      setState(() {
        isCameraOnUserLocation = true;
      });
    });

    _saveLocation(position.longitude, position.latitude);
    // Start periodic check
  }

  Future<void> _saveLocation(double longitude, double latitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('longitude', longitude);
    await prefs.setDouble('latitude', latitude);
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Доступ к местоположению запрещен'),
          backgroundColor: Color(0xFF1D2024),
          content: Text(
            'Для корректной работы приложению требуется доступ к Вашему местоположению.\nПожалуйста откройте приложение настройки и дайте доступ.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Перейти в настройки'),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Не давать доступ'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MapboxOptions.setAccessToken(
      'pk.eyJ1IjoicHJvamVjdGZmb2tpbGRhbSIsImEiOiJjbHVnc2dueGQxMGZqMmpyb3M4M3Zta3diIn0.Wt5JARj1tQmWb4rInzhKBg',
    );

    return Scaffold(
      body: isLocationLoaded
          ? MapWidget(
              key: ValueKey("mapWidget"),
              onMapCreated: _onMapCreated,
              onCameraChangeListener: _onCameraChangeListener,
              cameraOptions: initialCameraOptions ??
                  CameraOptions(anchor: ScreenCoordinate(x: 0, y: 0)),
              styleUri:
                  'mapbox://styles/projectffokildam/cm1aw1wcn02h801pmeiqf9wbd',
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: isCameraOnUserLocation
          ? null
          : FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                _getLocation();
              },
              tooltip: 'Add Something',
              child: const Icon(Icons.location_on),
            ),
    );
  }
}
