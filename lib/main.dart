import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prayer_room_locator/utils/common/app_theme.dart';
import 'package:prayer_room_locator/utils/error-handling/error_text.dart';
import 'package:prayer_room_locator/utils/common/loader.dart';
import 'package:prayer_room_locator/data/auth/auth_controller.dart';
import 'package:prayer_room_locator/data/auth/user_model.dart';
import 'package:prayer_room_locator/utils/router.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Initialize Firebase with default settings
  );

  runApp(const ProviderScope(
    // Wraps the app with ProviderScope to enable Riverpod
    child: MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  // Retrieves user data and updates state
  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first; // Fetch UserModel for current user

    ref.read(userProvider.notifier).update((state) =>
        userModel); // Update the userProvider with the fetched user model
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
          data: (data) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme, // Sets custom light theme
            routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
              if (data != null) {
                getData(ref, data); // Gets user data
                if (userModel != null) {
                  return loggedInRoute; // If userModel is not null, returns the logged in route map
                }
              }
              return loggedOutRoute; // If data is null, returns the logged-out route map
            }),
            routeInformationParser: const RoutemasterParser(),
          ),
          error: (error, stackTrace) => ErrorText(
              error: error
                  .toString()), // Displays error if there's a problem with auth state
          loading: () =>
              const Loader(), // Shows a loading indicator while the auth state is being resolved
        );
  }
}
