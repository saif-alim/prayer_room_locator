import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/core/common/custom_widgets.dart';
import 'package:prayer_room_locator/features/auth/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Add user profile image URL
            ),
            const SizedBox(height: 20),
            Text(
              user.name, // user's name
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              user.email,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                //
                Routemaster.of(context).push('/settings');
              },
            ),
            const SizedBox(height: 10),
            // new location
            ListTile(
              title: const Text('Request a New Location'),
              onTap: () {
                //
                Routemaster.of(context).push('/addlocation');
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Color.fromARGB(255, 220, 77, 66),
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                // logic to handle logout
              },
            ),
          ],
        ),
      ),
    );
  }
}
