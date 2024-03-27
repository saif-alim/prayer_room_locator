import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/features/auth/auth_controller.dart';
import 'package:prayer_room_locator/models/location_model.dart';
import 'package:prayer_room_locator/locations/locations_repository.dart';
import 'package:prayer_room_locator/core/common/show_snack_bar.dart';
import 'package:routemaster/routemaster.dart';

final locationsProvider = StreamProvider((ref) {
  final locationsController = ref.watch(locationsControllerProvider.notifier);
  return locationsController.getLocations();
});

// final markerProvider = Provider<Future<List<Marker>>>((ref) async {
//   final locationsController = ref.watch(locationsControllerProvider.notifier);
//   final markers = locationsController.buildMarkers();
//   return markers;
// });

final locationsControllerProvider =
    StateNotifierProvider<LocationsController, bool>((ref) {
  final locationsRepository = ref.watch(locationsRepositoryProvider);
  return LocationsController(
      locationsRepository: locationsRepository, ref: ref);
});

final getLocationByIdProvider = StreamProvider.family((ref, String id) {
  return ref.watch(locationsControllerProvider.notifier).getLocationById(id);
});

//
class LocationsController extends StateNotifier<bool> {
  final LocationsRepository _locationsRepository;
  final Ref _ref;

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
      id: name.replaceAll(" ", ""),
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

  Future<List<Marker>> buildMarkers(BuildContext context) async {
    final locations = await getLocations().first;

    final List<Marker> markers = [];

    for (var location in locations) {
      markers.add(Marker(
        markerId: MarkerId(location.id),
        position: LatLng(location.x, location.y),
        onTap: () {
          // logic for navigating
          Routemaster.of(context).push('/location/${location.id}');
        },
        icon: BitmapDescriptor.defaultMarker,
      ));
    }
    debugPrint('MARK LENGTH: ${markers.length}');

    return markers;
  }

  Stream<LocationModel> getLocationById(String name) {
    return _locationsRepository.getLocationById(name);
  }
}
