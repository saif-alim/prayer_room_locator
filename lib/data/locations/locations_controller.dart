import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/data/auth/auth_controller.dart';
import 'package:prayer_room_locator/data/locations/location_model.dart';
import 'package:prayer_room_locator/data/locations/locations_repository.dart';
import 'package:prayer_room_locator/utils/common/utils.dart';
import 'package:routemaster/routemaster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

// Provider to retrieve a stream of locations
final locationsProvider = StreamProvider((ref) {
  final locationsController = ref.watch(locationsControllerProvider.notifier);
  return locationsController.getLocations();
});

// Provider for locations controller class
final locationsControllerProvider =
    StateNotifierProvider<LocationsController, bool>((ref) {
  final locationsRepository = ref.watch(locationsRepositoryProvider);
  return LocationsController(
      locationsRepository: locationsRepository, ref: ref);
});

// Provider to get location by ID
final getLocationByIdProvider =
    StreamProvider.autoDispose.family((ref, String id) {
  return ref.watch(locationsControllerProvider.notifier).getLocationById(id);
});

// Provider to monitor and stream user location
final userLocationStreamProvider = StreamProvider.autoDispose<Position>((ref) {
  final locationsController = ref.watch(locationsControllerProvider.notifier);
  return locationsController.getPositionStream();
});

// Class managing location operations
class LocationsController extends StateNotifier<bool> {
  final LocationsRepository _locationsRepository;
  final Ref _ref;

  LocationsController(
      {required LocationsRepository locationsRepository, required Ref ref})
      : _locationsRepository = locationsRepository,
        _ref = ref,
        super(false); // Initializes with 'false' indicating not loading

  // Method to add a new location into the database
  void addLocation({
    required double latitude,
    required double longitude,
    required String name,
    required String details,
    required List<String> amenities,
    required BuildContext context,
  }) async {
    state = true; // Start loading
    final uid = _ref.read(userProvider)?.uid ?? '';
    final modSet = Set<String>.from(Constants.initialModSet);
    modSet.add(uid); // Add current user as a moderator
    LocationModel locationModel = LocationModel(
      id: name.replaceAll(" ", ""), // Create ID by removing spaces
      latitude: latitude,
      longitude: longitude,
      name: name,
      details: details,
      photos: [],
      moderators: modSet,
      isVerified: false,
      amenities: amenities,
    );

    final result = await _locationsRepository.addLocation(locationModel);
    state = false; // Stop loading
    result.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Success!');
      Routemaster.of(context).push('/');
    });
  }

  // Stream of locations from the database
  Stream<List<LocationModel>> getLocations() {
    return _locationsRepository.getLocations();
  }

// Method to build map markers for each location
  Future<List<Marker>> buildMarkers(BuildContext context) async {
    final locations = await getLocations().first; // cache
    return locations
        .map((location) => Marker(
              markerId: MarkerId(location.id),
              position: LatLng(location.latitude, location.longitude),
              onTap: () =>
                  Routemaster.of(context).push('/location/${location.id}'),
              icon: BitmapDescriptor.defaultMarker,
            ))
        .toList();
  }

  // Get a location by its ID
  Stream<LocationModel> getLocationById(String name) {
    return _locationsRepository.getLocationById(name);
  }

  // Method to edit location details
  void editLocation({
    required String? newLocationDetails,
    required String? newModId,
    required List<String>? newAmenities,
    required LocationModel location,
    required BuildContext context,
  }) async {
    if (newLocationDetails != null) {
      location = location.copyWith(details: newLocationDetails);
    }
    if (newModId != null) {
      Set<String> newModSet = location.moderators;
      newModSet.add(newModId);
      location = location.copyWith(moderators: newModSet);
    }
    if (newAmenities != null) {
      location = location.copyWith(amenities: newAmenities);
    }
    final result = await _locationsRepository.editLocation(location);

    result.fold((l) => showSnackBar(context, l.message),
        (r) => showSnackBar(context, 'Success!'));
  }

  Stream<Position> getPositionStream() async* {
    StreamController<Position> controller = StreamController<Position>();
    await checkAndStartStream(controller);
    yield* controller.stream;
  }

  // Checks for permissions and starts stream when permissions are enabled
  Future<void> checkAndStartStream(
      StreamController<Position> controller) async {
    // Checks that location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission =
        await Geolocator.checkPermission(); // checks for location permissions

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      return;
    }

    startLocationStream(controller);
  }

  void startLocationStream(StreamController<Position> controller) {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10, // Updates every 10 metres
    );

    var positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings);
    positionStream.listen(
      (position) {
        controller.add(position);
      },
      onError: (e) {
        controller.addError(e);
      },
      onDone: () {
        controller.close();
      },
      cancelOnError: true,
    );
  }

  // Method to get a future of user current position
  Future<Position> getUserLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  // Method to open native maps app and direct to a specific location
  void launchMaps(LocationModel location) async {
    Uri url;
    if (Platform.isIOS) {
      url = Uri.parse(
          "https://maps.apple.com/?daddr=${location.latitude},${location.longitude}");
    } else {
      url = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=${location.latitude},${location.longitude}');
    }

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
