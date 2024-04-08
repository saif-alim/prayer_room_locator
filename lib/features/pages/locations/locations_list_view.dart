import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prayer_room_locator/core/common/custom_widgets.dart';
import 'package:prayer_room_locator/core/common/error_text.dart';
import 'package:prayer_room_locator/core/common/loader.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/models/location_model.dart';
import 'package:prayer_room_locator/locations/locations_controller.dart';
import 'package:routemaster/routemaster.dart';

class LocationsListView extends ConsumerWidget {
  const LocationsListView({super.key});

  // navigate to the relevant location details page
  void navigateToLocationPage(BuildContext context, LocationModel location) {
    Routemaster.of(context).push('/location/${location.id}');
  }

  // get user current location
  Future<Position> _determinePosition(WidgetRef ref) async {
    return ref.read(locationsControllerProvider.notifier).determinePosition();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Locations',
              style: Constants.heading1,
            ),
            const SizedBox(height: 5),

            // Build the list of location tiles
            FutureBuilder<Position>(
              future: _determinePosition(ref),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader(); // Show loading widget
                }
                if (snapshot.hasError) {
                  return ErrorText(error: snapshot.error.toString());
                }
                final userLocation = snapshot.data!;
                return ref.watch(locationsProvider).when(
                      data: (locations) {
                        // Sort locations by distance from user current location
                        locations.sort((a, b) {
                          final distanceA = Geolocator.distanceBetween(
                            userLocation.latitude,
                            userLocation.longitude,
                            a.latitude,
                            a.longitude,
                          );
                          final distanceB = Geolocator.distanceBetween(
                            userLocation.latitude,
                            userLocation.longitude,
                            b.latitude,
                            b.longitude,
                          );
                          return distanceA.compareTo(distanceB);
                        });

                        // Return ListView with sorted locations
                        return Expanded(
                          child: ListView.builder(
                              itemCount: locations.length,
                              itemBuilder: (BuildContext context, int index) {
                                final location = locations[index];
                                return ListTile(
                                  title: Text(location.name),
                                  subtitle: Text(
                                      'x: ${location.latitude} y: ${location.longitude}'),
                                  onTap: () {
                                    navigateToLocationPage(context, location);
                                  },
                                );
                              }),
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader(),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
