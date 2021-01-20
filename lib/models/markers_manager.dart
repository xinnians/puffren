import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerManager {
  static final MarkerManager _instance = MarkerManager._internal();

  MarkerManager._internal();

  factory MarkerManager() {
    return _instance;
  }

  List<Marker> _list = [];

  saveMarker(Marker marker) {
    _list.add(marker);
  }

  removeMarker(Marker marker){
    _list.remove(marker);
  }

  getMarkers() => _list;
}
