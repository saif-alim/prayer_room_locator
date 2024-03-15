import 'package:flutter/material.dart';
import 'package:flutter_icon_shadow/flutter_icon_shadow.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prayer_room_locator/core/common/custom_widgets.dart';
import 'package:prayer_room_locator/core/common/loader.dart';
import 'package:prayer_room_locator/repository/controller/locations_controller.dart';

class MapPage extends ConsumerWidget {
  MapPage({super.key});

  late final MapController mapController = MapController();

  //functions and methods
  //

  // get users current location after
  // checking for permissions
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
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
  Future<void> _moveToPosition(Position position) async {
    mapController.move(
      LatLng(position.latitude, position.longitude),
      17.0,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      //
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          FlutterMap(
            mapController: mapController,
            options: const MapOptions(
              initialCenter: LatLng(51.5234284822, -0.039269956473),
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                subdomains: const ['a', 'b', 'c'],
              ),
              // Marker Layer code
              //
              FutureBuilder(
                future: ref.watch(markerProvider),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final markers = snapshot.data!;
                  return MarkerLayer(
                    alignment: Alignment.topCenter,
                    markers: markers,
                  );
                },
              ),
            ],
          ),
          // Location Button
          //
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
                alignment: Alignment.bottomLeft,
                width: 100,
                height: 100,
                child: Stack(children: [
                  const Center(
                      child: IconShadow(
                    Icon(
                      Icons.circle,
                      size: 80,
                      color: Colors.white,
                    ),
                    shadowColor: Colors.black,
                    shadowBlurSigma: 0.2,
                  )),
                  IconButton(
                    onPressed: () async {
                      // Moves the map to user's location
                      Position position = await _determinePosition();
                      await _moveToPosition(position);
                    },
                    icon: const Center(
                      child: Icon(
                        Icons.my_location,
                        size: 30,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                ])),
          ),
        ],
      ),
    );
  }
}
