// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/data/ratings/rating.dart';
import 'package:prayer_room_locator/data/ratings/ratings_controller.dart';
import 'package:routemaster/routemaster.dart';

// Pop up rating dialog to submit user rating
class RatingDialog {
  final BuildContext context;
  final String locationId;
  final String uid;
  final WidgetRef ref;

  RatingDialog({
    required this.context,
    required this.locationId,
    required this.uid,
    required this.ref,
  });

  // Function to handle rating submission
  Future<void> submitRating(double userRating, WidgetRef ref) async {
    final ratingsController = ref.read(ratingsControllerProvider.notifier);
    // Get existing ratings for the location
    final existingRatings =
        await ref.read(ratingsByLocationProvider(locationId).future);

    // Find an existing rating by this user or create a default one if none exists
    final existingRating = existingRatings.firstWhere(
      (rating) => rating.uid == uid,
      orElse: () => Rating(id: '', ratingValue: 0.0, uid: '', locationId: ''),
    );

    // Add new rating or update existing rating
    if (existingRating.ratingValue > 0) {
      ratingsController.editRating(
        newRatingvalue: userRating,
        rating: existingRating,
        context: context,
      );
    } else {
      ratingsController.addRating(
        ratingValue: userRating,
        locationId: locationId,
        context: context,
      );
    }
  }

  // Function to display the dialog
  void show() {
    double userRating = 5; // Initially display 5 stars
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Rate this Location',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Tap a star to set your rating.'),
              const SizedBox(height: 20),
              RatingBar.builder(
                initialRating: 5, // Start with a full rating
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                unratedColor: Colors.black12,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  userRating = rating; // Update userRating on each change
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () =>
                  Routemaster.of(context).pop(), // Close the dialog on cancel
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                submitRating(userRating, ref); // Submit rating
                Routemaster.of(context).pop(); // Close the dialog on submit
              },
            ),
          ],
        );
      },
    );
  }
}
