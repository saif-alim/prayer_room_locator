import 'package:flutter/material.dart';
import 'package:prayer_room_locator/features/auth/pages/add_location_page.dart';
import 'package:prayer_room_locator/features/auth/pages/location_details_page.dart';
import 'package:prayer_room_locator/features/auth/pages/locations_list_view.dart';
import 'package:prayer_room_locator/features/auth/pages/login_page.dart';
import 'package:prayer_room_locator/features/auth/pages/map_page.dart';
import 'package:prayer_room_locator/features/auth/pages/profile_page.dart';
import 'package:prayer_room_locator/features/auth/pages/settings_page.dart';
import 'package:routemaster/routemaster.dart';

// loggedOut
final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginPage()),
});

//loggedIn
final loggedInRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: MapPage()),
  '/profile': (_) => const MaterialPage(child: ProfilePage()),
  '/settings': (_) => const MaterialPage(child: SettingsPage()),
  '/listview': (_) => const MaterialPage(child: LocationsListView()),
  '/addlocation': (_) => const MaterialPage(child: AddLocationPage()),
  '/location/:name': (route) => MaterialPage(
        child: LocationDetailsPage(
          name: route.pathParameters['name']!,
        ),
      ),
});
