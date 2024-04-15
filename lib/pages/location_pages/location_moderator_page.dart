import 'package:flutter/material.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:routemaster/routemaster.dart';

// Class to display moderator options
class LocationModeratorPage extends StatelessWidget {
  final String id; // The ID of the location to manage
  const LocationModeratorPage({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Moderator Tools', style: Constants.heading1), // Heading
            ListTile(
              leading: const Icon(Icons.add_moderator),
              title: const Text('Add Moderators'),
              onTap: () {
                // Logic to navigate to add moderators page
                Routemaster.of(context).push('/add-moderators/$id');
              },
            ), // Add moderators tile
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Location Details'),
              onTap: () {
                // Logic to navigate to edit details page
                Routemaster.of(context).push('/edit-location/$id');
              },
            ), // Edit details tile
          ],
        ),
      ),
    );
  }
}
