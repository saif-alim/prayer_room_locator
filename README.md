# Hijra: A Prayer Space Locator

## Overview

Hijra is a mobile application developed using Flutter, designed to help users find prayer spaces in London. The app features an map view with interactive markers indicating the locations of various prayer spaces, and a list view displaying locations sorted by proximity. It offers users the ability to rate these spaces, view detailed information about each location, and navigate using their native map applications.

## Features/Pages

- **Interactive Map**: Displays prayer spaces in London with interactive markers.
- **List View**: Shows locations sorted by distance from the user.
- **User Ratings**: Allows users to rate locations from 1 to 5, displaying average ratings on location details pages.
- **Navigation Integration**: Option to launch the user's native map app for directions.
- **Amenities Overview**: Clear display of available amenities for easy visibility.
- **Location Requests**: Users can submit new locations. Locations are added after verification.
- **Moderation**: Designated moderators can edit location details and manage moderator roles.

## Installation Guide

### Direct Download Installation

To install the app onto an Android device, please download the application from the following link:
[Download Hijra](https://drive.google.com/file/d/1HdCWsT568HwYFWz41QOdtTwquW3rcpq2/view?usp=sharing)

### Manual Installation via Flutter

Alternatively, if you have Flutter installed on your computer, you can install the application by following these steps:

#### 1. Enable Developer Options and USB Debugging on the Android Device

- Unlock the Android device.
- Open the settings app.
- Scroll down to 'About Phone'.
- Tap on 'Build Number' multiple times until you see a message saying that "You are now a developer!".
- Go back to the main Settings menu, then go to System > Advanced > Developer Options.
- Find USB Debugging and enable it.

#### 2. Download the Source Code

- Download the source code from the GitHub repository onto a local computer.

#### 3. Connect Your Android Device

- Connect your Android device to your computer using a USB cable.
- Ensure your device is detected by typing `flutter devices` in the terminal. Verify that your device is listed in the output.

#### 4. Navigate to the Project's Directory in the Terminal

- Navigate to the directory where the source code is located:
  ```bash
  cd path/to/prayer_room_locator
  ```

#### 5. Install the Application\*\*

- Install the app by running:
  ```bash
  flutter build apk --release
  flutter install
  ```
