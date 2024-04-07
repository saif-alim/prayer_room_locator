import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/core/common/custom_widgets.dart';
import 'package:prayer_room_locator/core/common/error_text.dart';
import 'package:prayer_room_locator/core/common/loader.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/features/auth/auth_controller.dart';
import 'package:prayer_room_locator/locations/locations_controller.dart';
import 'package:routemaster/routemaster.dart';

class LocationDetailsPage extends ConsumerWidget {
  final String id;
  const LocationDetailsPage({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return ref.watch(getLocationByIdProvider(id)).when(
          data: (location) => Scaffold(
            appBar: const CustomAppBar(),
            drawer: const CustomDrawer(),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  location.moderators.contains(user.uid)
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.45),
                          child: CustomButton(
                            text: 'Edit Details',
                            onTap: () {
                              // logic to navigate to edit page
                              Routemaster.of(context)
                                  .push('/mod/${location.id}');
                            },
                          ),
                        )
                      : Container(),
                  Text(
                    location.name,
                    style: Constants.heading1,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('latitude: ${location.latitude}'),
                      Text('longitude: ${location.longitude}'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // const Text('Photos', style: Constants.heading2),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.2,
                  //   child: ListView(
                  //     scrollDirection: Axis.horizontal,
                  //     children: [
                  //       Container(width: 160, color: Colors.purple),
                  //       const SizedBox(width: 5),
                  //       Container(width: 160, color: Colors.purple),
                  //       const SizedBox(width: 5),
                  //       Container(width: 160, color: Colors.purple),
                  //       const SizedBox(width: 5),
                  //     ],
                  //   ),
                  // ),
                  const Text('Details', style: Constants.heading2),
                  Text(location.details),
                  const SizedBox(height: 20),
                  // Grid
                  const Text('Amenities', style: Constants.heading2),
                  SizedBox(
                    height: 500,
                    child: GridView.builder(
                      itemCount: location.amenities.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return AmenitiesTile(
                            amenityType: location.amenities[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
