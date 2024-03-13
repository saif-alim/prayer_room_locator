import 'package:flutter/material.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/features/auth/pages/map_page.dart';
import 'package:routemaster/routemaster.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Constants.hijra,
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(children: [
          const DrawerHeader(
            child: Center(
              child: Text(Constants.hijra, style: TextStyle(fontSize: 20)),
            ),
          ),
          ListTile(
            title: const Text(
              'Home',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Routemaster.of(context).push('/');
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Routemaster.of(context).push('/settings');
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Routemaster.of(context).push('/profile');
            },
          ),
        ]),
      ),
      body: MapPage(),
    );
  }
}
