import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prayer_room_locator/data/locations/location_model.dart';
import 'package:prayer_room_locator/utils/rating_display.dart';
import 'package:routemaster/routemaster.dart';

class LocationListItem extends ConsumerWidget {
  final LocationModel location;
  final Position userLocation;
  final BuildContext context;

  const LocationListItem({
    super.key,
    required this.location,
    required this.userLocation,
    required this.context,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final distance = (Geolocator.distanceBetween(
              userLocation.latitude,
              userLocation.longitude,
              location.latitude,
              location.longitude,
            ) /
            1000)
        .toStringAsFixed(2);

    return ListTile(
      title: Text(location.name),
      subtitle: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$distance km'),
            RatingDisplay(locationId: location.id),
          ],
        ),
      ),
      onTap: () {
        Routemaster.of(context).push('/location/${location.id}');
      },
    );
  }
}
