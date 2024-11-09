import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../setting_page.dart';

class SettingsController extends GetxController {
  var showLogo = true.obs;
  var showLocation = true.obs;
  var showDateTime = true.obs;
  var showDB = true.obs;
  var showLB = true.obs;

  late Size containerSize = Size.zero;
  // Color properties
  var dateTextColor = Colors.white.obs;
  var locationTextColor = Colors.white.obs;

  // Background color properties
  var dBackgroundColor = Colors.white.obs;
  var lBackgroundColor = Colors.white.obs;

  var logoImagePath = ''.obs; // To store the path of the logo image
  var isLoading = false.obs; // Loading state for the image

  // Positions and sizes
   var datePosition = Offset(100, 100).obs;
  var locationPosition = Offset(100, 300).obs;
  var logoPosition = Offset(100, 300).obs;
  var logoSize = 60.0.obs;
  var dateFontSize = 20.0.obs;
  var locationFontSize = 20.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPreferences(); // Load the preferences when the controller initializes
  }
  @override
  void onClose() {
    super.onClose();
    // Save positions when the controller is disposed
    saveDatePosition(datePosition.value);
    saveLocationPosition(locationPosition.value);
    saveLogoPosition(logoPosition.value);
  }

  Future<void> _loadPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      showLogo.value = prefs.getBool('showLogo') ?? true;
      showLocation.value = prefs.getBool('showLocation') ?? true;
      showDateTime.value = prefs.getBool('showDateTime') ?? true;
      showDB.value = prefs.getBool('showDB') ?? true;
      showLB.value = prefs.getBool('showLB') ?? true;

      dateTextColor.value = Color(prefs.getInt('dateTextColor') ?? Colors.white.value);
      locationTextColor.value = Color(prefs.getInt('locationTextColor') ?? Colors.white.value);
      dBackgroundColor.value = Color(prefs.getInt('dBackgroundColor') ?? Colors.white.value);
      lBackgroundColor.value = Color(prefs.getInt('lBackgroundColor') ?? Colors.white.value);

      // Load position values with fallback to default values
      double datePositionX = prefs.getDouble('datePositionX') ?? 100;
      double datePositionY = prefs.getDouble('datePositionY') ?? 100;
      datePosition.value = Offset(datePositionX, datePositionY);

      double locationPositionX = prefs.getDouble('locationPositionX') ?? 100;
      double locationPositionY = prefs.getDouble('locationPositionY') ?? 200;
      locationPosition.value = Offset(locationPositionX, locationPositionY);

      double logoPositionX = prefs.getDouble('logoPositionX') ?? 100;
      double logoPositionY = prefs.getDouble('logoPositionY') ?? 300;
      logoPosition.value = Offset(logoPositionX, logoPositionY);

      logoSize.value = prefs.getDouble('logoSize') ?? 60.0;
      dateFontSize.value = prefs.getDouble('dateFontSize') ?? 20.0;
      locationFontSize.value = prefs.getDouble('locationFontSize') ?? 20.0;
    } catch (e) {
      // Handle errors (e.g., log them or show a message)
      print("Error loading preferences: $e");
    }
    print("Date Position: ($datePosition, $datePosition)");
    print("Location Position: ($locationPosition, $locationPosition)");
    print("Logo Position: ($logoPosition, $logoPosition)");

  }

   Future<void> savePreference(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  // Methods to save positions
  void saveDatePosition(Offset position) {
    datePosition.value = position;
    savePreference('datePositionX', position.dx);
    savePreference('datePositionY', position.dy);
  }

  void saveLocationPosition(Offset position) {
    locationPosition.value = position;
    savePreference('locationPositionX', position.dx);
    savePreference('locationPositionY', position.dy);
  }

  void saveLogoPosition(Offset position) {
    logoPosition.value = position;
    savePreference('logoPositionX', position.dx);
    savePreference('logoPositionY', position.dy);
  }

  // Method to pick an image from the gallery
  Future<void> pickLogoImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      isLoading.value = true; // Set loading to true
      logoImagePath.value = image.path;
      await savePreference('logoImagePath', image.path); // Save the path
      isLoading.value = false; // Set loading to false after loading

    }update();
  }

  void removeLogoImage() {
    logoImagePath.value = ''; // Reset to default asset
    update();
  }

  // Toggle visibility methods
  void toggleLogoVisibility(bool value) {
    showLogo.value = value;
    savePreference('showLogo', value);
    update();
  }

  void toggleLocationVisibility(bool value) {
    showLocation.value = value;
    savePreference('showLocation', value);
    update();
  }

  void toggleDateTimeVisibility(bool value) {
    showDateTime.value = value;
    savePreference('showDateTime', value);
    update();
  }

  void toggleDatebVisibility(bool value) {
    showDB.value = value;
    savePreference('showDB', value);
    update();
  }

  void toggleLocbVisibility(bool value) {
    showLB.value = value;
    savePreference('showLB', value);
    update();
  }

  // Update text colors
  void updateDateTextColor(Color color) {
    dateTextColor.value = color;
    savePreference('dateTextColor', color.value);
    update();
  }

  void updateLocationTextColor(Color color) {
    locationTextColor.value = color;
    savePreference('locationTextColor', color.value);
    update();
  }

  // Update background colors
  void updatedBackgroundColor(Color color) {
    dBackgroundColor.value = color;
    savePreference('dBackgroundColor', color.value);
    update();
  }

  void updatelBackgroundColor(Color color) {
    lBackgroundColor.value = color;
    savePreference('lBackgroundColor', color.value);
    update();
  }

  var toggleSelections = [true, false].obs;  // Default: Option 1 selected

  void updateToggleSelection(int index) {
    for (int i = 0; i < toggleSelections.length; i++) {
      toggleSelections[i] = i == index;
    }
    update();
  }
}


