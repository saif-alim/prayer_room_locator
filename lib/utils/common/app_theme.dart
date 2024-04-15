import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    // Define the light theme
    return ThemeData.light().copyWith(
        colorScheme: ThemeData.light().colorScheme.copyWith(
              secondary: Colors.green,
            ),
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Lora',
            ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 15,
          backgroundColor: Color.fromARGB(255, 68, 130, 163),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 11, 80, 67),
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 2, // Default elevation
            // For text color and button shadows, etc.
          ),
        ),
        iconButtonTheme: const IconButtonThemeData(
            style: ButtonStyle(elevation: MaterialStatePropertyAll(10))));
  }
}
