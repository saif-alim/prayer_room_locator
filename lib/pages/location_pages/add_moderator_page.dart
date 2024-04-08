// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/common/error_text.dart';
import 'package:prayer_room_locator/utils/common/loader.dart';
import 'package:prayer_room_locator/utils/common/utils.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/auth/auth_controller.dart';
import 'package:prayer_room_locator/locations/locations_controller.dart';
import 'package:prayer_room_locator/models/location_model.dart';
import 'package:prayer_room_locator/models/user_model.dart';

class AddModPage extends ConsumerStatefulWidget {
  final String locationId;
  const AddModPage({
    super.key,
    required this.locationId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModPageState();
}

class _AddModPageState extends ConsumerState<AddModPage> {
  Set<String> uids = {};
  late TextEditingController newModController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    newModController.dispose();
  }

  void clearFields() {
    newModController.clear();
  }

  void saveNewMod(
    LocationModel location,
    TextEditingController emailController,
    WidgetRef ref,
  ) async {
    // Get user model based on email entered
    final UserModel? user =
        await ref.read(getUserByEmailProvider(emailController.text).future);
    // check if user was retreived correctly
    if (user != null) {
      String newModId = user.uid;

      // update moderator
      ref.read(locationsControllerProvider.notifier).editLocation(
            newModId: newModId,
            locationDetails: null,
            newAmenities: null,
            location: location,
            context: context,
          );

      clearFields();
    } else {
      debugPrint('user not found');
      showSnackBar(context,
          'User not found. Please check the email address and try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getLocationByIdProvider(widget.locationId)).when(
          data: (location) => Scaffold(
            appBar: const CustomAppBar(),
            drawer: const CustomDrawer(),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Moderators', style: Constants.heading1),
                  // add moderator
                  const Text('Add Moderator', style: Constants.heading3),
                  CustomTextField(
                      controller: newModController, hintText: 'Enter email'),
                  Center(
                      child: CustomButton(
                    onTap: () => saveNewMod(location, newModController, ref),
                    text: 'Add Moderator',
                  )),
                  const SizedBox(height: 20),
                  // display current moderators
                  const Text('Current Moderators', style: Constants.heading3),
                  Expanded(
                    child: ListView.builder(
                      itemCount: location.moderators.length,
                      itemBuilder: (context, index) {
                        final modList = location.moderators.toList();
                        final modId = modList[index];

                        return ref.watch(getUserDataProvider(modId)).when(
                              data: (user) {
                                return ListTile(
                                  title: Text(user.email),
                                );
                              },
                              error: ((error, stackTrace) =>
                                  ErrorText(error: error.toString())),
                              loading: () => const Loader(),
                            );
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
