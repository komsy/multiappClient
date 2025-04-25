import 'dart:async';
import 'package:easyapp/common/widgets/appbar/appbar.dart';
import 'package:easyapp/data/repositories/authentication/authentication_repository.dart';
import 'package:easyapp/features/personalization/controllers/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MLocation extends StatefulWidget {
  const MLocation({super.key});

  @override
  State<MLocation> createState() => _MLocationState();
}

class _MLocationState extends State<MLocation> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final locationController = LocationController.instance;
  final authRepo = AuthenticationRepository.instance;

  LatLng get currentLatLng {
    final locationString = authRepo.currLocation.value.isNotEmpty
      ? authRepo.currLocation.value
      : authRepo.defaultLocation.value;

    final parts = locationString.split(',');
    return LatLng(
      double.parse(parts[0].trim()),
      double.parse(parts[1].trim()),
    );
  }

  // Default camera position
  CameraPosition get mHome => CameraPosition(
    bearing: 19,
    target: currentLatLng,
    zoom: 14,
  );

  final Set<Marker> myMarkers = {};
  final Set<Polyline> myPolyline = {};

  @override
  void initState() {
    super.initState();

    // Add default marker based on current location
    myMarkers.add(
      Marker(
        markerId: const MarkerId('MK'),
        position: currentLatLng,
        infoWindow: const InfoWindow(title: 'Default Location'),
      ),
    );

    loadDynamicMapData();
  }

  Future<void> loadDynamicMapData() async {
    await locationController.fetchLocationData();
    setState(() {
      myMarkers.addAll(locationController.getMarkersFromDb());
      myPolyline.addAll(locationController.getPolylineFromDb());
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: const MAppBar(title: Text('My Order Location Data'), showBackArrow: true,centerTitle: true),
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: mHome,
          markers: myMarkers,
          polylines: myPolyline,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
