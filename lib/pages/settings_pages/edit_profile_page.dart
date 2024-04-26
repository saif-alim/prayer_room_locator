import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/data/auth/auth_controller.dart';
import 'package:prayer_room_locator/data/auth/user_model.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';

// Class to let user edit profile details
class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final nameController =
      TextEditingController(); // Controller for display name text field

  // Method to save updated details
  void saveNewDetails(UserModel user) {
    final newDisplayName = nameController.text.trim();

    ref.read(authControllerProvider.notifier).editLocation(
        newDisplayName: newDisplayName, user: user, context: context);
  }

  @override
  void dispose() {
    nameController.dispose(); // Dispose to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider)!; // Get current user UserModel
    return Scaffold(
        appBar: const CustomAppBar(),
        drawer: const CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Text('Edit Profile', style: Constants.heading1),
              const Text(
                  'Edit user details by filling in the desired details and pressing submit.',
                  style: Constants.subtitle),
              const SizedBox(height: 20),
              const Text('Current Display Name:', style: Constants.heading3),
              Text(user.name, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              const Text('New Display Name:', style: Constants.heading3),
              CustomTextField(
                  controller: nameController,
                  hintText: 'Enter new display name'),
              const SizedBox(height: 20),
              CustomButton(onTap: () => saveNewDetails(user), text: 'Save')
            ],
          ),
        ));
  }
}
