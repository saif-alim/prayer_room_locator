import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/data/auth/auth_controller.dart';
import 'package:prayer_room_locator/data/ratings/rating.dart';
import 'package:prayer_room_locator/data/ratings/ratings_repository.dart';
import 'package:prayer_room_locator/utils/common/utils.dart';

// Providers

final ratingsProvider = StreamProvider.autoDispose((ref) {
  final ratingsController = ref.watch(ratingsControllerProvider.notifier);
  return ratingsController.getRatings();
});

final ratingsControllerProvider =
    StateNotifierProvider<RatingsController, bool>((ref) {
  final ratingsRepository = ref.watch(ratingsRepositoryProvider);
  return RatingsController(ratingsRepository: ratingsRepository, ref: ref);
});

final ratingsByLocationProvider =
    StreamProvider.family.autoDispose<List<Rating>, String>((ref, locationId) {
  final ratingsRepository = ref.watch(ratingsRepositoryProvider);
  return ratingsRepository.getRatingsByLocation(locationId);
});

class RatingsController extends StateNotifier<bool> {
  final RatingsRepository _ratingsRepository;
  final Ref _ref;

  // RatingsController class
  RatingsController(
      {required RatingsRepository ratingsRepository, required Ref ref})
      : _ratingsRepository = ratingsRepository,
        _ref = ref,
        super(false);

  // Add a new rating
  void addRating({
    required double ratingValue,
    required String locationId,
    required BuildContext context,
  }) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';

    Rating rating = Rating(
      id: locationId + uid,
      ratingValue: ratingValue,
      uid: uid,
      locationId: locationId,
    );

    final result = await _ratingsRepository.addRating(rating);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Rating added');
    });
  }

  // Get ratings from database
  Stream<List<Rating>> getRatings() {
    return _ratingsRepository.getRatings();
  }

  Stream<List<Rating>> getRatingsByLocation(String locationId) {
    return _ratingsRepository.getRatingsByLocation(locationId);
  }

  // Edit rating
  void editRating({
    required double newRatingvalue,
    required Rating rating,
    required BuildContext context,
  }) async {
    rating = rating.copyWith(ratingValue: newRatingvalue);
    final result = await _ratingsRepository.editRating(rating);

    result.fold((l) => showSnackBar(context, l.message),
        (r) => showSnackBar(context, 'Rating changed'));
  }
}
