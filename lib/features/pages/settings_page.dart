import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/core/common/custom_widgets.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

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
                title: const Text('Logout'),
                onTap: () {
                  // Add logic to handle logout
                }),
          ],
        ),
      ),
    );
  }
}