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

class LocationDetailsPage extends ConsumerWidget {
  final String id;
  const LocationDetailsPage({
    super.key,
    required this.id,
  });

  // Launches the user's default navigation appliciation directing them to the relevant location.
  void launchMaps(LocationModel location, WidgetRef ref) async {
    ref.watch(locationsControllerProvider.notifier).launchMaps(location);
  }

  // get user current location
  Future<Position> _getUserLocation(WidgetRef ref) async {
    return ref.read(locationsControllerProvider.notifier).getUserLocation();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final ratingsStream = ref.watch(ratingsByLocationProvider(id));
    return ref.watch(getLocationByIdProvider(id)).when(
          data: (location) => Scaffold(
            appBar: const CustomAppBar(),
            drawer: const CustomDrawer(),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  location.moderators.contains(user.uid)
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.45),
                          child: CustomButton(
                            text: 'Edit Details',
                            onTap: () {
                              // logic to navigate to edit page
                              Routemaster.of(context)
                                  .push('/mod/${location.id}');
                            },
                          ),
                        )
                      : Container(),
                  Text(
                    location.name,
                    style: Constants.heading1,
                  ),
                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder<Position>(
                        future: _getUserLocation(ref),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData) {
                            return const Text('');
                          }
                          // Calculate the distance in kilometers and format it
                          final distanceInMeters = Geolocator.distanceBetween(
                            snapshot.data!.latitude,
                            snapshot.data!.longitude,
                            location.latitude,
                            location.longitude,
                          );
                          final distanceInKilometers =
                              (distanceInMeters / 1000).toStringAsFixed(2);

                          return Text(
                            '$distanceInKilometers km',
                          );
                        },
                      ),
                      // Rating section
                      ratingsStream.when(
                        data: (ratings) {
                          final filteredRatings =
                              ratings // Filter ratings to include only those with a value of at least 1
                                  .where((rating) => rating.ratingValue >= 1)
                                  .toList();

                          // Calculate the average of filtered ratings if not empty, else it's 0.0
                          final double averageRating =
                              filteredRatings.isNotEmpty
                                  ? filteredRatings
                                          .map((rating) => rating.ratingValue)
                                          .reduce((a, b) => a + b) /
                                      filteredRatings.length
                                  : 0.0;

                          final int numRatings = filteredRatings.length;

                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  numRatings.toString(),
                                ),
                                GestureDetector(
                                  onTap: () => RatingDialog(
                                          locationId: location.id,
                                          uid: user.uid,
                                          context: context,
                                          ref: ref)
                                      .show(),
                                  child: RatingBar.builder(
                                    initialRating: averageRating,
                                    minRating: 1,
                                    maxRating: 5,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 20.0, // Size of each star
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      // Add logic to change rating
                                    },
                                    ignoreGestures: true, // TEMP
                                  ),
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
                  // Navigate Button
                  ElevatedButton.icon(
                    onPressed: () {
                      launchMaps(location, ref);
                    },
                    icon: Transform.rotate(
                        angle: 45 * math.pi / 180, // Convert 45 to radians
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
                  // Grid
                  const Text('Amenities', style: Constants.heading2),
                  SizedBox(
                    height: 500,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: location.amenities.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return AmenitiesTile(
                            amenityType: location.amenities[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
