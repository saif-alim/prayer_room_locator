import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/features/auth/auth_controller.dart';
import 'package:prayer_room_locator/models/location_model.dart';
import 'package:prayer_room_locator/locations/locations_repository.dart';
import 'package:prayer_room_locator/core/common/utils.dart';
import 'package:routemaster/routemaster.dart';

// Providers
//
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

// LocationsController class
class LocationsController extends StateNotifier<bool> {
  final LocationsRepository _locationsRepository;
  final Ref _ref;

  LocationsController(
      {required LocationsRepository locationsRepository, required Ref ref})
      : _locationsRepository = locationsRepository,
        _ref = ref,
        super(false);

  void addLocation(double latitude, double longitude, String name,
      String details, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    final modSet = Set<String>.from(Constants.initialModSet);
    modSet.add(uid);
    LocationModel locationModel = LocationModel(
      id: name.replaceAll(" ", ""),
      latitude: latitude,
      longitude: longitude,
      name: name,
      details: details,
      photos: [],
      moderators: modSet,
      isVerified: false,
      amenities: [],
    );

    final result = await _locationsRepository.addLocation(locationModel);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Success!');
      Routemaster.of(context).push('/');
    });
  }

  Stream<List<LocationModel>> getLocations() {
    return _locationsRepository.getLocations();
  }

  // build markers and assign to list
  Future<List<Marker>> buildMarkers(BuildContext context) async {
    final locations = await getLocations().first;

    final List<Marker> markers = [];

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
}
