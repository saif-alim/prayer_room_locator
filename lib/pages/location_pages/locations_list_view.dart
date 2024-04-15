import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/error-handling/error_text.dart';
import 'package:prayer_room_locator/utils/common/loader.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/data/locations/location_model.dart';
import 'package:prayer_room_locator/data/locations/locations_controller.dart';
import 'package:prayer_room_locator/utils/location_list_tile.dart';
import 'package:routemaster/routemaster.dart';

// Class to display all locations sorted by distance
class LocationsListView extends ConsumerWidget {
  const LocationsListView({super.key});

  // Function to navigate to the detailed page of a given location
  void navigateToLocationPage(BuildContext context, LocationModel location) {
    Routemaster.of(context).push('/location/${location.id}');
  }

  // Function to get user current location
  Future<Position> _getUserLocation(WidgetRef ref) async {
    return ref.read(locationsControllerProvider.notifier).getUserLocation();
  }

  // Sort locations by distance from user location
  List sortByDistance(List list, Position fromLocation) {
    list.sort((a, b) {
      final distanceA = Geolocator.distanceBetween(
        fromLocation.latitude,
        fromLocation.longitude,
        a.latitude,
        a.longitude,
      );
      final distanceB = Geolocator.distanceBetween(
        fromLocation.latitude,
        fromLocation.longitude,
        b.latitude,
        b.longitude,
      );
      return distanceA.compareTo(distanceB);
    });

    return list;
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
              'Locations', // Heading
              style: Constants.heading1,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Sorted by distance',
                style: Constants.subtitle,
              ),
            ),
            const SizedBox(height: 5),
            FutureBuilder<Position>(
              future: _getUserLocation(ref),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader(); // Loading indicator while getting user location
                }
                if (snapshot.hasError) {
                  return ErrorText(
                      error: snapshot.error.toString()); // Error handling
                }
                final userLocation = snapshot.data!;
                return ref.watch(locationsProvider).when(
                      data: (locations) {
                        sortByDistance(
                            locations, userLocation); // Sort locations

                        // ListView to display sorted locations
                        return Expanded(
                          child: ListView.builder(
                              itemCount: locations.length,
                              itemBuilder: (BuildContext context, int index) {
                                final location = locations[index];
                                return LocationListItem(
                                  location: location,
                                  userLocation: userLocation,
                                  context: context,
                                );
                              }),
                        );
                      },
                      error: (error, stackTrace) => ErrorText(
                          error: error
                              .toString()), // Error text for location provider issues
                      loading: () =>
                          const Loader(), // Loading indicator while waiting for location provider
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
