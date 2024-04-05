import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prayer_room_locator/core/common/custom_widgets.dart';
import 'package:prayer_room_locator/locations/locations_controller.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends ConsumerState<MapPage> {
  final Completer<GoogleMapController> mapController = Completer();
  Set<Marker> _markers = {};
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    super.initState();
    _initMapAndMarkers();
    _initPositionStream();
  }

  // functions and methods

  @override
  void dispose() {
    super.dispose();
    positionStream?.cancel();
  }

  // initialises position stream
  void _initPositionStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
    );

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((position) {
      _updatePositionMarker(position);
      debugPrint('init position streamed');
      // _moveToPosition(position);
    });
  }

  // update the marker for user's current position
  void _updatePositionMarker(Position position, {bool initial = false}) async {
    setState(() {
      _markers.removeWhere(
          (marker) => marker.markerId == const MarkerId('userPosition'));
      _markers.add(
        Marker(
          markerId: const MarkerId('userPosition'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue), // Use the custom icon if available
        ),
      );
    });
  }

  //
  Future<void> _initMapAndMarkers() async {
    Position position = await _determinePosition();
    _updatePositionMarker(position, initial: true);
    await _moveToPosition(position);
    await _getMarkers();
  }

  //
  Future<void> _getMarkers() async {
    final locationsController = ref.read(locationsControllerProvider.notifier);
    List<Marker> markers = await locationsController.buildMarkers(context);
    setState(() {
      _markers = Set.from(markers);
    });
  }

  // Get users current location after checking for permissions
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

    // Permissions are granted and we can continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    return position;
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
      body: GoogleMap(
        zoomControlsEnabled: false,
        compassEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: const CameraPosition(
          target: LatLng(51.5080, -0.1281),
          zoom: 10,
        ),
        onMapCreated: (controller) => mapController.complete(controller),
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Position position = await _determinePosition();
          await _moveToPosition(position);
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
