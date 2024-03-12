// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Settings'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This is all facade only',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Notification Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: false, // Add logic to control this value
              onChanged: (value) {
                // Add logic to handle switch state change
              },
            ),
            SizedBox(height: 20),
            Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
