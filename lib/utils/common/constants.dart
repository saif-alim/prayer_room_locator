import 'package:flutter/material.dart';

class Constants {
  // Image paths
  static const logoPath = 'assets/images/hijraLogo.png';
  static const googlePath = 'assets/images/google.png';
  static const locationIconPath = 'assets/images/locationIcon.png';
  // Amenities
  static const femaleIconPath = 'assets/anemities/female.png';
  static const parkingIconPath = 'assets/anemities/parking.png';
  static const wudhuIconPath = 'assets/anemities/wudhu.png';
  static const mosqueIconPath = 'assets/anemities/mosque.png';
  static const mfcIconPath = 'assets/anemities/mfc.png';

  // titles and IDs
  static const alimID = 'W0ZUrExYqNgWdH20DjZlOsPEDgB2';
  static const hijra = 'هِجْرَة';
  static const Set<String> initialModSet = {alimID};

  // Text Styles
  static const heading1 = TextStyle(fontSize: 40, fontWeight: FontWeight.bold);
  static const heading2 = TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
  static const heading3 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const heading4 = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const subtitle = TextStyle(fontWeight: FontWeight.w300);
}

class FirebaseConstants {
  static const usersCollection = 'users';
  static const locationsCollection = 'locations';
  static const commentsCollection = 'comments';
  static const ratingsCollection = 'ratings';
}
