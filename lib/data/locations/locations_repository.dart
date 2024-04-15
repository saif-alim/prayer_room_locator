import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/utils/error-handling/failure.dart';
import 'package:prayer_room_locator/data/firebase_providers.dart';
import 'package:prayer_room_locator/utils/error-handling/type_defs.dart';
import 'package:prayer_room_locator/data/locations/location_model.dart';

// Provider for LocationsRepository
final locationsRepositoryProvider = Provider((ref) {
  return LocationsRepository(firestore: ref.watch(firestoreProvider));
});

// Repository class for managing location data from Firestore
class LocationsRepository {
  final FirebaseFirestore _firestore;

  LocationsRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // Get access to the locations collection in Firestore
  CollectionReference get _locations =>
      _firestore.collection(FirebaseConstants.locationsCollection);

  // Method to add a new location document to Firestore
  FutureVoid addLocation(LocationModel locationModel) async {
    try {
      // Attempt to set location data and return right if successful
      return right(_locations.doc(locationModel.id).set(locationModel.toMap()));
    } on FirebaseException catch (e) {
      // Catch and handle Firestore specific exceptions by returning left with a Failure
      return left(Failure(e.message!));
    } catch (e) {
      // Handle any other exceptions by returning left with a Failure
      return left(Failure(e.toString()));
    }
  }

  // Stream to get all verified locations
  Stream<List<LocationModel>> getLocations() {
    return _locations
        .where('isVerified', isEqualTo: true) // Get only verified locations
        .snapshots()
        .map((event) {
      List<LocationModel> locations = [];
      for (var doc in event.docs) {
        // Convert each document into LocationModel and add to list
        locations
            .add(LocationModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return locations;
    });
  }

  // Stream to get a location by its ID
  Stream<LocationModel> getLocationById(String id) {
    return _locations.doc(id).snapshots().map(
        (event) => LocationModel.fromMap(event.data() as Map<String, dynamic>));
  }

  // Method to update location details
  FutureVoid editLocation(LocationModel location) async {
    try {
      // Attempt to update location data
      return right(_locations.doc(location.id).update(location.toMap()));
    } on FirebaseException catch (e) {
      // Handle Firestore specific exceptions
      throw e.message!;
    } catch (e) {
      // Handle any other exceptions
      return left(Failure(e.toString()));
    }
  }
}
