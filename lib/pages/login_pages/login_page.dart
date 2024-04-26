import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:routemaster/routemaster.dart';

// ConsumerWidget allows the widget to listen to Riverpod providers.
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  // // Initiate Google sign in process
  // void signInWithGoogle(BuildContext context, WidgetRef ref) {
  //   // Accesses AuthController and calls signInWithGoogle
  //   ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.68;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Hijra', // Heading
                style: Constants.heading1),
            const Text('A Prayer Space Locator', // Heading
                style: Constants.heading3),
            const SizedBox(height: 40),
            Image.asset(
              Constants.logoPath,
              height: 200,
            ),
            const SizedBox(height: 60),

            // Email Login
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                    foregroundColor: MaterialStatePropertyAll(Colors.black)),
                onPressed: () {
                  Routemaster.of(context).push('/login');
                },
                child: const Text(
                  'Login',
                  style: Constants.buttonLabel,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Email Sign Up
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                    foregroundColor: MaterialStatePropertyAll(Colors.black)),
                onPressed: () {
                  Routemaster.of(context).push('/signup');
                },
                child: const Text(
                  'Sign Up',
                  style: Constants.buttonLabel,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // // Google Sign-In Button widget
            // SizedBox(
            //   width: buttonWidth,
            //   child: ElevatedButton.icon(
            //     style: const ButtonStyle(
            //       backgroundColor: MaterialStatePropertyAll(Colors.white),
            //       foregroundColor: MaterialStatePropertyAll(Colors.black),
            //     ),
            //     onPressed: () => signInWithGoogle(context, ref),
            //     icon: Image.asset(
            //       Constants.googlePath, // Google icon
            //       width: 35,
            //     ),
            //     label: const Text(
            //       'Continue with Google',
            //       style: Constants.buttonLabel,
            //     ), // Text label
            //   ),
            // ),
            // const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
