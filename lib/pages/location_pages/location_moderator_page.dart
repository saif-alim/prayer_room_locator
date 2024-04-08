import 'package:flutter/material.dart';
import 'package:prayer_room_locator/utils/common/custom_widgets.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:routemaster/routemaster.dart';

class LocationModeratorPage extends StatelessWidget {
  final String id;
  const LocationModeratorPage({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Moderator Tools', style: Constants.heading1),
            ListTile(
              leading: const Icon(Icons.add_moderator),
              title: const Text('Add Moderators'),
              onTap: () {
                //navigation logic
                Routemaster.of(context).push('/add-moderators/$id');
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Location Details'),
              onTap: () {
                // navigation logic
                Routemaster.of(context).push('/edit-location/$id');
              },
            ),
          ],
        ),
      ),
    );
  }
}
