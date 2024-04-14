import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:prayer_room_locator/data/ratings/rating.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/utils/error-handling/failure.dart';
import 'package:prayer_room_locator/data/firebase_providers.dart';
import 'package:prayer_room_locator/utils/error-handling/type_defs.dart';

final ratingsRepositoryProvider = Provider((ref) {
  return RatingsRepository(firestore: ref.watch(firestoreProvider));
});

class RatingsRepository {
  final FirebaseFirestore _firestore;

  RatingsRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _ratings =>
      _firestore.collection(FirebaseConstants.ratingsCollection);

  // Add a new rating
  FutureVoid addRating(Rating rating) async {
    try {
      return right(_ratings.doc(rating.id).set(rating.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Get a List<Rating> of all ratings
  Stream<List<Rating>> getRatings() {
    return _ratings.snapshots().map((event) {
      List<Rating> ratings = [];
      for (var doc in event.docs) {
        ratings.add(Rating.fromMap(doc.data() as Map<String, dynamic>));
      }
      return ratings;
    });
  }

  // Edit rating
  FutureVoid editRating(Rating rating) async {
    try {
      //
      return right(_ratings.doc(rating.id).update(rating.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Rating>> getRatingsByLocation(String locationId) {
    return _ratings
        .where('locationId', isEqualTo: locationId)
        .snapshots()
        .map((event) {
      List<Rating> locations = [];
      for (var doc in event.docs) {
        locations.add(Rating.fromMap(doc.data() as Map<String, dynamic>));
      }
      return locations;
    });
  }
}
