import 'package:flutter/material.dart';

// Class to hold constants
class Constants {
  // Path to logos and icons
  static const logoPath = 'assets/images/hijraLogo.png';
  static const googlePath = 'assets/images/google.png';
  static const locationIconPath = 'assets/images/locationIcon.png';

  // Paths to amenities icons
  static const femaleIconPath = 'assets/anemities/female.png';
  static const parkingIconPath = 'assets/anemities/parking.png';
  static const wudhuIconPath = 'assets/anemities/wudhu.png';
  static const mosqueIconPath = 'assets/anemities/mosque.png';
  static const mfcIconPath = 'assets/anemities/mfc.png';

  // Static IDs for special users or roles
  static const globalMod = 'W0ZUrExYqNgWdH20DjZlOsPEDgB2';
  static const hijra = 'هِجْرَة';
  static const Set<String> initialModSet = {globalMod};

  // Text Styles used throughout the app
  static const heading1 = TextStyle(fontSize: 40, fontWeight: FontWeight.bold);
  static const heading2 = TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
  static const heading3 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const heading4 = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const subtitle = TextStyle(fontWeight: FontWeight.w300);
}

// Class to hold constants related to Firebase collections
class FirebaseConstants {
  static const usersCollection = 'users';
  static const locationsCollection = 'locations';
  static const commentsCollection = 'comments';
  static const ratingsCollection = 'ratings';
}
