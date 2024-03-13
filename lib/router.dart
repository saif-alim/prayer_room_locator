import 'package:flutter/material.dart';
import 'package:prayer_room_locator/features/auth/pages/home_page.dart';
import 'package:prayer_room_locator/features/auth/pages/login_page.dart';
import 'package:prayer_room_locator/features/auth/pages/profile_page.dart';
import 'package:prayer_room_locator/features/auth/pages/settings_page.dart';
import 'package:routemaster/routemaster.dart';

// loggedOut
final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginPage()),
});

//loggedIn
final homeRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomePage()),
});

// profile
final profileRoute = RouteMap(routes: {
  '/profile': (_) => const MaterialPage(child: ProfilePage()),
});

// settings
final settingsRoute = RouteMap(routes: {
  '/settings': (_) => const MaterialPage(child: SettingsPage()),
});
