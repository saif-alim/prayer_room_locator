import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prayer_room_locator/data/locations/location_model.dart';
import 'package:prayer_room_locator/data/ratings/ratings_controller.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/error-handling/error_text.dart';
import 'package:prayer_room_locator/utils/common/loader.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/data/auth/auth_controller.dart';
import 'package:prayer_room_locator/data/locations/locations_controller.dart';
import 'package:prayer_room_locator/utils/rating_dialog.dart';
import 'package:routemaster/routemaster.dart';
import 'dart:math' as math;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// Class to display a specific location's details
class LocationDetailsPage extends ConsumerWidget {
  final String id; // ID of the location to edit
  const LocationDetailsPage({
    super.key,
    required this.id,
  });

  // Function launch native map application to the specified location
  void launchMaps(LocationModel location, WidgetRef ref) async {
    ref.read(locationsControllerProvider.notifier).launchMaps(location);
  }

  // Function to get user current location
  Future<Position> _getUserLocation(WidgetRef ref) async {
    return ref.read(locationsControllerProvider.notifier).getUserLocation();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Gets the current user's information from the user provider
    final user = ref.read(userProvider)!;

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: ref.watch(getLocationByIdProvider(id)).when(
            data: (location) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                children: [
                  // Conditionally displays the 'Edit Details' button if current user is a moderator for the location
                  location.moderators.contains(user.uid)
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            // text: 'Edit Details',
                            onPressed: () {
                              // Navigates to location moderator page
                              Routemaster.of(context)
                                  .push('/mod/${location.id}');
                            },
                            label: const Text('Edit'),
                            icon: const Icon(Icons.edit),
                          ),
                        )
                      : Container(),
                  Text(location.name, style: Constants.heading1),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // FutureBuilder to get and display the user's distance from the location
                      FutureBuilder<Position>(
                        future: _getUserLocation(ref),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData) {
                            return const Text('');
                          }
                          final distanceInMeters = Geolocator.distanceBetween(
                            snapshot.data!.latitude,
                            snapshot.data!.longitude,
                            location.latitude,
                            location.longitude,
                          );
                          final distanceInKilometers =
                              (distanceInMeters / 1000).toStringAsFixed(2);

                          return Text('$distanceInKilometers km');
                        },
                      ),
                      // Displays average rating
                      ref.watch(ratingsByLocationProvider(id)).when(
                            data: (ratings) {
                              final averageRating = ratings.isNotEmpty
                                  ? ratings
                                          .map((rating) => rating.ratingValue)
                                          .reduce((a, b) => a + b) /
                                      ratings.length
                                  : 0.0;
                              final int numRatings = ratings.length;

                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(numRatings
                                        .toString()), // Displays number of ratings
                                    const SizedBox(width: 3),
                                    GestureDetector(
                                      onTap: () {
                                        // Opens the rating dialog when tapped
                                        RatingDialog(
                                                locationId: location.id,
                                                uid: user.uid,
                                                context: context,
                                                ref: ref)
                                            .show();
                                      },
                                      child: RatingBar.builder(
                                        initialRating: averageRating,
                                        minRating: 1,
                                        maxRating: 5,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 20.0,
                                        itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.amber),
                                        onRatingUpdate: (rating) {},
                                        ignoreGestures: true,
                                      ), // Displays rating bar with average rating
                                    ),
                                  ],
                                ),
                              );
                            },
                            error: (e, stack) => Text("Error: $e"),
                            loading: () => const Loader(),
                          ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                      'Latitude: ${location.latitude.toStringAsFixed(3)}, Longitude: ${location.longitude.toStringAsFixed(3)}'),
                  const SizedBox(height: 10),
                  // Launch navigation to the location button
                  ElevatedButton.icon(
                    onPressed: () => launchMaps(location, ref),
                    icon: Transform.rotate(
                        angle: 45 * math.pi / 180,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Icon(Icons.navigation_outlined),
                        )),
                    label: const Text('Navigate'),
                  ),
                  const SizedBox(height: 20),
                  const Text('Details', style: Constants.heading2),
                  Text(location.details),
                  const SizedBox(height: 20),
                  const Text('Amenities', style: Constants.heading2),
                  // Displays a grid of available amenities
                  SizedBox(
                    height: 500,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: location.amenities.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (context, index) =>
                          AmenitiesTile(amenityType: location.amenities[index]),
                    ),
                  ),
                ],
              ),
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
