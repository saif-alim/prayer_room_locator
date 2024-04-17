import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:routemaster/routemaster.dart';

// Custom App Bar Widget
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Hijra',
        style: Constants.appTitle,
      ),
      centerTitle: true,
    );
  }
}

// Custom Drawer Widget
class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(children: [
        DrawerHeader(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    Constants.logoPath,
                    height: 50,
                  ),
                ),
                const Text(
                  'Hijra  ', // Use of Arabic name in a styled text
                  style: Constants.appTitle,
                ),
              ],
            ),
          ),
        ),
        ListTile(
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.black), // Home menu item
          ),
          onTap: () {
            Routemaster.of(context).push('/'); // Navigation to home
            Routemaster.of(context).pop(); // Close drawer after navigation
          },
        ),
        ListTile(
          title: const Text('List View'), // List View menu item
          onTap: () {
            Routemaster.of(context)
                .push('/listview'); // Navigation to list view
            Routemaster.of(context).pop();
          },
        ),
        ListTile(
          title: const Text('Profile'), // Profile menu item
          onTap: () {
            Routemaster.of(context).push('/profile'); // Navigation to profile
            Routemaster.of(context).pop();
          },
        ),
      ]),
    );
  }
}

// Custom Text Field Widget
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool numbersOnly;
  final bool isPass;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.numbersOnly = false,
    this.isPass = false,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPass;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscureText,
      controller: widget.controller,
      maxLines: widget.maxLines,
      keyboardType: widget.numbersOnly
          ? const TextInputType.numberWithOptions(decimal: true, signed: true)
          : null, // Conditionally set the keyboard type for numeric input
      inputFormatters: widget.numbersOnly
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^-?(\d+)?\.?\d{0,10}'))
            ]
          : null, // Allow numeric input with optional negative and decimal values
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: const Color(0xffF5F6FA),
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: widget.isPass
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: Icon(
                    // Toggle icon based on visibility
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                )
              : null),
    );
  }
}

// Custom Button Widget
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
  });
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(250, 40),
        maximumSize: const Size(250, 40),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Tiles for Amenities Gridview Widget
class AmenitiesTile extends StatelessWidget {
  const AmenitiesTile({
    super.key,
    required this.amenityType,
  });

  final String amenityType;

  @override
  Widget build(BuildContext context) {
    String imagePath;
    String title;

    // Determines the image and title based on the type of amenity
    if (amenityType == 'wudhu') {
      imagePath = Constants.wudhuIconPath;
      title = 'wudhu area';
    } else if (amenityType == 'female') {
      imagePath = Constants.femaleIconPath;
      title = 'women\'s area';
    } else if (amenityType == 'parking') {
      imagePath = Constants.parkingIconPath;
      title = 'parking';
    } else if (amenityType == 'mosque') {
      imagePath = Constants.mosqueIconPath;
      title = 'mosque';
    } else if (amenityType == 'mfc') {
      imagePath = Constants.mfcIconPath;
      title = 'multi-faith centre';
    } else {
      imagePath = '';
      title = '';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 40,
            ),
            Align(alignment: Alignment.center, child: Text(title)),
          ],
        ),
      ),
    );
  }
}
