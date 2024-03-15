import 'package:flutter/material.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:routemaster/routemaster.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        Constants.hijra,
        style: TextStyle(fontSize: 30),
      ),
      centerTitle: true,
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            Routemaster.of(context).pop();
          },
        ),
        ListTile(
          title: const Text('Settings'),
          onTap: () {
            Routemaster.of(context).push('/settings');
            Routemaster.of(context).pop();
          },
        ),
        ListTile(
          title: const Text('Profile'),
          onTap: () {
            Routemaster.of(context).push('/profile');
            Routemaster.of(context).pop();
          },
        ),
      ]),
    );
  }
}
