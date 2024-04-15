import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/utils/common/google_sign_in_button.dart';
import 'package:prayer_room_locator/utils/common/loader.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/data/auth/auth_controller.dart';

// ConsumerWidget allows the widget to listen to Riverpod providers.
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      body: isLoading
          ? const Loader() // Loading indicator while processing
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.175), // Space from top proportional to device screen
                  const Text(
                    Constants.hijra,
                    style: Constants.heading1,
                  ),
                  const SizedBox(height: 5),
                  const Text('Hijra: Prayer Space Locator', // Heading
                      style: Constants.heading3),
                  const SizedBox(height: 40),
                  Image.asset(
                    Constants.logoPath,
                    height: 200,
                  ),
                  const SizedBox(height: 60),

                  // Google Sign-In Button widget
                  const GoogleSignInButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
