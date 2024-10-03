import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter/material.dart';
class MapboxMapProvider extends ChangeNotifier {
  MapboxMap? mapboxMap;

  void setMapboxMap(MapboxMap map) {
    mapboxMap = map;
    notifyListeners();
  }

  void easeCamera(LatLng position) {
    mapboxMap?.easeTo(
      CameraOptions(
        center: Point(
          coordinates: Position(
              position.longitude, position.latitude),
        ),
        zoom: 14,
        bearing: 0,
        pitch: 5,
      ),
      MapAnimationOptions(duration: 500, startDelay: 0),
    );
  }
}