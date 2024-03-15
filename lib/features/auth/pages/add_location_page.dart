import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/core/common/custom_widgets.dart';
import 'package:prayer_room_locator/core/common/loader.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/repository/controller/locations_controller.dart';
import 'package:prayer_room_locator/widgets/custom_button.dart';
import 'package:prayer_room_locator/widgets/custom_textfield.dart';

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
        //

        locationNameController.text.trim(),
        detailsController.text.trim(),
        context);
  }

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
                  const SizedBox(height: 20),
                  //
                  CustomTextField(
                    controller: locationNameController,
                    hintText: 'Name',
                  ),
                  //
                  const Text('Coordinates:'),
                  CustomTextField(
                    controller: locationXController,
                    hintText: 'X Coordinate',
                    numbersOnly: true,
                  ),
                  CustomTextField(
                    controller: locationYController,
                    hintText: 'Y Coordinate',
                    numbersOnly: true,
                  ),
                  //
                  CustomTextField(
                    controller: detailsController,
                    hintText: 'Extra Details',
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
    );
  }
}
