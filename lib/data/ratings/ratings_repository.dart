import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:prayer_room_locator/data/ratings/rating.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/data/firebase_providers.dart';
import 'package:prayer_room_locator/utils/error-handling/type_defs.dart';
import 'package:rxdart/rxdart.dart';

// Provider for RatingsRepository
final ratingsRepositoryProvider = Provider((ref) {
  return RatingsRepository(firestore: ref.watch(firestoreProvider));
});

// Repository class for managing rating data from Firestore
class RatingsRepository {
  final FirebaseFirestore _firestore;

  RatingsRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // Gets access to the ratings collection in Firestore
  CollectionReference get _ratings =>
      _firestore.collection(FirebaseConstants.ratingsCollection);

  // Adds a new rating
  FutureVoid addRating(Rating rating) async {
    try {
      // Attempt to set the rating document in Firestore
      return right(_ratings.doc(rating.id).set(rating.toMap()));
    } on FirebaseException catch (e) {
      // Handle Firestore specific exceptions
      return left(Failure(e.message!));
    } catch (e) {
      // Handle any other exceptions
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Rating>> getRatings() {
    // Original Firestore stream
    Stream<List<Rating>> ratingsStream = _ratings.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Rating.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });

    // Applying debounce
    return ratingsStream.debounceTime(const Duration(seconds: 5));
  }

  // Updates a rating document in Firestore
  FutureVoid editRating(Rating rating) async {
    try {
      // Attempt to update the rating document
      return right(_ratings.doc(rating.id).update(rating.toMap()));
    } on FirebaseException catch (e) {
      // Handle Firestore specific exceptions
      throw e.message!;
    } catch (e) {
      // Handle other exceptions
      return left(Failure(e.toString()));
    }
  }

  // Get ratings by location ID
  Stream<List<Rating>> getRatingsByLocation(String locationId) {
    return _ratings
        .where('locationId', isEqualTo: locationId) // Filter by 'locationId'
        .snapshots()
        .map((event) {
      List<Rating> ratings = [];
      for (var doc in event.docs) {
        // Map each document to a Rating object
        ratings.add(Rating.fromMap(doc.data() as Map<String, dynamic>));
      }
      return ratings;
    });
  }
}
