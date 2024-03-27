import 'package:flutter/material.dart';
import 'package:prayer_room_locator/core/common/custom_widgets.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';

class EmailPasswordSignupPage extends StatefulWidget {
  const EmailPasswordSignupPage({super.key});

  @override
  State<EmailPasswordSignupPage> createState() =>
      _EmailPasswordLoginPageState();
}

class _EmailPasswordLoginPageState extends State<EmailPasswordSignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signUpUser() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text(
          'Sign Up',
          style: Constants.heading1,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomTextField(
            controller: emailController,
            hintText: 'Enter your email',
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomTextField(
            controller: passwordController,
            hintText: 'Enter your password',
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: CustomButton(
            onTap: signUpUser,
            text: 'Sign Up',
          ),
        )
      ]),
    );
  }
}
