import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/core/common/custom_widgets.dart';
import 'package:prayer_room_locator/core/common/error_text.dart';
import 'package:prayer_room_locator/core/common/loader.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/models/location_model.dart';
import 'package:prayer_room_locator/locations/locations_controller.dart';
import 'package:routemaster/routemaster.dart';

class LocationsListView extends ConsumerWidget {
  const LocationsListView({super.key});

  //functions
  void navigateToLocationPage(BuildContext context, LocationModel location) {
    Routemaster.of(context).push('/location/${location.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Locations',
              style: Constants.heading1,
            ),
            const SizedBox(height: 10),
            //
            ref.watch(locationsProvider).when(
                data: (locations) => Expanded(
                    child: ListView.builder(
                        itemCount: locations.length,
                        itemBuilder: (BuildContext context, int index) {
                          final location = locations[index];
                          return ListTile(
                            title: Text(location.name),
                            subtitle: Text('x: ${location.x} y: ${location.y}'),
                            onTap: () {
                              // logic for redirecting to location details page.
                              navigateToLocationPage(context, location);
                            },
                          );
                        })),
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader()),
          ],
        ),
      ),
    );
  }
}
