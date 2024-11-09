

import 'package:dcamera_application/default_position.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'controller/setting_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:io';
import 'mysaved.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    void _selectLogoImage() {
      settingsController.pickLogoImage();
    }

    void _removeLogoImage() {
      settingsController.removeLogoImage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GetBuilder<SettingsController>(builder: (contextx) {
          return ListView(
            children: [
              SizedBox(height: 20),
              ListTile(
                title: Text(
                  'My Saved',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                trailing: Icon(Icons.bookmark_rounded),
                onTap: () {
                  Get.to(ImageGalleryScreen());
                },
              ),
              SizedBox(height: 10),
              _buildCard(
                context,
                title: 'Logo',
                value: settingsController.showLogo.value,
                onChanged: (value) {
                  settingsController.toggleLogoVisibility(value);
                },
                child: Column(
                  children: [
                    if (settingsController.showLogo.value)
                      Stack(
                        children: [
                          if (settingsController.isLoading.value)
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(color: Colors.black),
                            )
                          else if (settingsController.logoImagePath.value.isNotEmpty)
                            Image.file(
                              File(settingsController.logoImagePath.value),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          else
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/logo.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Default Logo',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          if (settingsController.logoImagePath.value.isNotEmpty)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                onPressed: _removeLogoImage,
                                tooltip: 'Remove Logo Image',
                              ),
                            ),
                        ],
                      ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      icon: Icon(Icons.upload_file),
                      label: Text('Upload Logo'),
                      onPressed: _selectLogoImage,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ), backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _buildSwitchTile('Date', settingsController.showDateTime.value, (value) {
                settingsController.toggleDateTimeVisibility(value);
              }),
              if (settingsController.showDateTime.value)
                _buildColorTile(
                  title: "Date Color",
                  color: settingsController.dateTextColor.value,
                  onTap: () {
                    _showColorPicker(context, ColorType.date);
                  },
                ),
              SizedBox(height: 10),
              _buildSwitchTile('Location', settingsController.showLocation.value, (value) {
                settingsController.toggleLocationVisibility(value);
              }),
              if (settingsController.showLocation.value)
                _buildColorTile(
                  title: "Location Color",
                  color: settingsController.locationTextColor.value,
                  onTap: () {
                    _showColorPicker(context, ColorType.location);
                  },
                ),
              SizedBox(height: 10),
              _buildSwitchTile('Show Date Background', settingsController.showDB.value, (value) {
                settingsController.toggleDatebVisibility(value);
              }),
              if (settingsController.showDB.value)
                _buildColorTile(
                  title: "Date Background Color",
                  color: settingsController.dBackgroundColor.value,
                  onTap: () {
                    _showColorPicker(context, ColorType.topBackground);
                  },
                ),
              SizedBox(height: 10),
              _buildSwitchTile('Show Location Background', settingsController.showLB.value, (value) {
                settingsController.toggleLocbVisibility(value);
              }),
              if (settingsController.showLB.value)
                _buildColorTile(
                  title: "Location Background Color",
                  color: settingsController.lBackgroundColor.value,
                  onTap: () {
                    _showColorPicker(context, ColorType.bottomBackground);
                  },
                ),
              SizedBox(height: 20),
              ListTile(
                title: Text(
                  "Default Position",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
                onTap: () {
                  Get.to(DefaultPositionScreen());
                },
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          SwitchListTile(
            title: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            value: value,
            activeColor: Colors.blueAccent,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.4),
            onChanged: onChanged,
          ),
          if (value) child,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        value: value,
        activeColor: Colors.blueAccent,
        inactiveThumbColor: Colors.grey,
        inactiveTrackColor: Colors.grey.withOpacity(0.4),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildColorTile({
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context, ColorType colorType) {
    Color currentColor;
    switch (colorType) {
      case ColorType.date:
        currentColor = settingsController.dateTextColor.value;
        break;
      case ColorType.location:
        currentColor = settingsController.locationTextColor.value;
        break;
      case ColorType.topBackground:
        currentColor = settingsController.dBackgroundColor.value;
        break;
      case ColorType.bottomBackground:
        currentColor = settingsController.lBackgroundColor.value;
        break;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Select Color',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorPicker(
                  pickerColor: currentColor,
                  onColorChanged: (color) {
                    switch (colorType) {
                      case ColorType.date:
                        settingsController.updateDateTextColor(color);
                        break;
                      case ColorType.location:
                        settingsController.updateLocationTextColor(color);
                        break;
                      case ColorType.topBackground:
                        settingsController.updatedBackgroundColor(color);
                        break;
                      case ColorType.bottomBackground:
                        settingsController.updatelBackgroundColor(color);
                        break;
                    }
                  },
                  showLabel: true,
                  pickerAreaHeightPercent: 0.7,
                ),
                SizedBox(height: 10),
                Text(
                  'Current Color',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 100,
                  height: 50,
                  color: currentColor,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Close', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }
}

enum ColorType { date, location, topBackground, bottomBackground }

