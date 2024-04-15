import 'package:flutter/material.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';

// Class for email password login
class EmailPasswordLoginPage extends StatefulWidget {
  const EmailPasswordLoginPage({super.key});

  @override
  State<EmailPasswordLoginPage> createState() => _EmailPasswordLoginPageState();
}

class _EmailPasswordLoginPageState extends State<EmailPasswordLoginPage> {
  final TextEditingController emailController =
      TextEditingController(); // Controller for email input
  final TextEditingController passwordController =
      TextEditingController(); // Controller for password input

  // Function to handle user login
  void loginUser() async {
    // Login functionality
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
