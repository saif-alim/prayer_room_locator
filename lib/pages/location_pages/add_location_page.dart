import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/common/loader.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/data/locations/locations_controller.dart';
import 'package:prayer_room_locator/utils/coordinates_help_dialog.dart';

// Class to add a new location
class AddLocationPage extends ConsumerStatefulWidget {
  const AddLocationPage({super.key});

  @override
  ConsumerState<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends ConsumerState<AddLocationPage> {
  // Text controllers to capture input from text fields
  final locationNameController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final detailsController = TextEditingController();

  // State variables for amenities checkboxes
  bool _female = false;
  bool _wudhu = false;
  bool _parking = false;
  bool _mosque = false;
  bool _mfc = false;

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    locationNameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  // Function to handle the submission of a new location
  void addLocation() {
    List<String> amenities = [];
    if (_mosque) amenities.add("mosque");
    if (_mfc) amenities.add("mfc");
    if (_female) amenities.add("female");
    if (_wudhu) amenities.add("wudhu");
    if (_parking) amenities.add("parking");

    // Use the locations controller to add location with given details and amenities
    ref.read(locationsControllerProvider.notifier).addLocation(
          latitude: double.parse(latitudeController.text.trim()),
          longitude: double.parse(longitudeController.text.trim()),
          name: locationNameController.text.trim(),
          details: detailsController.text.trim(),
          amenities: amenities,
          context: context,
        );
  }

  // Function to clear all input fields
  void clearFields() {
    locationNameController.clear();
    latitudeController.clear();
    longitudeController.clear();
    detailsController.clear();
  }

  // Method to build checkbox list tiles
  Widget _buildCheckboxListTile(
      String title, bool value, void Function(bool?) onChanged) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(locationsControllerProvider); // loading state to manage UI

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: isLoading
          ? const Loader() // Loading indicator
          : Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(), // Smooth scrolling effect
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Want to add your prayer space?',
                        style: Constants.heading1), // Heading text
                    const SizedBox(height: 5),
                    const Text(
                        'Submit the location\'s details here and we\'ll be in touch to verify',
                        style: Constants.subtitle), // Subtitle text
                    const SizedBox(height: 5),
                    const Text('Name:',
                        style: Constants.heading4), // Location name field
                    CustomTextField(
                        controller: locationNameController,
                        hintText: 'Location Name'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Coordinates:', style: Constants.heading4),
                        IconButton(
                            onPressed: () {
                              CoordinatesHelpDialog(context: context).show();
                            },
                            icon: const Icon(
                              Icons.help_outline,
                              color: Color.fromARGB(255, 5, 132, 195),
                            ))
                      ],
                    ), // Coordinates fields
                    CustomTextField(
                        controller: latitudeController,
                        hintText: 'Latitude',
                        numbersOnly: true),
                    const SizedBox(height: 10),
                    CustomTextField(
                        controller: longitudeController,
                        hintText: 'Longitude',
                        numbersOnly: true),
                    const Text('Details:',
                        style: Constants.heading4), // Additional details fields
                    CustomTextField(
                        controller: detailsController,
                        hintText: 'Extra Details',
                        maxLines: 3),
                    const Text('Amenities:',
                        style:
                            Constants.heading4), // Amenities checkbox section
                    const Text(
                        "Tick the amenities that are available at the location.",
                        style: Constants
                            .subtitle), // Instructions for checking amenities
                    _buildCheckboxListTile('Mosque', _mosque, (bool? value) {
                      // Mosque amenity checkbox
                      _mosque = value!;
                    }),
                    _buildCheckboxListTile('Multi-Faith Centre',
                        _mfc, // Multi-faith centre checkbox
                        (bool? value) {
                      _mfc = value!;
                    }),
                    _buildCheckboxListTile(
                        "Women's Area", _female, // Women's area checkbox
                        (bool? value) {
                      _female = value!;
                    }),
                    _buildCheckboxListTile(
                        "Wudhu Area", _wudhu, // Wudhu area checkbox
                        (bool? value) {
                      setState(() {
                        _wudhu = value!;
                      });
                    }),
                    _buildCheckboxListTile(
                        "Parking", _parking, // Parking facilities checkbox
                        (bool? value) {
                      setState(() {
                        _parking = value!;
                      });
                    }),
                    Center(
                      child: CustomButton(
                          // Submit form button
                          onTap: () {
                            addLocation(); // Add location on button press
                            clearFields(); // Clear input fields after submission
                          },
                          text: 'Submit'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
