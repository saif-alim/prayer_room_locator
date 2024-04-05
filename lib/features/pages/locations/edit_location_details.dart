import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/core/common/custom_widgets.dart';
import 'package:prayer_room_locator/core/common/error_text.dart';
import 'package:prayer_room_locator/core/common/loader.dart';
import 'package:prayer_room_locator/core/common/utils.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/locations/locations_controller.dart';

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
  File? imageFile;

  @override
  void dispose() {
    super.dispose();
    locationDetailsController.dispose();
  }

  void clearFields() {
    locationDetailsController.clear();
  }

  void addImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        imageFile = File(res.files.first.path!);
      });
    }
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
                  const Text('New Location Details:'),
                  CustomTextField(
                    controller: locationDetailsController,
                    hintText: 'New Location Details',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    onTap: () {
                      // logic to save changes
                      // location.details = locationDetailsController.text;
                    },
                    text: 'Save Changes',
                  ),
                ],
              ),
            ),
          ),
          error: ((error, stackTrace) => ErrorText(error: error.toString())),
          loading: () => const Loader(),
        );
  }
}
