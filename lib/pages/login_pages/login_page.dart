import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/utils/common/google_sign_in_button.dart';
import 'package:prayer_room_locator/utils/common/loader.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/auth/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  void logOut(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).logOut();
    Routemaster.of(context).push('/');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      body: isLoading
          ? const Loader()
          : Center(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.175),
                  const Text(
                    Constants.hijra,
                    style: Constants.heading1,
                  ),
                  const SizedBox(height: 5),
                  const Text('Hijra: Prayer Space Locator',
                      style: Constants.heading3),
                  const SizedBox(height: 40),
                  Image.asset(
                    Constants.logoPath,
                    height: 200,
                  ),
                  const SizedBox(height: 60),

                  // // Email Login
                  // CustomButton(
                  //   onTap: () {
                  //     Routemaster.of(context).push('/login');
                  //   },
                  //   text: 'Sign In',
                  // ),
                  // const SizedBox(height: 10),

                  // GOOGLE SIGN IN
                  const GoogleSignInButton(),
                  const SizedBox(height: 20),

                  // // Email Sign Up
                  // CustomButton(
                  //   onTap: () {
                  //     Routemaster.of(context).push('/signup');
                  //   },
                  //   text: 'Don\'t have an account? Sign up',
                  // ),
                ],
              ),
            ),
    );
  }
}
