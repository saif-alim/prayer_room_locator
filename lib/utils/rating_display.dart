import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/data/ratings/ratings_controller.dart';

// Class to display the average rating of a specified location
class RatingDisplay extends ConsumerWidget {
  final String locationId;

  const RatingDisplay({super.key, required this.locationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.read(ratingsByLocationProvider(locationId)).when(
          data: (ratings) {
            final averageRating = ratings.isNotEmpty
                ? ratings
                        .map((rating) => rating.ratingValue)
                        .reduce((a, b) => a + b) /
                    ratings.length
                : 0.0;
            return RatingBar.builder(
              initialRating: averageRating,
              minRating: 1,
              maxRating: 5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 20.0,
              unratedColor: Colors.black12,
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {},
              ignoreGestures: true,
            );
          },
          error: (e, stack) => Text('Error: $e'),
          loading: () => Container(),
        );
  }
}
