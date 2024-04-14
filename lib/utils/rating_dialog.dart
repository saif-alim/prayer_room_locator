// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/data/ratings/rating.dart';
import 'package:prayer_room_locator/data/ratings/ratings_controller.dart';
import 'package:routemaster/routemaster.dart';

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

  Future<void> onRatingSubmit(double userRating, WidgetRef ref) async {
    final ratingsController = ref.read(ratingsControllerProvider.notifier);
    final existingRatings =
        await ref.read(ratingsByLocationProvider(locationId).future);

    final existingRating = existingRatings.firstWhere(
      (rating) => rating.uid == uid,
      orElse: () => Rating(id: '', ratingValue: 0.0, uid: '', locationId: ''),
    );

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

  void show() {
    double userRating = 5;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rate this Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Tap a star to set your rating.'),
              const SizedBox(height: 20),
              RatingBar.builder(
                initialRating: 5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  userRating = rating; // Update userRating
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Routemaster.of(context).pop(),
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                onRatingSubmit(userRating, ref);
                Routemaster.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
