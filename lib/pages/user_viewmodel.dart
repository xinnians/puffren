import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserViewModel extends ChangeNotifier {

  Set<Polyline> polyline = {};
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyC_ghQ3-fNNGhwiMmc4ANYdfdnWne3_XJk";
  List<LatLng> polylineCoordinates = [];
  LatLng currentPosition = const LatLng(25.0456594,121.572147);
  List<Marker> markers = [
    Marker(
        markerId: MarkerId("1"),
        position: LatLng(25.0456594, 121.572147),
        infoWindow: InfoWindow(title: "title", snippet: "snippet"),
        onTap: () {
          // startNavigation(
          // LatLng(25.039543, 121.576631).latitude.toString() +
          //     "," +
          //     LatLng(25.039543, 121.576631).longitude.toString(),
          // LatLng(25.040690, 121.575427).latitude.toString() +
          //     "," +
          //     LatLng(25.040690, 121.575427).longitude.toString());

        })
  ];
  GoogleMapController mapController;

  UserViewModel(){
    _getUserLocation();
  }

  void _getUserLocation() async {
    log("[_getUserLocation] call.");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = LatLng(position.latitude, position.longitude);
    notifyListeners();
  }

}