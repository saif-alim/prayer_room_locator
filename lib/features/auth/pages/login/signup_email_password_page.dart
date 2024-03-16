import 'package:flutter/material.dart';
import 'package:prayer_room_locator/core/common/login_buttons.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/widgets/custom_textfield.dart';

class EmailPasswordSignup extends StatefulWidget {
  const EmailPasswordSignup({super.key});

  @override
  State<EmailPasswordSignup> createState() => _EmailPasswordSignupState();
}

class _EmailPasswordSignupState extends State<EmailPasswordSignup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Register',
            style: Constants.heading1,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          //
          CustomTextField(
            controller: emailController,
            hintText: 'Enter your email',
          ),
          const SizedBox(height: 20),
          //
          CustomTextField(
            controller: passwordController,
            hintText: 'Enter your password',
          ),
          const SizedBox(height: 20),
          //
          EmailSignUpButton(
              emailController.text, passwordController.text, context),
        ],
      ),
    );
  }
}
