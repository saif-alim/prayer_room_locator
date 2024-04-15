import 'package:flutter/material.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';

// Class for email password sign up
class EmailPasswordSignupPage extends StatefulWidget {
  const EmailPasswordSignupPage({super.key});

  @override
  State<EmailPasswordSignupPage> createState() =>
      _EmailPasswordLoginPageState();
}

class _EmailPasswordLoginPageState extends State<EmailPasswordSignupPage> {
  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Method to handle user sign-up logic
  void signUpUser() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center content vertically
        children: [
          const Text(
            'Sign Up', // Heading
            style: Constants.heading1,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: nameController,
              hintText: 'Name',
            ), // Email text field
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: emailController,
              hintText: 'Email',
            ), // Email text field
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: passwordController,
              hintText: 'Password',
            ), // Password text field
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: CustomButton(
              onTap: signUpUser,
              text: 'Sign Up',
            ), // Submit button
          )
        ],
      ),
    );
  }
}
