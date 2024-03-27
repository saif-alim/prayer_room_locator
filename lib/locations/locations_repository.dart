import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/core/failure.dart';
import 'package:prayer_room_locator/core/providers/firebase_providers.dart';
import 'package:prayer_room_locator/core/type_defs.dart';
import 'package:prayer_room_locator/models/location_model.dart';

final locationsRepositoryProvider = Provider((ref) {
  return LocationsRepository(firestore: ref.watch(firestoreProvider));
});

class LocationsRepository {
  final FirebaseFirestore _firestore;

  LocationsRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid addLocation(LocationModel locationModel) async {
    try {
      return right(_locations.doc(locationModel.id).set(locationModel.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<LocationModel>> getLocations() {
    return _locations
        .where('isVerified', isEqualTo: true)
        .snapshots()
        .map((event) {
      List<LocationModel> locations = [];
      for (var doc in event.docs) {
        locations
            .add(LocationModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      debugPrint('LOCATIONS LENGTH FROM REPO: ${locations.length}');
      return locations;
    });
  }

  Stream<LocationModel> getLocationById(String id) {
    return _locations.doc(id).snapshots().map(
        (event) => LocationModel.fromMap(event.data() as Map<String, dynamic>));
  }

  CollectionReference get _locations =>
      _firestore.collection(FirebaseConstants.locationsCollection);
}