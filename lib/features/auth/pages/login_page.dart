import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/core/common/google_sign_in_button.dart';
import 'package:prayer_room_locator/core/common/loader.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/features/auth/controller/auth_controller.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRL',
            style: TextStyle(fontWeight: FontWeight.w400, letterSpacing: 30)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Loader()
          : Center(
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Image.asset(
                    Constants.loginEmotePath,
                    height: 200,
                  ),
                  const SizedBox(height: 100),

                  // Email Login
                  // CustomButton(
                  //   onTap: () {
                  //     Navigator.pushNamed(context, '/emailPasswordLoginPage');
                  //   },
                  //   text: 'Sign In',
                  // ),
                  const SizedBox(height: 10),

                  // GOOGLE SIGN IN
                  const GoogleSignInButton(),
                  const SizedBox(height: 20),

                  // Email Sign Up
                  // CustomButton(
                  //   onTap: () {
                  //     Navigator.pushNamed(context, '/emailPasswordSignupPage');
                  //   },
                  //   text: 'Don\'t have an account? Sign up',
                  // ),
                ],
              ),
            ),
    );
  }
}
