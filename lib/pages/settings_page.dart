import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/data/auth/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

// Class to display settings
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  // Function to handle user logout
  void logOut(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).logOut();
    Routemaster.of(context).push('/'); // Navigate back to root
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Settings', // Heading
              style: Constants.heading1,
            ),
            const SizedBox(height: 10),
            // Account settings section
            const Text('Account Settings', style: Constants.heading3),
            ListTile(
              // Logout list tile
              leading: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 220, 77, 66),
              ),
              title: const Text(
                'Logout',
              ),
              onTap: () {
                logOut(ref, context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
