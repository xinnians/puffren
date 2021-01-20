import 'dart:developer';
import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:puffren_app/models/markers_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  Location _location = Location();
  bool firstInitPosition = false;

  static Set<Polyline> polyline = {};
  static PolylinePoints polylinePoints = PolylinePoints();
  static String googleAPiKey = "AIzaSyC_ghQ3-fNNGhwiMmc4ANYdfdnWne3_XJk";
  static List<LatLng> polylineCoordinates = [];
  static LatLng currentPosition;

  final LatLng _center = const LatLng(25.039543, 121.576631);
  List<Marker> markers = [];

  _getPolyline(
      Set<Polyline> polyline,
      PolylinePoints polylinePoints,
      String googleAPiKey,
      List<LatLng> polylineCoordinates,
      LatLng ori,
      LatLng des) async {
    log("[getPolyline] call.");
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(ori.latitude, ori.longitude),
      PointLatLng(des.latitude, des.longitude),
      // travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      polyline.clear();
      log("[getPolyline] result.points.isNotEmpty.");
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      PolylineId id = PolylineId("poly");
      Polyline polylined = Polyline(
          polylineId: id, color: Colors.red, points: polylineCoordinates);
      polyline.add(polylined);
      setState(() {});
    } else {
      log("[getPolyline] result.points.isEmpty.");
      log("[getPolyline] result: ${result.status}:${result.errorMessage},${result.points.length}");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _location.onLocationChanged.listen((l) {
      currentPosition = LatLng(l.latitude, l.longitude);
      if (!firstInitPosition) {
        firstInitPosition = true;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
          ),
        );
      }
    });
    List<Marker> list = MarkerManager().getMarkers();
    list.forEach((element) {
      markers.add(Marker(
          markerId: element.markerId,
          position: element.position,
          infoWindow: element.infoWindow,
          onTap: () {
            _getPolyline(
                polyline,
                polylinePoints,
                googleAPiKey,
                polylineCoordinates,
                currentPosition,
                element.position);
          }));
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("餐車位置"),
      ),
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          GoogleMap(
            markers: Set.from(markers),
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            polylines: Set.from(polyline),
          ),
          // Container(height: 100, width: double.infinity, color: Color.fromRGBO(102, 102, 102, 0.4))
        ],
      ),
    );
  }
}

startNavigation(String ori, String des) async {
  String origin = ori; // lat,long like 123.34,68.56
  String destination = des;
  if (Platform.isAndroid) {
    final AndroidIntent intent = new AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull("https://www.google.com/maps/dir/?api=1&origin=" +
            origin +
            "&destination=" +
            destination +
            "&travelmode=driving&dir_action=navigate"),
        package: 'com.google.android.apps.maps');
    intent.launch();
  } else {
    String url = "https://www.google.com/maps/dir/?api=1&origin=" +
        origin +
        "&destination=" +
        destination +
        "&travelmode=driving&dir_action=navigate";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
