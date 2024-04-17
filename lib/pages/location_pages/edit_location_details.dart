import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/error-handling/error_text.dart';
import 'package:prayer_room_locator/utils/common/loader.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/data/locations/locations_controller.dart';
import 'package:prayer_room_locator/data/locations/location_model.dart';
import 'package:routemaster/routemaster.dart';

// Class to edit the details of a location
class EditLocationDetails extends ConsumerStatefulWidget {
  final String id; // ID of the location to edit
  const EditLocationDetails({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditLocationDetailsState();
}

class _EditLocationDetailsState extends ConsumerState<EditLocationDetails> {
  final locationDetailsController =
      TextEditingController(); // Controller for location details input field

  // Boolean flags for amenities
  bool _female = false;
  bool _wudhu = false;
  bool _parking = false;
  bool _mosque = false;
  bool _mfc = false;

  @override
  void dispose() {
    locationDetailsController.dispose(); // Dispose to avoid memory leaks
    super.dispose();
  }

  void clearFields() {
    locationDetailsController.clear(); // Clears input field
  }

  // Function to save updated location details
  void saveNewDetails(LocationModel location) {
    List<String>? amenities = [];
    if (_mosque) amenities.add("mosque");
    if (_mfc) amenities.add("mfc");
    if (_female) amenities.add("female");
    if (_wudhu) amenities.add("wudhu");
    if (_parking) amenities.add("parking");

    String? details =
        locationDetailsController.text.trim(); // Trim the text for consistency
    if (details.isEmpty) {
      details = null; // No update if no details are entered
    }
    if (amenities.isEmpty) {
      amenities = null; // No update if no amenities were modified
    }

    // Update location details
    ref.read(locationsControllerProvider.notifier).editLocation(
          newLocationDetails: details,
          location: location,
          newModId: null,
          newAmenities: amenities,
          context: context,
        );
    clearFields(); // Clear fields after updating
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ref.watch(getLocationByIdProvider(widget.id)).when(
              data: (location) => ListView(
                children: [
                  const Text('Edit Details:',
                      style: Constants.heading1), // Heading
                  Text(location.name,
                      style: Constants.heading2), // Displays location name
                  const SizedBox(height: 20),
                  const Text('Current Location Details:',
                      style: Constants.heading4), // Current details section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Text(location.details), // Displays current details
                  ),
                  const SizedBox(height: 20),
                  const Text('Edit Location Details:',
                      style: Constants.heading4), // Section for editing details
                  CustomTextField(
                    controller: locationDetailsController,
                    hintText: 'New Location Details',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  const Text('Edit Amenities:',
                      style: Constants.heading4), // Amenities section
                  CheckboxListTile(
                    value: _mosque,
                    onChanged: (bool? value) {
                      _mosque = value!;
                    },
                    title: const Text("Mosque"), // Checkbox for mosque amenity
                  ),
                  CheckboxListTile(
                    value: _mfc,
                    onChanged: (bool? value) {
                      _mfc = value!;
                    },
                    title: const Text(
                        "Multi-Faith Centre"), // Checkbox for MFC amenity.
                  ),
                  CheckboxListTile(
                    value: _female,
                    onChanged: (bool? value) {
                      _female = value!;
                    },
                    title: const Text(
                        "Women's Area"), // Checkbox for women's area.
                  ),
                  CheckboxListTile(
                    value: _wudhu,
                    onChanged: (bool? value) {
                      setState(() {
                        _wudhu = value!;
                      });
                    },
                    title: const Text("Wudhu Area"), // Checkbox for wudhu area.
                  ),
                  CheckboxListTile(
                    value: _parking,
                    onChanged: (bool? value) {
                      setState(() {
                        _parking = value!;
                      });
                    },
                    title: const Text("Parking"), // Checkbox for parking.
                  ),
                  CustomButton(
                    onTap: () {
                      saveNewDetails(location); // Save changes
                      Routemaster.of(context)
                          .pop(); // Navigate back after saving
                    },
                    text: 'Save Changes',
                  ),
                ],
              ),

              error: (error, stackTrace) =>
                  ErrorText(error: error.toString()), // Displays error
              loading: () =>
                  const Loader(), // Show loading indicator while fetching data
            ),
      ),
    );
  }
}
