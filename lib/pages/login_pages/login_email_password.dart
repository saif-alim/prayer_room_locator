import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/data/auth/auth_controller.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:routemaster/routemaster.dart';

// Class for email password login
class EmailPasswordLoginPage extends ConsumerStatefulWidget {
  const EmailPasswordLoginPage({super.key});

  @override
  ConsumerState<EmailPasswordLoginPage> createState() =>
      _EmailPasswordLoginPageState();
}

class _EmailPasswordLoginPageState
    extends ConsumerState<EmailPasswordLoginPage> {
  final TextEditingController emailController =
      TextEditingController(); // Controller for email input
  final TextEditingController passwordController =
      TextEditingController(); // Controller for password input

  // Function to handle user login
  void loginUser() {
    // Login functionality
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    ref.read(authControllerProvider.notifier).loginWithEmail(
          email: email,
          password: password,
          context: context,
        );
    Routemaster.of(context).pop();
  }

  // Dispose of controllers
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
            'Login', // Heading
            style: Constants.heading1,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: emailController,
              hintText: 'Enter your email',
            ), // Email text field
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: passwordController,
              hintText: 'Enter your password',
              isPass: true,
            ), // Password text field
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: CustomButton(
              onTap: loginUser, // Login user on tap
              text: 'Sign In',
            ), // Login button
          )
        ],
      ),
    );
  }
}
