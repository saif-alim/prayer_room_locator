import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/data/auth/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void logOut(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).logOut();
    Routemaster.of(context).push('/');
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
              'Settings',
              style: Constants.heading1,
            ),
            const SizedBox(height: 10),
            // settings tiles
            const Text('Account Settings', style: Constants.heading3),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 220, 77, 66),
              ),
              title: const Text(
                'Logout',
              ),
              onTap: () {
                // logic to handle logout
                logOut(ref, context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
