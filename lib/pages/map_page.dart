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
    _initMapAndMarkers(); // Initialize the map and markers once the widget is created
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose controller to free resources
    mapController.future.then((controller) {
      controller.dispose();
    });
  }

  // Initializes the user's position on the map and sets up markers
  Future<void> _initMapAndMarkers() async {
    Position position =
        await _getUserLocation(ref); // Get current user location
    await _moveToPosition(position); // Move the map to user location
    await _getMarkers(); // Fetch and set markers
  }

  // Get and build markers
  Future<void> _getMarkers() async {
    final locationsController = ref.read(locationsControllerProvider.notifier);
    List<Marker> markers = await locationsController.buildMarkers(context);
    setState(() {
      _markers = Set.from(markers);
    });
  }

  // Get current user location
  Future<Position> _getUserLocation(WidgetRef ref) async {
    return ref.read(locationsControllerProvider.notifier).getUserLocation();
  }

  // Animates the camera to the specified position
  Future<void> _moveToPosition(Position position) async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        14)); // Sets a zoom level of 14
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Consumer(
        builder: (context, ref, child) {
          // Listen for changes in the user's location
          final positionAsyncValue = ref.watch(userLocationStreamProvider);

          return positionAsyncValue.when(
            data: (position) {
              final userLocationMarker = Marker(
                markerId: const MarkerId('userPosition'),
                position: LatLng(position.latitude, position.longitude),
                infoWindow: const InfoWindow(title: 'Your Location'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue), // Blue marker for user location
              );

              final updatedMarkers = {
                ..._markers,
                userLocationMarker
              }; // Update the markers set with the user's location

              return GoogleMap(
                zoomControlsEnabled: false,
                compassEnabled: true,
                myLocationButtonEnabled: false,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(51.5080,
                      -0.1281), // Initial focus before user location is fetched
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
            loading: () =>
                const Loader(), // Loading indicator while getting data
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Transform.scale(
          scale: 1.2,
          child: FloatingActionButton(
            onPressed: () async {
              Position position =
                  await _getUserLocation(ref); // Get current location
              await _moveToPosition(
                  position); // Re-center the map to user location
            },
            elevation: 15,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
            foregroundColor: const Color.fromARGB(255, 58, 121, 154),
            child: const Icon(
              Icons.my_location,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
