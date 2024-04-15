import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

// Shows a snack bar at the bottom of the screen with a specified message 'text'
void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text)),
  );
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(type: FileType.image);
  return image;
}
