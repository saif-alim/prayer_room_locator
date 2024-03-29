import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prayer_room_locator/core/common/custom_widgets.dart';
import 'package:prayer_room_locator/core/common/loader.dart';
import 'package:prayer_room_locator/locations/locations_controller.dart';

class GMapPage extends ConsumerWidget {
  const GMapPage({super.key});

  // functions and methods

  // get users current location after
  // checking for permissions
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Permission handling
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    return position;
  }

  // move to a specified location
  Future<void> _moveToPosition(
      Position position, GoogleMapController controller) async {
    controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude), 14));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsController = ref.watch(locationsControllerProvider.notifier);

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: FutureBuilder<List<Marker>>(
        future: locationsController.buildMarkers(context),
        builder: (context, snapshot) {
          Set<Marker> markers = Set.from(snapshot.data ?? []);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(51.5234, -0.0393),
              zoom: 13,
            ),
            onMapCreated: (controller) async {
              Position position = await _determinePosition();
              await _moveToPosition(position, controller);
            },
            markers: markers,
          );
        },
      ),
    );
  }
}
