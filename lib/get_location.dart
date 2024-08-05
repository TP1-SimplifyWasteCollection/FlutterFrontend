import 'dart:io';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

//Расширение с https://stackoverflow.com/questions/75306854/how-to-get-users-location-in-flutters-official-mapbox-package
//Пиздит локацию через апи мапбокса основываясь на отображаемом положении шайбы
extension PuckPosition on StyleManager {
  Future<Position> getPuckPosition() async {
    Layer? layer;
    if (Platform.isAndroid) {
      layer = await getLayer("mapbox-location-indicator-layer");
    } else {
      layer = await getLayer("puck");
    }
    final location = (layer as LocationIndicatorLayer).location;
    return Future.value(Position(location![1]!, location[0]!));
  }
}
