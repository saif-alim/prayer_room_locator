import 'package:flutter/material.dart';

class Constants {
  // Image paths
  static const logoPath = 'assets/images/circleLogo.png';
  static const googlePath = 'assets/images/google.png';
  static const loginEmotePath = 'assets/images/mosque.png';
  static const locationIconPath = 'assets/images/locationIcon.png';

  static const femaleIconPath = 'assets/anemities/female.png';
  static const parkingIconPath = 'assets/anemities/parking.png';
  static const wudhuIconPath = 'assets/anemities/wudhu.png';

  // Default Images
  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

  // titles and IDs
  static const alimID = 'W0ZUrExYqNgWdH20DjZlOsPEDgB2';
  static const hijra = 'هِجْرَة';
  static const Set<String> initialModSet = {alimID};

  // Text Styles
  static const heading1 = TextStyle(fontSize: 40, fontWeight: FontWeight.bold);
  static const heading2 = TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
  static const heading3 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
}

class FirebaseConstants {
  static const usersCollection = 'users';
  static const locationsCollection = 'locations';
  static const commentsCollection = 'comments';
}
