// // import 'package:flutter/material.dart';
// //
// //
// //
// // class SettingPage extends StatelessWidget {
// //   final List<String> menuItems = [
// //     'My Saved',
// //     'Date and Time',
// //     'Location',
// //     'Logo'
// //   ];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('ListView Example'),
// //       ),
// //       body: ListView(
// //         children: [
// //           ListTile(
// //             leading: Icon(Icons.save),
// //             title: Text('My Saved'),
// //             onTap: () {
// //
// //             },
// //           ),
// //           ListTile(
// //             leading: Icon(Icons.access_time),
// //             title: Text('Date and Time'),
// //             trailing: Icon(Icons.arrow_forward_ios_outlined),
// //             onTap: () {
// //
// //             },
// //           ),
// //           ListTile(
// //             leading: Icon(Icons.location_on),
// //             title: Text('Location'),
// //             onTap: () {
// //               // Handle tap for Location
// //             },
// //           ),
// //           ListTile(
// //             leading: Icon(Icons.photo),
// //             title: Text('Logo'),
// //             onTap: () {
// //               // Handle tap for Logo
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// // import 'package:get/get.dart';
// // import 'controller/switch_controller.dart';
// //
// // class SettingPage extends StatelessWidget {
// //   final SettingsController settingsController = Get.put(SettingsController());
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Settings'),
// //       ),
// //       body: ListView(
// //         children: [
// //           Obx(() {
// //             // Wrap in Obx to listen for changes
// //             return SwitchListTile(
// //               title: Text('Logo'),
// //               value: settingsController.showLogo.value,
// //               onChanged: (value) {
// //                 settingsController.toggleLogoVisibility(value);
// //               },
// //             );
// //           }),
// //           Obx(() {
// //             // Wrap in Obx to listen for changes
// //             return SwitchListTile(
// //               title: Text('Location'),
// //               value: settingsController.showLocation.value,
// //               onChanged: (value) {
// //                 settingsController.toggleLocationVisibility(value);
// //               },
// //             );
// //           }),
// //           ListTile(
// //             title: Text("Date Text Color"),
// //             trailing: GestureDetector(
// //               onTap: () {
// //                 _showColorPicker(context, true); // true for date color
// //               },
// //               child: Container(
// //                 width: 50,
// //                 height: 50,
// //                 color: settingsController.dateTextColor.value, // Current date color
// //               ),
// //             ),
// //           ),
// //           ListTile(
// //             title: Text("Location Text Color"),
// //             trailing: GestureDetector(
// //               onTap: () {
// //                 _showColorPicker(context, false); // false for location color
// //               },
// //               child: Container(
// //                 width: 50,
// //                 height: 50,
// //                 color: settingsController.locationTextColor.value, // Current location color
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   void _showColorPicker(BuildContext context, bool isDateColor) {
// //     showDialog(
// //         context: context,
// //         builder: (context) {
// //           Color currentColor = isDateColor
// //               ? settingsController.dateTextColor.value
// //               : settingsController.locationTextColor.value;
// //
// //           return AlertDialog(
// //             title: Text('Select Text Color'),
// //             content: SingleChildScrollView(
// //               child: BlockPicker(
// //                 pickerColor: currentColor,
// //                 onColorChanged: (color) {
// //                   if (isDateColor) {
// //                     settingsController.updateDateTextColor(color);
// //                   } else {
// //                     settingsController.updateLocationTextColor(color);
// //                   }
// //                   Get.back(); // Close the dialog
// //                 },
// //                 ),
// //             ),
// //           );
// //         });
// //   }
// // }
//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Import the flutter_colorpicker package
// import 'package:get/get.dart';
// import 'controller/switch_controller.dart';
//
// class SettingPage extends StatelessWidget {
//   final SettingsController settingsController = Get.put(SettingsController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings'),
//       ),
//       body: ListView(
//         children: [
//           Obx(() {
//             return SwitchListTile(
//               title: Text('Logo'),
//               value: settingsController.showLogo.value,
//               onChanged: (value) {
//                 settingsController.toggleLogoVisibility(value);
//               },
//             );
//           }),
//           Obx(() {
//             return SwitchListTile(
//               title: Text('Location'),
//               value: settingsController.showLocation.value,
//               onChanged: (value) {
//                 settingsController.toggleLocationVisibility(value);
//               },
//             );
//           }),
//           ListTile(
//             title: Text("Date Text Color"),
//             trailing: GestureDetector(
//               onTap: () {
//                 _showColorPicker(context, true); // true for date color
//               },
//               child: Container(
//                 width: 50,
//                 height: 50,
//                 color: settingsController.dateTextColor.value, // Current date color
//               ),
//             ),
//           ),
//           ListTile(
//             title: Text("Location Text Color"),
//             trailing: GestureDetector(
//               onTap: () {
//                 _showColorPicker(context, false); // false for location color
//               },
//               child: Container(
//                 width: 50,
//                 height: 50,
//                 color: settingsController.locationTextColor.value, // Current location color
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showColorPicker(BuildContext context, bool isDateColor) {
//     Color currentColor = isDateColor
//         ? settingsController.dateTextColor.value
//         : settingsController.locationTextColor.value;
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Select Text Color'),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 BlockPicker(
//                   pickerColor: currentColor,
//                   onColorChanged: (color) {
//                     if (isDateColor) {
//                       settingsController.updateDateTextColor(color);
//                     } else {
//                       settingsController.updateLocationTextColor(color);
//                     }
//                     Get.back(); // Close the dialog
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         // Optional: Reset to default color or close dialog
//                         Get.back(); // Close the dialog
//                       },
//                       child: Text('Cancel'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Optional: Add functionality to save the selected color if necessary
//                         Get.back(); // Close the dialog
//                       },
//                       child: Text('OK'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Import the flutter_colorpicker package
// import 'package:get/get.dart';
// import 'controller/switch_controller.dart';
//
// class SettingPage extends StatelessWidget {
//   final SettingsController settingsController = Get.put(SettingsController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings'),
//       ),
//       body: GetBuilder<SettingsController>(
//         builder: (contextx) {
//           return ListView(
//             children: [
//           SwitchListTile(
//           title: Text('Logo'),
//           value: settingsController.showLogo.value,
//           onChanged: (value) {
//             settingsController.toggleLogoVisibility(value);
//           },
//               ),
//               SwitchListTile(
//               title: Text('Location'),
//               value: settingsController.showLocation.value,
//               onChanged: (value) {
//               settingsController.toggleLocationVisibility(value);
//               },
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Text("Text Color",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
//               ),
//               _buildColorTile(
//                 title: "Date Color",
//                 color: settingsController.dateTextColor.value,
//                 onTap: () {
//                   _showColorPicker(context, true); // true for date color
//                 },
//               ),
//               _buildColorTile(
//                 title: "Location Color",
//                 color: settingsController.locationTextColor.value,
//                 onTap: () {
//                   _showColorPicker(context, false); // false for location color
//                 },
//               ),
//             ],
//           );
//         }
//       ),
//     );
//   }
//
//   Widget _buildColorTile({
//     required String title,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       title: Text(title),
//       trailing: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: color,
//             border: Border.all(color: Colors.black54),
//             borderRadius: BorderRadius.circular(5),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showColorPicker(BuildContext context, bool isDateColor) {
//     Color currentColor = isDateColor
//         ? settingsController.dateTextColor.value
//         : settingsController.locationTextColor.value;
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Select Text Color'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Full Color Picker
//                 ColorPicker(
//                   pickerColor: currentColor,
//                   onColorChanged: (color) {
//                     // Update the color value in the controller
//                     if (isDateColor) {
//                       settingsController.updateDateTextColor(color);
//                     } else {
//                       settingsController.updateLocationTextColor(color);
//                     }
//                   },
//                   showLabel: true,
//                   pickerAreaHeightPercent: 0.7,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Current Color',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Container(
//                   width: 100,
//                   height: 50,
//                   color: currentColor,
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Get.back(); // Close the dialog
//               },
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

  // import 'package:dcamera_application/default_position.dart';
  //
  // import 'package:flutter/material.dart';
  // import 'package:get/get.dart';
  // import 'package:image_picker/image_picker.dart';
  // import 'controller/switch_controller.dart';
  // import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Import the flutter_colorpicker package
  // import 'dart:io';
  // import 'mysaved.dart';
  //
  // class SettingPage extends StatelessWidget {
  //   final SettingsController settingsController = Get.put(SettingsController());
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     void _selectLogoImage() {
  //       settingsController.pickLogoImage();
  //     }
  //
  //     void _removeLogoImage() {
  //       settingsController.removeLogoImage();
  //     }
  //
  //     return Scaffold(
  //       appBar: AppBar(
  //         title: Text('Settings'),
  //       ),
  //       body: GetBuilder<SettingsController>(builder: (contextx) {
  //         return ListView(
  //           children: [
  //             ListTile(
  //               title: Text('My Saved'),
  //               trailing: Icon(Icons.bookmark_rounded),
  //               onTap: () {
  //                 Get.to(ImageGalleryScreen());
  //               },
  //             ),
  //             SwitchListTile(
  //               title: Text('Logo'),
  //               value: settingsController.showLogo.value,
  //               onChanged: (value) {
  //                 settingsController.toggleLogoVisibility(value);
  //               },
  //             ),
  //             if(settingsController.showLogo.value)
  //             Obx(
  //               () => Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   if (settingsController.showLogo.value)
  //                     Stack(
  //                       children: [
  //                         // Display the logo or loader
  //                         if (settingsController.isLoading.value)
  //                           SizedBox(
  //                             width: 40,
  //                             height: 40,
  //                             child:
  //                                 CircularProgressIndicator(color: Colors.black),
  //                           )
  //                         else if (settingsController
  //                             .logoImagePath.value.isNotEmpty)
  //                           Image.file(
  //                             File(settingsController.logoImagePath.value),
  //                             width: 40,
  //                             height: 40,
  //                             fit: BoxFit.cover,
  //                           )
  //                         else
  //                           Column(
  //                             mainAxisSize: MainAxisSize.min,
  //                             children: [
  //                               Image.asset(
  //                                 'assets/logo.png',
  //                                 width: 40,
  //                                 height: 40,
  //                                 fit: BoxFit.cover,
  //                               ),
  //                               SizedBox(height: 8),
  //                               Text(
  //                                 'Default Logo',
  //                                 style: TextStyle(fontWeight: FontWeight.bold),
  //                               ),
  //                             ],
  //                           ),
  //                         // Cancel icon to remove the logo image
  //                         if (settingsController.logoImagePath.value.isNotEmpty)
  //                           Positioned(
  //                             top: 0,
  //                             right: 0,
  //                             child: IconButton(
  //                               icon: Icon(Icons.cancel, color: Colors.red),
  //                               onPressed: _removeLogoImage,
  //                               tooltip: 'Remove Logo Image',
  //                             ),
  //                           ),
  //                       ],
  //                     ),
  //                   // Centered upload icon below the logo
  //                   SizedBox(height: 8), // Space between logo and upload icon
  //                   IconButton(
  //                     icon: Icon(Icons.upload_file),
  //                     onPressed: _selectLogoImage,
  //                     tooltip: settingsController.logoImagePath.value.isNotEmpty
  //                         ? 'Change Logo Image'
  //                         : 'Select Logo Image',
  //                   ),
  //                 ],
  //               ),
  //             ),
  //
  //             SwitchListTile(
  //               title: Text('Date'),
  //               value: settingsController.showDateTime.value,
  //               onChanged: (value) {
  //                 settingsController.toggleDateTimeVisibility(value);
  //               },
  //             ),
  //
  //             if (settingsController.showDateTime.value)
  //               _buildColorTile(
  //                 title: "Date Color",
  //                 color: settingsController.dateTextColor.value,
  //                 onTap: () {
  //                   _showColorPicker(
  //                       context, ColorType.date); // ColorType for date color
  //                 },
  //               ),
  //             SwitchListTile(
  //               title: Text('Location'),
  //               value: settingsController.showLocation.value,
  //               onChanged: (value) {
  //                 settingsController.toggleLocationVisibility(value);
  //               },
  //             ),
  //             if (settingsController.showLocation.value)
  //               _buildColorTile(
  //                 title: "Location Color",
  //                 color: settingsController.locationTextColor.value,
  //                 onTap: () {
  //                   _showColorPicker(context,
  //                       ColorType.location); // ColorType for location color
  //                 },
  //               ),
  //             SwitchListTile(
  //               title: Text('Show Date Background'),
  //               value: settingsController.showDB.value,
  //               onChanged: (value) {
  //                 settingsController.toggleDatebVisibility(value);
  //               },
  //             ),
  //             // Conditionally show Date Background Color picker if "Show Date Background" is enabled
  //             if (settingsController.showDB.value)
  //               _buildColorTile(
  //                 title: "Date Background Color",
  //                 color: settingsController.dBackgroundColor.value,
  //                 onTap: () {
  //                   _showColorPicker(
  //                       context,
  //                       ColorType
  //                           .topBackground); // ColorType for top background color
  //                 },
  //               ),
  //             // Switch for Location Background visibility
  //             SwitchListTile(
  //               title: Text('Show Location Background'),
  //               value: settingsController.showLB.value,
  //               onChanged: (value) {
  //                 settingsController.toggleLocbVisibility(value);
  //               },
  //             ),
  //             if (settingsController.showLB.value)
  //               _buildColorTile(
  //                 title: "Location b Color",
  //                 color: settingsController.lBackgroundColor.value,
  //                 onTap: () {
  //                   _showColorPicker(
  //                       context,
  //                       ColorType
  //                           .bottomBackground); // ColorType for bottom background color
  //                 },
  //               ),
  //
  //             ListTile(
  //               title: Text("Default Position"),
  //               trailing: Icon(Icons.arrow_forward_ios_outlined),
  //               onTap: () {
  //                 Get.to(DefaultPosition());
  //               },
  //             ),
  //           ],
  //         );
  //       }),
  //     );
  //   }
  //
  //   Widget _buildColorTile({
  //     required String title,
  //     required Color color,
  //     required VoidCallback onTap,
  //   }) {
  //     return ListTile(
  //       title: Text(title),
  //       trailing: GestureDetector(
  //         onTap: onTap,
  //         child: Container(
  //           width: 50,
  //           height: 50,
  //           decoration: BoxDecoration(
  //             color: color,
  //             border: Border.all(color: Colors.black54),
  //             borderRadius: BorderRadius.circular(5),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //
  //   void _showColorPicker(BuildContext context, ColorType colorType) {
  //     Color currentColor;
  //     switch (colorType) {
  //       case ColorType.date:
  //         currentColor = settingsController.dateTextColor.value;
  //         break;
  //       case ColorType.location:
  //         currentColor = settingsController.locationTextColor.value;
  //         break;
  //       case ColorType.topBackground:
  //         currentColor = settingsController.dBackgroundColor.value;
  //         break;
  //       case ColorType.bottomBackground:
  //         currentColor = settingsController.lBackgroundColor.value;
  //         break;
  //     }
  //
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Select Color'),
  //           content: SingleChildScrollView(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 ColorPicker(
  //                   pickerColor: currentColor,
  //                   onColorChanged: (color) {
  //                     // Update the color value in the controller
  //                     switch (colorType) {
  //                       case ColorType.date:
  //                         settingsController.updateDateTextColor(color);
  //                         break;
  //                       case ColorType.location:
  //                         settingsController.updateLocationTextColor(color);
  //                         break;
  //                       case ColorType.topBackground:
  //                         settingsController.updatedBackgroundColor(color);
  //                         break;
  //                       case ColorType.bottomBackground:
  //                         settingsController.updatelBackgroundColor(color);
  //                         break;
  //                     }
  //                   },
  //                   showLabel: true,
  //                   pickerAreaHeightPercent: 0.7,
  //                 ),
  //                 SizedBox(height: 10),
  //                 Text(
  //                   'Current Color',
  //                   style: TextStyle(fontWeight: FontWeight.bold),
  //                 ),
  //                 Container(
  //                   width: 100,
  //                   height: 50,
  //                   color: currentColor,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Get.back(); // Close the dialog
  //               },
  //               child: Text('Close'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }
  //
  // enum ColorType {
  //   date,
  //   location,
  //   topBackground,
  //   bottomBackground,
  // }



import 'package:dcamera_application/default_position.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'controller/switch_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:io';
import 'mysaved.dart';

class SettingPage extends StatelessWidget {
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
                  Get.to(DefaultPosition());
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

