import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/core/common/custom_widgets.dart';
import 'package:prayer_room_locator/core/common/error_text.dart';
import 'package:prayer_room_locator/core/common/loader.dart';
import 'package:prayer_room_locator/core/constants/constants.dart';
import 'package:prayer_room_locator/features/auth/auth_controller.dart';
import 'package:prayer_room_locator/locations/locations_controller.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Moderators', style: Constants.heading1),
          Expanded(
            child: ref.watch(getLocationByIdProvider(widget.locationId)).when(
                  data: (location) => ListView.builder(
                    itemCount: location.moderators.length,
                    itemBuilder: (context, index) {
                      final modList = location.moderators.toList();
                      final modId = modList[index];

                      return ref.watch(getUserDataProvider(modId)).when(
                            data: (user) {
                              return ListTile(
                                title: Text(user.name),
                              );
                            },
                            error: ((error, stackTrace) =>
                                ErrorText(error: error.toString())),
                            loading: () => const Loader(),
                          );
                    },
                  ),
                  error: ((error, stackTrace) =>
                      ErrorText(error: error.toString())),
                  loading: () => const Loader(),
                ),
          )
        ],
      ),
    );
  }
}
