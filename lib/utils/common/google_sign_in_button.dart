// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:prayer_room_locator/utils/common/constants.dart';
// import 'package:prayer_room_locator/data/auth/auth_controller.dart';

// // GoogleSignInButton widget
// class GoogleSignInButton extends ConsumerWidget {
//   const GoogleSignInButton({super.key});

//   // Initiate Google sign in process
//   void signInWithGoogle(BuildContext context, WidgetRef ref) {
//     // Accesses AuthController and calls signInWithGoogle
//     ref.read(authControllerProvider.notifier).signInWithGoogle(context);
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // ElevatedButton with an google icon
//     return ElevatedButton.icon(
//       style: const ButtonStyle(
//         backgroundColor: MaterialStatePropertyAll(Colors.white),
//         foregroundColor: MaterialStatePropertyAll(Colors.black),
//       ),
//       onPressed: () => signInWithGoogle(context, ref),
//       icon: Image.asset(
//         Constants.googlePath, // Set the Google icon
//         width: 35,
//       ),
//       label: const Text(
//         'Continue with Google',
//         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//       ), // Text label
//     );
//   }
// }
