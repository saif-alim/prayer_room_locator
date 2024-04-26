import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:prayer_room_locator/data/ratings/ratings_controller.dart';

class RatingDisplay extends ConsumerWidget {
  final String locationId;

  const RatingDisplay({super.key, required this.locationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(ratingsByLocationProvider(locationId)).when(
          data: (ratings) {
            if (ratings.isEmpty) {
              return Container();
            }
            final averageRating = ratings.isNotEmpty
                ? ratings.fold<double>(
                        0.0, (sum, rating) => sum + rating.ratingValue) /
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
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              unratedColor: Colors.black12,
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {},
              ignoreGestures: true,
              updateOnDrag: false,
            );
          },
          error: (e, stack) =>
              Container(), // ErrorText(error: 'Error: ${e.toString}'),
          loading: () => Container(),
        );
  }
}
