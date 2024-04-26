import 'package:flutter/material.dart';

// Shows a snack bar at the bottom of the screen with a specified message 'text'
void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text)),
  );
}
