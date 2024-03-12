// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
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
              'John Doe', // Add user's name
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'johndoe@example.com', // Add user's email
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Edit Profile'),
              onTap: () {
                // Add navigation logic to edit profile page
              },
            ),
            ListTile(
              title: Text('Change Password'),
              onTap: () {
                // Add navigation logic to change password page
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                // Add logic to handle logout
              },
            ),
          ],
        ),
      ),
    );
  }
}
