import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:easyapp/SQLite/sqlite.dart';
import 'package:easyapp/utils/popups/loaders.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  static LocationController get instance => Get.find();
  // Initialize the database instance here
  final LocalDatabase db = LocalDatabase.instance;

  //Variables
  final isLoading = false.obs;

  final List<Marker> myMarkers = <Marker>[];
  final RxList<Map<String, dynamic>> markerList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    // fetchLocationData();
    super.onInit();
  }

  Future<void> fetchLocationData() async {
    try {
      final List<Map<String, dynamic>> result = await db.getCurrLocation();
      markerList.assignAll(result);
    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Set<Marker> getMarkersFromDb() {
    return markerList.map((item) {
      final parts = item['location'].split(',');
      final lat = double.parse(parts[0].trim());
      final lng = double.parse(parts[1].trim());

      return Marker(
        markerId: MarkerId(item['makerId']),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: item['title'],
          snippet: item['snippet'],
        ),
        icon: BitmapDescriptor.defaultMarker,
      );
    }).toSet();
  }

  Set<Polyline> getPolylineFromDb() {
    final points = markerList.map((item) {
      final parts = item['location'].split(',');
      final lat = double.parse(parts[0].trim());
      final lng = double.parse(parts[1].trim());
      return LatLng(lat, lng);
    }).toList();

    return {
      Polyline(
        polylineId: const PolylineId('dynamic_polyline'),
        points: points,
        color: Colors.red,
        width: 4,
      )
    };
  }
 

Future<Position> getUserLocation() async {
  try {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return await Geolocator.getCurrentPosition();
    } else {
      throw Exception('Location permission denied');
    }
  } catch (error) {
    // MLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString());
    return Future.error('Error getting location: $error');
  }
}

}