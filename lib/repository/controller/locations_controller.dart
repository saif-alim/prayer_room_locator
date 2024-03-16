import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/features/auth/controller/auth_controller.dart';
import 'package:prayer_room_locator/models/location_model.dart';
import 'package:prayer_room_locator/repository/locations_repository.dart';
import 'package:prayer_room_locator/utils/show_snack_bar.dart';
import 'package:routemaster/routemaster.dart';

final locationsProvider = StreamProvider((ref) {
  final locationsController = ref.watch(locationsControllerProvider.notifier);
  return locationsController.getLocations();
});

final markerProvider = Provider<Future<List<Marker>>>((ref) async {
  final locationsController = ref.watch(locationsControllerProvider.notifier);
  final markers = locationsController.buildMarkers();
  return markers;
});

final locationsControllerProvider =
    StateNotifierProvider<LocationsController, bool>((ref) {
  final locationsRepository = ref.watch(locationsRepositoryProvider);
  return LocationsController(
      locationsRepository: locationsRepository, ref: ref);
});

final getLocationByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(locationsControllerProvider.notifier)
      .getLocationByName(name);
});

//
class LocationsController extends StateNotifier<bool> {
  final LocationsRepository _locationsRepository;
  final Ref _ref;
  // final List<Marker> _markers = [];

  LocationsController(
      {required LocationsRepository locationsRepository, required Ref ref})
      : _locationsRepository = locationsRepository,
        _ref = ref,
        super(false);

  void addLocation(double x, double y, String name, String details,
      BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    LocationModel locationModel = LocationModel(
      id: name,
      x: x,
      y: y,
      name: name,
      details: details,
      photos: [],
      moderators: [Constants.alimID, uid],
      isVerified: false,
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

  Future<List<Marker>> buildMarkers() async {
    final locations = await getLocations().first;

    final List<Marker> markers = [];

    for (var location in locations) {
      markers.add(
        Marker(
          point: LatLng(location.x, location.y),
          child: const Icon(
            Icons.location_pin,
            color: Color.fromARGB(255, 255, 80, 67),
            size: 40,
          ),
        ),
      );
    }
    // _markers.clear();
    // buildMarkers();
    debugPrint('MARK LENGTH: ${markers.length}');
    debugPrint('MARK: ${markers[0].point.latitude}');

    return markers;
  }

  Stream<LocationModel> getLocationByName(String name) {
    return _locationsRepository.getLocationByName(name);
  }
}
