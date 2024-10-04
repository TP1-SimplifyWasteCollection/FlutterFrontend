import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'pages/map_screen.dart';
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

  Future<LatLng?> getCurrentCameraPosition() async {
    CameraState? cameraState = await mapboxMap?.getCameraState();
    if (cameraState != null && cameraState.center != null) {
      // Extract the current camera position (longitude and latitude)
      Position position = cameraState.center!.coordinates;
      return LatLng(position.lat.toDouble(), position.lng.toDouble());
    }
    return null; // Return null if the camera state is unavailable
  }

}