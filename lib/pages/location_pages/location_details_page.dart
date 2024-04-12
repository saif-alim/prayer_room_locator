import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/common/error_text.dart';
import 'package:prayer_room_locator/utils/common/loader.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/auth/auth_controller.dart';
import 'package:prayer_room_locator/locations/locations_controller.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class LocationDetailsPage extends ConsumerWidget {
  final String id;
  const LocationDetailsPage({
    super.key,
    required this.id,
  });

  // Launches the user's default navigation appliciation directing them to the relevant location.
  void launchMaps(double latitude, double longitude) async {
    Uri url;
    if (Platform.isIOS) {
      url = Uri.parse("https://maps.apple.com/?daddr=$latitude,$longitude");
    } else {
      url = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude');
    }

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  // get user current location
  Future<Position> _getUserLocation(WidgetRef ref) async {
    return ref.read(locationsControllerProvider.notifier).getUserLocation();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
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
                      Text(
                          '${location.latitude.toStringAsFixed(3)}, ${location.longitude.toStringAsFixed(3)}'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      launchMaps(location.latitude, location.longitude);
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
