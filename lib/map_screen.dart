import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geotypes/geotypes.dart' as geo;

class FullMap extends StatefulWidget {
  const FullMap({super.key});

  @override
  State<FullMap> createState() => _FullMapState();
}

class _FullMapState extends State<FullMap> {
  MapboxMap? mapboxMap;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    _enableLocationComponent();
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
    try {
      geolocator.Position position = await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high,
      );

      mapboxMap?.flyTo(
        CameraOptions(
          center: Point(
            coordinates: geo.Position(
              position.longitude,
              position.latitude,
            ),
          ),
          zoom: 14,
          bearing: 0,
          pitch: 5,
        ),
        MapAnimationOptions(duration: 1300, startDelay: 0),
      );
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Доступ к местоположению запрещен'),
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
      body: MapWidget(
        key: ValueKey("mapWidget"),
        onMapCreated: _onMapCreated,
        cameraOptions: CameraOptions(anchor: ScreenCoordinate(x: 0, y: 0)),
        styleUri: 'mapbox://styles/projectffokildam/clz8b3xp4001h01qr406t8mkq',
      ),
      floatingActionButton: FloatingActionButton(
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