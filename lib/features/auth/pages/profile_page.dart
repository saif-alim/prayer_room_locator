// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/core/common/custom_widgets.dart';
import 'package:prayer_room_locator/features/auth/controller/auth_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Add user profile image URL
            ),
            SizedBox(height: 20),
            Text(
              user.name, // Add user's name
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              user.email,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Edit Profile'),
              onTap: () {
                // navigation logic to edit profile page
              },
            ),
            ListTile(
              title: Text('Change Password'),
              onTap: () {
                // navigation logic to change password page
              },
            ),
            ListTile(
              title: Text('Logout'),
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
