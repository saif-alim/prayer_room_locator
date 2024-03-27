import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prayer_room_locator/core/common/custom_widgets.dart';
import 'package:prayer_room_locator/locations/locations_controller.dart';

class GMapPage extends ConsumerWidget {
  const GMapPage({super.key});

  final initialLocation = const LatLng(51.5234, -0.0393);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsController = ref.watch(locationsControllerProvider.notifier);

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: FutureBuilder<List<Marker>>(
        future: locationsController.buildMarkers(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // or some placeholder
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialLocation,
              zoom: 13,
            ),
            onMapCreated: (controller) {},
            markers: Set.from(snapshot.data ?? []),
          );
        },
      ),
    );
  }
}
