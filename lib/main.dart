import 'package:flutter/material.dart';
import 'package:prayer_room_locator/features/auth/pages/login_page.dart';
import 'package:prayer_room_locator/features/auth/pages/map_page.dart';
import 'package:prayer_room_locator/features/auth/pages/profile_page.dart';
import 'package:prayer_room_locator/features/auth/pages/settings_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/mapPage': (context) => const MapPage(),
        '/settingsPage': (context) => const SettingsPage(),
        '/profilePage': (context) => const ProfilePage(),
        '/loginPage': (context) => const LoginPage(),
      },
    );
  }
}

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final firebaseUser = context.watch<User?>();

//     if (firebaseUser != null) {
//       return const FirstPage();
//     }
//     return const LoginPage();
//   }
// }
