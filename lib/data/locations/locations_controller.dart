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

// Providers

final locationsProvider = StreamProvider((ref) {
  final locationsController = ref.watch(locationsControllerProvider.notifier);
  return locationsController.getLocations();
});

final locationsControllerProvider =
    StateNotifierProvider<LocationsController, bool>((ref) {
  final locationsRepository = ref.watch(locationsRepositoryProvider);
  return LocationsController(
      locationsRepository: locationsRepository, ref: ref);
});

final getLocationByIdProvider = StreamProvider.family((ref, String id) {
  return ref.watch(locationsControllerProvider.notifier).getLocationById(id);
});

final userLocationStreamProvider = StreamProvider<Position>((ref) {
  final locationsController = ref.watch(locationsControllerProvider.notifier);
  return locationsController.getPositionStream();
});

// LocationsController class
class LocationsController extends StateNotifier<bool> {
  final LocationsRepository _locationsRepository;
  final Ref _ref;

  LocationsController(
      {required LocationsRepository locationsRepository, required Ref ref})
      : _locationsRepository = locationsRepository,
        _ref = ref,
        super(false);

  void addLocation({
    required double latitude,
    required double longitude,
    required String name,
    required String details,
    required List<String> amenities,
    required BuildContext context,
  }) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    final modSet = Set<String>.from(Constants.initialModSet);
    modSet.add(uid);
    LocationModel locationModel = LocationModel(
      id: name.replaceAll(" ", ""), // eliminate spaces for id checks
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
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Success!');
      Routemaster.of(context).push('/');
    });
  }

  // Get locations from database
  Stream<List<LocationModel>> getLocations() {
    return _locationsRepository.getLocations();
  }

  // build markers and assign to list
  Future<List<Marker>> buildMarkers(BuildContext context) async {
    // Get list of LocationModel
    final locations = await getLocations().first;

    final List<Marker> markers = [];

    // Build markers with relevant details and add it to markers
    for (var location in locations) {
      markers.add(Marker(
        markerId: MarkerId(location.id),
        position: LatLng(location.latitude, location.longitude),
        onTap: () {
          // logic for navigating
          Routemaster.of(context).push('/location/${location.id}');
        },
        icon: BitmapDescriptor.defaultMarker,
      ));
    }

    return markers;
  }

  Stream<LocationModel> getLocationById(String name) {
    return _locationsRepository.getLocationById(name);
  }

  // edit location details
  void editLocation({
    required String? newLocationDetails,
    required String? newModId,
    required List<String>? newAmenities,
    required LocationModel location,
    required BuildContext context,
  }) async {
    // assign new details to location if new details are provided
    if (newLocationDetails != null) {
      location = location.copyWith(details: newLocationDetails);
    }
    if (newModId != null) {
      debugPrint('entered new mod id section');
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

  // Provide a stream of position updates
  Stream<Position> getPositionStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10, // update every 10 metres
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

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

  // get users current location after checking for permissions
  Future<Position> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    // Permission handling
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Permissions are granted and location can be accessed
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }
}
