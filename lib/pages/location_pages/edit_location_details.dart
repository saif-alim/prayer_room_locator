import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/common/error_text.dart';
import 'package:prayer_room_locator/utils/common/loader.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/locations/locations_controller.dart';
import 'package:prayer_room_locator/locations/location_model.dart';
import 'package:routemaster/routemaster.dart';

class EditLocationDetails extends ConsumerStatefulWidget {
  final String id;
  const EditLocationDetails({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditLocationDetailsState();
}

class _EditLocationDetailsState extends ConsumerState<EditLocationDetails> {
  final locationDetailsController = TextEditingController();

  bool _female = false;
  bool _wudhu = false;
  bool _parking = false;
  bool _mosque = false;
  bool _mfc = false;

  @override
  void dispose() {
    super.dispose();
    locationDetailsController.dispose();
  }

  void clearFields() {
    locationDetailsController.clear();
  }

  void saveNewDetails(
      LocationModel location, TextEditingController detailsController) {
    // Initialise list of amenities
    List<String>? amenities = [];
    String? details = detailsController.text.trim();
    // Add the amenities that were ticked into the list
    if (_mosque) amenities.add("mosque");
    if (_mfc) amenities.add("mfc");
    if (_female) amenities.add("female");
    if (_wudhu) amenities.add("wudhu");
    if (_parking) amenities.add("parking");

    // If the user makes no changes, the previous information will not change
    if (amenities.isEmpty) {
      amenities = null;
    }
    if (details.isEmpty) {
      details = null;
    }

    ref.read(locationsControllerProvider.notifier).editLocation(
          newLocationDetails: details,
          location: location,
          newModId: null,
          newAmenities: amenities,
          context: context,
        );
    clearFields();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getLocationByIdProvider(widget.id)).when(
          data: (location) => Scaffold(
            appBar: const CustomAppBar(),
            drawer: const CustomDrawer(),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Text(
                    'Edit Details:',
                    style: Constants.heading1,
                  ),
                  Text(
                    location.name,
                    style: Constants.heading2,
                  ),
                  const SizedBox(height: 20),
                  // current
                  const Text(
                    'Current Location Details:',
                    style: Constants.heading4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Text(location.details),
                  ),
                  const SizedBox(height: 20),

                  // new
                  const Text(
                    'Edit Location Details:',
                    style: Constants.heading4,
                  ),
                  CustomTextField(
                    controller: locationDetailsController,
                    hintText: 'New Location Details',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  // Amenities
                  const Text(
                    'Edit Amenities:',
                    style: Constants.heading4,
                  ),

                  const Text(
                      "Tick the amenities that are available at the location.",
                      style: Constants.subtitle),
                  CheckboxListTile(
                    value: _mosque,
                    onChanged: (bool? value) {
                      setState(() {
                        _mosque = value!;
                      });
                    },
                    title: const Text("Mosque"),
                  ),
                  CheckboxListTile(
                    value: _mfc,
                    onChanged: (bool? value) {
                      _mfc = value!;
                    },
                    title: const Text("Multi-Faith Centre"),
                  ),
                  CheckboxListTile(
                    value: _female,
                    onChanged: (bool? value) {
                      _female = value!;
                    },
                    title: const Text("Women's Area"),
                  ),
                  CheckboxListTile(
                    value: _wudhu,
                    onChanged: (bool? value) {
                      setState(() {
                        _wudhu = value!;
                      });
                    },
                    title: const Text("Wudhu Area"),
                  ),
                  CheckboxListTile(
                    value: _parking,
                    onChanged: (bool? value) {
                      setState(() {
                        _parking = value!;
                      });
                    },
                    title: const Text("Parking"),
                  ),
                  CustomButton(
                    onTap: () {
                      // logic to save changes
                      saveNewDetails(location, locationDetailsController);
                      Routemaster.of(context).pop();
                    },
                    text: 'Save Changes',
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
