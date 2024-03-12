import 'package:flutter/material.dart';
import 'package:prayer_room_locator/core/common/google_sign_in_button.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRL',
            style: TextStyle(fontWeight: FontWeight.w400, letterSpacing: 30)),
        centerTitle: true,
      ),
      body: Center(
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
