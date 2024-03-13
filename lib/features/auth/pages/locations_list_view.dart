import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/repository/controller/locations_controller.dart';

class LocationsListView extends ConsumerWidget {
  const LocationsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(locationsProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Locations',
              style: Constants.heading1,
            ),
            const SizedBox(height: 10),
            Text(locations.length.toString()),
            //
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  final location = locations[index];
                  return ListTile(
                    title: Text(location.name),
                    onTap: () {
                      //
                    },
                  );
                }),
            const SizedBox(height: 10),
            const Text('end')
          ],
        ),
      ),
    );
  }
}