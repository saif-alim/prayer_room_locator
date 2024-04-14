import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/common/loader.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/data/locations/locations_controller.dart';

class AddLocationPage extends ConsumerStatefulWidget {
  const AddLocationPage({super.key});

  @override
  ConsumerState<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends ConsumerState<AddLocationPage> {
  final locationNameController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final detailsController = TextEditingController();

  bool _female = false;
  bool _wudhu = false;
  bool _parking = false;
  bool _mosque = false;
  bool _mfc = false;

  @override
  void dispose() {
    super.dispose();
    locationNameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    detailsController.dispose();
  }

  void addLocation() {
    // Initialise list of amenities
    List<String> amenities = [];
    // Add the amenities that were ticked into the list
    if (_mosque) amenities.add("mosque");
    if (_mfc) amenities.add("mfc");
    if (_female) amenities.add("female");
    if (_wudhu) amenities.add("wudhu");
    if (_parking) amenities.add("parking");

    ref.read(locationsControllerProvider.notifier).addLocation(
          latitude: double.parse(
              latitudeController.text.trim()), // Trim extra characters
          longitude: double.parse(longitudeController.text.trim()),
          name: locationNameController.text.trim(),
          details: detailsController.text.trim(),
          amenities: amenities, // Assign the amenities list to the location
          context: context,
        );
  }

  // clear text fields
  void clearFields() {
    locationNameController.clear();
    latitudeController.clear();
    longitudeController.clear();
    detailsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(locationsControllerProvider);
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Want to add your prayer space?',
                        style: Constants.heading1),
                    const SizedBox(height: 5),
                    const Text(
                      'Submit the location\'s details here and we\'ll be in touch to verify',
                      style: Constants.subtitle,
                    ),
                    const SizedBox(height: 5),
                    const Text('Name:', style: Constants.heading4),

                    //
                    CustomTextField(
                      controller: locationNameController,
                      hintText: 'Name',
                    ),
                    const SizedBox(height: 10),
                    //
                    const Text(
                      'Coordinates:',
                      style: Constants.heading4,
                    ),
                    CustomTextField(
                      controller: latitudeController,
                      hintText: 'Latitude',
                      numbersOnly: true,
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      controller: longitudeController,
                      hintText: 'Longitude',
                      numbersOnly: true,
                    ),
                    //
                    const Text(
                      'Details:',
                      style: Constants.heading4,
                    ),
                    CustomTextField(
                      controller: detailsController,
                      hintText: 'Extra Details',
                      maxLines: 3,
                    ),
                    const Text(
                      'Amenities:',
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
                    Center(
                      child: CustomButton(
                          onTap: () {
                            addLocation();
                            clearFields();
                          },
                          text: 'submit'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
