import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/data/locations/locations_controller.dart';
import 'package:prayer_room_locator/utils/common/loader.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends ConsumerState<MapPage> {
  final Completer<GoogleMapController> mapController = Completer();
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initMapAndMarkers();
  }

  @override
  void dispose() {
    super.dispose();
    mapController.future.then((controller) {
      controller.dispose();
    });
  }

  // Functions and Methods

// initialises map and markers
  Future<void> _initMapAndMarkers() async {
    Position position = await _getUserLocation(ref);
    await _moveToPosition(position);
    await _getMarkers();
  }

  // Assign list of markers to _markers variable
  Future<void> _getMarkers() async {
    final locationsController = ref.read(locationsControllerProvider.notifier);
    List<Marker> markers = await locationsController.buildMarkers(context);
    setState(() {
      _markers = Set.from(markers);
    });
  }

  // get user current location
  Future<Position> _getUserLocation(WidgetRef ref) async {
    return ref.read(locationsControllerProvider.notifier).getUserLocation();
  }

  // Move to a specified location
  Future<void> _moveToPosition(Position position) async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude), 14));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Consumer(
        builder: (context, ref, child) {
          // Listen to userLocationStreamProvider for location updates
          final positionAsyncValue = ref.watch(userLocationStreamProvider);

          // update user's location marker
          return positionAsyncValue.when(
            data: (position) {
              // update _markers
              final userLocationMarker = Marker(
                markerId: const MarkerId('userPosition'),
                position: LatLng(position.latitude, position.longitude),
                infoWindow: const InfoWindow(title: 'Your Location'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
              );

              // Set with updated markers
              final updatedMarkers = {..._markers, userLocationMarker};

              return GoogleMap(
                zoomControlsEnabled: false,
                compassEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(51.5080, -0.1281),
                  zoom: 10,
                ),
                onMapCreated: (controller) {
                  if (!mapController.isCompleted) {
                    mapController.complete(controller);
                  }
                },
                markers: updatedMarkers,
              );
            },
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Loader(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Position position = await _getUserLocation(ref);
          await _moveToPosition(position);
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
