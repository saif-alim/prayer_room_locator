import 'package:flutter/material.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';

class EmailPasswordLoginPage extends StatefulWidget {
  const EmailPasswordLoginPage({super.key});

  @override
  State<EmailPasswordLoginPage> createState() => _EmailPasswordLoginPageState();
}

class _EmailPasswordLoginPageState extends State<EmailPasswordLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUser() async {}

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text(
          'Sign In',
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
            onTap: loginUser,
            text: 'Sign In',
          ),
        )
      ]),
    );
  }
}
