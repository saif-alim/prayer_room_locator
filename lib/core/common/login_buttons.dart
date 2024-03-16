import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/features/auth/services/auth_controller.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key});

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () => signInWithGoogle(context, ref),
      icon: Image.asset(
        Constants.googlePath,
        width: 35,
      ),
      label: const Text('Continue with Google', style: TextStyle(fontSize: 18)),
    );
  }
}

class EmailSignInButton extends ConsumerWidget {
  final String email;
  final String password;
  final BuildContext context;
  const EmailSignInButton(this.email, this.password, this.context, {super.key});

  void signInWithEmail(BuildContext context, WidgetRef ref) {
    ref
        .read(authControllerProvider.notifier)
        .signInWithEmail(email: email, password: password, context: context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => signInWithEmail(context, ref),
      child: const Text('Log In', style: TextStyle(fontSize: 18)),
    );
  }
}

class EmailSignUpButton extends ConsumerWidget {
  final String email;
  final String password;
  final BuildContext context;
  const EmailSignUpButton(this.email, this.password, this.context, {super.key});

  void signUpWithEmail(BuildContext context, WidgetRef ref) {
    ref
        .read(authControllerProvider.notifier)
        .signUpWithEmail(email: email, password: password, context: context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => signUpWithEmail(context, ref),
      child: const Text('Register', style: TextStyle(fontSize: 18)),
    );
  }
}
