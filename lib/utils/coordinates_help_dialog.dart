import 'package:flutter/material.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';

// Pop up rating dialog to submit user rating
class CoordinatesHelpDialog {
  final BuildContext context;

  CoordinatesHelpDialog({
    required this.context,
  });

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  // Function to display the dialog
  void show() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'How to Get Coordinates',
            style: Constants.heading2,
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                SizedBox(height: 10),
                Text('1. Open Maps on your device.', style: Constants.heading4),
                SizedBox(height: 20),
                Text('2. Long press on the location until a pin drops.',
                    style: Constants.heading4),
                SizedBox(height: 20),
                Text('3. Tap on the pin to see the coordinates.',
                    style: Constants.heading4),
                SizedBox(height: 20),
                Text(
                    'You can also use the search bar in Maps to find a specific location and get its coordinates.'),
              ],
            ),
          ),
          actions: [
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () => _launchUrl(
                    'https://support.google.com/maps/answer/18539?hl=en-GB&co=GENIE.Platform%3DDesktop#:~:text=Get%20the%20coordinates%20for%20a,decimal%20format%20at%20the%20top.'),
                child: const Text(
                  'Still Need Help?',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Routemaster.of(context).pop();
              },
              child: const Text('OK', style: Constants.heading4),
            ),
          ],
        );
      },
    );
  }
}
