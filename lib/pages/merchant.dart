import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:puffren_app/models/markers_manager.dart';

class MerchantMapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MerchantMapPageState();
  }
}

class MerchantMapPageState extends State<MerchantMapPage> {
  List<Marker> markers = [];
  GoogleMapController mapController;
  Location _location = Location();
  LatLng currentPosition;
  bool firstInitPosition = false;
  final LatLng _center = const LatLng(25.039543, 121.576631);

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
    markers = MarkerManager().getMarkers();
    setState(() {});
  }

  void _handelOnTap(LatLng latLng){
    MarkerId id = MarkerId(Random().nextInt(1000000000).toString());
    Marker marker = Marker(markerId: id,
    position: latLng,
    infoWindow: InfoWindow(title: "title", snippet: "content"),
    onTap: (){
      markers.forEach((element) {
        if(element.markerId == id){
          MarkerManager().removeMarker(element);
          markers.remove(element);
          setState(() {

          });
        }
      });
    });
    MarkerManager().saveMarker(marker);
    markers.add(marker);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("商家記錄位置"),
      ),
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          GoogleMap(
            markers: Set.from(markers),
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: _handelOnTap,
          ),
          // Container(height: 100, width: double.infinity, color: Color.fromRGBO(102, 102, 102, 0.4))
        ],
      ),
    );
  }
}
