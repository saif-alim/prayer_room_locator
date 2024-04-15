import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/data/auth/auth_controller.dart';
import 'package:prayer_room_locator/data/ratings/rating.dart';
import 'package:prayer_room_locator/data/ratings/ratings_repository.dart';
import 'package:prayer_room_locator/utils/common/utils.dart';

// Provider for ratings
final ratingsProvider = StreamProvider.autoDispose((ref) {
  final ratingsController = ref.watch(ratingsControllerProvider.notifier);
  return ratingsController.getRatings();
});

// Provider for RatingsController
final ratingsControllerProvider =
    StateNotifierProvider.autoDispose<RatingsController, bool>((ref) {
  final ratingsRepository = ref.read(ratingsRepositoryProvider);
  return RatingsController(ratingsRepository: ratingsRepository, ref: ref);
});

// Provider to get ratings by location
final ratingsByLocationProvider =
    StreamProvider.autoDispose.family<List<Rating>, String>((ref, locationId) {
  final ratingsRepository = ref.read(ratingsRepositoryProvider);
  return ratingsRepository.getRatingsByLocation(locationId);
});

// Controller class to manage rating operations
class RatingsController extends StateNotifier<bool> {
  final RatingsRepository _ratingsRepository;
  final Ref _ref;

  RatingsController(
      {required RatingsRepository ratingsRepository, required Ref ref})
      : _ratingsRepository = ratingsRepository,
        _ref = ref,
        super(false); // Start with 'false' indicating no loading

  // Method to add a new rating
  void addRating({
    required double ratingValue,
    required String locationId,
    required BuildContext context,
  }) async {
    state = true; // Indicate start of an operation
    final uid = _ref.read(userProvider)?.uid ?? ''; // Get uid from the provider

    // Create new Rating object
    Rating rating = Rating(
      id: locationId + uid,
      ratingValue: ratingValue,
      uid: uid,
      locationId: locationId,
    );

    // Call repository to add rating
    final result = await _ratingsRepository.addRating(rating);
    state = false; // Indicate operation is finished
    result.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Rating added');
    });
  }

  // Get all ratings from the repository
  Stream<List<Rating>> getRatings() {
    return _ratingsRepository.getRatings();
  }

  // Get ratings for a specific location
  Stream<List<Rating>> getRatingsByLocation(String locationId) {
    return _ratingsRepository.getRatingsByLocation(locationId);
  }

  // Method to edit a rating
  void editRating({
    required double newRatingvalue,
    required Rating rating,
    required BuildContext context,
  }) async {
    rating = rating.copyWith(
        ratingValue: newRatingvalue); // Update the rating with the new value

    final result = await _ratingsRepository.editRating(
        rating); // Call repository to edit the rating and handle the result

    result.fold((l) => showSnackBar(context, l.message),
        (r) => showSnackBar(context, 'Rating changed'));
  }
}
