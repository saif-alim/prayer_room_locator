import 'package:flutter/material.dart';
import 'package:prayer_room_locator/features/pages/locations/add_location_page.dart';
import 'package:prayer_room_locator/features/pages/google_map_page.dart';
import 'package:prayer_room_locator/features/pages/locations/add_moderator_page.dart';
import 'package:prayer_room_locator/features/pages/locations/edit_location_details.dart';
import 'package:prayer_room_locator/features/pages/locations/location_details_page.dart';
import 'package:prayer_room_locator/features/pages/locations/location_moderator_page.dart';
import 'package:prayer_room_locator/features/pages/locations/locations_list_view.dart';
import 'package:prayer_room_locator/features/pages/login/login_email_password.dart';
import 'package:prayer_room_locator/features/pages/login/login_page.dart';
import 'package:prayer_room_locator/features/pages/login/signup_email_password_page.dart';
import 'package:prayer_room_locator/features/pages/profile_page.dart';
import 'package:prayer_room_locator/features/pages/settings_page.dart';
import 'package:routemaster/routemaster.dart';

// loggedOut
final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginPage()),
  '/signup': (_) => const MaterialPage(child: EmailPasswordSignupPage()),
  '/login': (_) => const MaterialPage(child: EmailPasswordLoginPage()),
});

//loggedIn
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: GMapPage()),
  '/profile': (_) => const MaterialPage(child: ProfilePage()),
  '/settings': (_) => const MaterialPage(child: SettingsPage()),
  '/listview': (_) => const MaterialPage(child: LocationsListView()),
  '/addlocation': (_) => const MaterialPage(child: AddLocationPage()),
  '/location/:id': (route) => MaterialPage(
        child: LocationDetailsPage(
          id: route.pathParameters['id']!,
        ),
      ),
  '/mod/:id': (route) => MaterialPage(
          child: LocationModeratorPage(
        id: route.pathParameters['id']!,
      )),
  '/edit-location/:id': (route) => MaterialPage(
          child: EditLocationDetails(
        id: route.pathParameters['id']!,
      )),
  '/add-moderators/:id': (route) => MaterialPage(
          child: AddModPage(
        locationId: route.pathParameters['id']!,
      ))
});
