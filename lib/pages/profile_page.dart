import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/data/auth/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

// Class to display user profile
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current user's data
    final user = ref.read(userProvider)!;

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('User Profile', style: Constants.heading1), // Heading
            const SizedBox(height: 20),
            Text(
              user.name, // Display user's name
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              user.email, // Display user's email
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              // Settings tile
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to settings page
                Routemaster.of(context).push('/settings');
              },
            ),
            const SizedBox(height: 10),
            // Tile for requesting a new location feature
            ListTile(
              leading: const Icon(Icons.question_mark),
              title: const Text('Request a New Location'),
              onTap: () {
                // Navigate to add location page
                Routemaster.of(context).push('/addlocation');
              },
            ),
          ],
        ),
      ),
    );
  }
}
