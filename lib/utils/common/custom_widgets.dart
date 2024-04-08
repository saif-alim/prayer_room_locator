import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prayer_room_locator/utils/common/constants.dart';
import 'package:routemaster/routemaster.dart';

// Custom App Bar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        Constants.hijra,
        style: TextStyle(fontSize: 30),
      ),
      centerTitle: true,
    );
  }
}

// Custom Drawer
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        const DrawerHeader(
          child: Center(
            child: Text(' ${Constants.hijra} \n Hijra',
                style: TextStyle(fontSize: 20)),
          ),
        ),
        ListTile(
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.black),
          ),
          onTap: () {
            Routemaster.of(context).push('/');
            Routemaster.of(context).pop();
          },
        ),
        ListTile(
          title: const Text('List View'),
          onTap: () {
            Routemaster.of(context).push('/listview');
            Routemaster.of(context).pop();
          },
        ),
        ListTile(
          title: const Text('Profile'),
          onTap: () {
            Routemaster.of(context).push('/profile');
            Routemaster.of(context).pop();
          },
        ),
      ]),
    );
  }
}

// Custom Text Field
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool numbersOnly;
  final int maxLines;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.numbersOnly = false,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: numbersOnly
          ? const TextInputType.numberWithOptions(decimal: true, signed: true)
          : null,
      inputFormatters: numbersOnly
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^-?(\d+)?\.?\d{0,10}'))
            ]
          : null,
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
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

// Custom Button
class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);
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
      child: Text(text),
    );
  }
}

// Enum to define the amenity types
enum AmenityType { wudhu, female, parking }

class AmenitiesTile extends StatelessWidget {
  const AmenitiesTile({
    Key? key,
    required this.amenityType,
  }) : super(key: key);

  final String amenityType;

  @override
  Widget build(BuildContext context) {
    String imagePath;

    if (amenityType == 'wudhu') {
      //
      imagePath = Constants.wudhuIconPath;
    } else if (amenityType == 'female') {
      //
      imagePath = Constants.femaleIconPath;
    } else if (amenityType == 'parking') {
      //
      imagePath = Constants.parkingIconPath;
    } else {
      imagePath = '';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 40,
            ),
            Text(amenityType),
          ],
        ),
      ),
    );
  }
}
