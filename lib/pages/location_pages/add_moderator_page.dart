// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/error-handling/error_text.dart';
import 'package:prayer_room_locator/utils/common/loader.dart';
import 'package:prayer_room_locator/utils/common/utils.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/data/auth/auth_controller.dart';
import 'package:prayer_room_locator/data/locations/locations_controller.dart';
import 'package:prayer_room_locator/data/locations/location_model.dart';
import 'package:prayer_room_locator/data/auth/user_model.dart';

class AddModPage extends ConsumerStatefulWidget {
  final String locationId; // ID of the relevant location
  const AddModPage({
    super.key,
    required this.locationId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModPageState();
}

class _AddModPageState extends ConsumerState<AddModPage> {
  late TextEditingController newModController =
      TextEditingController(); // Controller for moderator's email input

  @override
  void dispose() {
    super.dispose();
    newModController.dispose(); // Dispose to avoid memory leaks
  }

  void clearFields() {
    newModController.clear(); // Clears the text field
  }

  void saveNewMod(
    LocationModel location,
    TextEditingController emailController,
    WidgetRef ref,
  ) async {
    final email = emailController.text
        .trim()
        .toLowerCase(); // Trim and lowercase input for consistency

    // Get user model based on email
    final UserModel? user =
        await ref.read(getUserByEmailProvider(email).future);

    if (user != null) {
      String newModId = user.uid; // Obtain the UID from the UserModel

      // Update the location with the new moderator
      ref.read(locationsControllerProvider.notifier).editLocation(
            newModId: newModId,
            newLocationDetails: null,
            newAmenities: null,
            location: location,
            context: context,
          );

      clearFields(); // Clear the fields after successful operation
    } else {
      // If user not found, display error message
      showSnackBar(context,
          'User not found. Please check the email address and try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ref.watch(getLocationByIdProvider(widget.locationId)).when(
              data: (location) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Moderators',
                      style: Constants.heading1), // Heading text
                  // Add moderator section.
                  const Text('Add Moderator', style: Constants.heading3),
                  CustomTextField(
                      controller: newModController, hintText: 'Enter email'),
                  const SizedBox(height: 10),
                  Center(
                      child: CustomButton(
                    onTap: () => saveNewMod(location, newModController,
                        ref), // Save the new moderator
                    text: 'Add Moderator',
                  )),
                  const SizedBox(height: 20),
                  // Display all current moderators
                  const Text('Current Moderators', style: Constants.heading3),
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          location.moderators.length, // Number of moderators
                      itemBuilder: (context, index) {
                        final modList = location.moderators.toList();
                        final modId = modList[index];

                        return ref.watch(getUserDataProvider(modId)).when(
                              data: (user) {
                                return ListTile(
                                  title: Text(
                                      user.email), // Display moderator's email
                                );
                              },
                              error: ((error, stackTrace) => ErrorText(
                                  error: error.toString())), // Error handling
                              loading: () =>
                                  Container(), // Loading indicator while user data is loading
                            );
                      },
                    ),
                  ),
                ],
              ),
              error: (error, stackTrace) => ErrorText(
                  error:
                      error.toString()), // Error handling on loading location
              loading: () =>
                  const Loader(), // Loading indicator while location data is loading
            ),
      ),
    );
  }
}
