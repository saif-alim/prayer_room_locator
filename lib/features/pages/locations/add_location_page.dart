import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/core/common/custom_widgets.dart';
import 'package:prayer_room_locator/core/common/loader.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/locations/locations_controller.dart';

class AddLocationPage extends ConsumerStatefulWidget {
  const AddLocationPage({super.key});

  @override
  ConsumerState<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends ConsumerState<AddLocationPage> {
  final locationNameController = TextEditingController();
  final locationXController = TextEditingController();
  final locationYController = TextEditingController();
  final detailsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    locationNameController.dispose();
    locationXController.dispose();
    locationYController.dispose();
    detailsController.dispose();
  }

  void addLocation() {
    ref.read(locationsControllerProvider.notifier).addLocation(
        //Coordinates
        double.parse(locationXController.text.trim()),
        double.parse(locationYController.text.trim()),

        //Trim extra characters
        locationNameController.text.trim(),
        detailsController.text.trim(),
        context);
  }

  // clear text fields
  void clearFields() {
    locationNameController.clear();
    locationXController.clear();
    locationYController.clear();
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
                    const SizedBox(
                      height: 80,
                    ),
                    const Text('Want to add your prayer space?',
                        style: Constants.heading1),
                    const SizedBox(height: 5),
                    const Text(
                        'Submit the details here and we\'ll be in touch to verify'),

                    //
                    CustomTextField(
                      controller: locationNameController,
                      hintText: 'Name',
                    ),
                    const SizedBox(height: 10),
                    //
                    const Text('Coordinates:'),
                    CustomTextField(
                      controller: locationXController,
                      hintText: 'Latitude',
                      numbersOnly: true,
                    ),
                    CustomTextField(
                      controller: locationYController,
                      hintText: 'Longitude',
                      numbersOnly: true,
                    ),
                    //
                    CustomTextField(
                      controller: detailsController,
                      hintText: 'Extra Details',
                      maxLines: 5,
                    ),
                    CustomButton(
                        onTap: () {
                          addLocation();
                          clearFields();
                        },
                        text: 'submit'),
                  ],
                ),
              ),
            ),
    );
  }
}
