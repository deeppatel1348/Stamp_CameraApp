import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'controller/switch_controller.dart';
import 'main.dart';



class EditPositionScreen extends StatefulWidget {
  final XFile imageFile;
  final Offset datePosition;
  final Offset locationPosition;
  final Offset logoPosition;
  final String date;
  final String location;
  final String logoImagePath;
  final Function(
      Offset,
      Offset,
      Offset,
      double,
      double,
      double,
      ) onPositionUpdated;
  final double logoSize;
  final double dateFontSize;
  final double locationFontSize;

  EditPositionScreen({
    Key? key,
    required this.imageFile,
    required this.datePosition,
    required this.locationPosition,
    required this.logoPosition,
    required this.onPositionUpdated,
    required this.date,
    required this.location,
    required this.logoImagePath,
    required this.logoSize,
    required this.dateFontSize,
    required this.locationFontSize,
  }) : super(key: key);

  @override
  _EditPositionScreenState createState() => _EditPositionScreenState();
}




class _EditPositionScreenState extends State<EditPositionScreen> {
  late Rx<Offset> _datePosition;
  late Rx<Offset> _locationPosition;
  late Rx<Offset> _logoPosition;
  late RxDouble _logoSize;
  late RxDouble _dateFontSize;
  late RxDouble _locationFontSize;
  final double containerSize = 100;

  final SettingsController settingsController = Get.find<SettingsController>();

  @override
  void initState() {
    super.initState();
    _datePosition = Rx<Offset>(widget.datePosition);
    _locationPosition = Rx<Offset>(widget.locationPosition);
    _logoPosition = Rx<Offset>(widget.logoPosition);
    _logoSize = RxDouble(widget.logoSize);
    _dateFontSize = RxDouble(widget.dateFontSize);
    _locationFontSize = RxDouble(widget.locationFontSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("Edit Position"),
        actions: [
          IconButton(
            onPressed: () {
              // Update with positions and sizes
              widget.onPositionUpdated(
                _datePosition.value,
                _locationPosition.value,
                _logoPosition.value,
                _dateFontSize.value,
                _locationFontSize.value,
                _logoSize.value,
              );
              Navigator.pop(context);
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.file(
                File(widget.imageFile.path),
                fit: BoxFit.contain,
              ),
            ),
            // Conditionally render the date if it's visible
            Obx(() {
              return settingsController.showDateTime.value
                  ? _buildDraggableTextContainer(
                position: _datePosition.value,
                text: widget.date,
                fontSize: _dateFontSize.value,
                onPositionChange: (newPosition) {
                  _datePosition.value = _constrainTextPosition(newPosition);
                },
                onFontSizeChange: (delta) {
                  _dateFontSize.value = (_dateFontSize.value + delta).clamp(12.0, 30.0);
                },
                color: settingsController.dateTextColor.value,
                bgcolor: settingsController.dBackgroundColor.value,
              )
                  : Container(); // Show an empty container when the date is hidden
            }),
            // Conditionally render the location if it's visible
            Obx(() {
              return settingsController.showLocation.value
                  ? _buildDraggableTextContainer(
                position: _locationPosition.value,
                text: widget.location,
                fontSize: _locationFontSize.value,
                onPositionChange: (newPosition) {
                  _locationPosition.value = _constrainTextPosition(newPosition);
                },
                onFontSizeChange: (delta) {
                  _locationFontSize.value = (_locationFontSize.value + delta).clamp(12.0, 30.0);
                },
                color: settingsController.locationTextColor.value,
                bgcolor: settingsController.lBackgroundColor.value,
              )
                  : Container(); // Show an empty container when the location is hidden
            }),
            // Conditionally render the logo if it's visible
            Obx(() {
              return settingsController.showLogo.value
                  ? _buildDraggableLogo()
                  : Container(); // Show an empty container when the logo is hidden
            }),
          ],
        ),
      ),
    );
  }




  Widget _buildDraggableTextContainer({
    required Offset position,
    required String text,
    required double fontSize,
    required ValueChanged<Offset> onPositionChange,
    required ValueChanged<double> onFontSizeChange,
    required Color color,
    required Color bgcolor,
  }) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Stack(
        children: [
          GestureDetector(
            // Allows dragging the text container
            onPanUpdate: (details) {
              // Directly update the position without constraints to match the logo's movement speed
              onPositionChange(position + details.delta);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: bgcolor.withOpacity(0.3),
              child: Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
          // Pinch Button for resizing the text font size
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onPanUpdate: (details) {
                onFontSizeChange(details.delta.dy);
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.zoom_out_map, size: 15, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //
  // Widget _buildDraggableTextContainer({
  //   required Offset position,
  //   required String text,
  //   required double fontSize,
  //   required ValueChanged<Offset> onPositionChange,
  //   required ValueChanged<double> onFontSizeChange,
  //   required Color color,
  //   required Color bgcolor,
  // }) {
  //   return Positioned(
  //     left: position.dx,
  //     top: position.dy,
  //     child: Stack(
  //       children: [
  //         GestureDetector(
  //           onPanUpdate: (details) {
  //             onPositionChange(position + details.delta);
  //           },
  //           child: Container(
  //             padding: const EdgeInsets.all(8.0),
  //             color: bgcolor.withOpacity(0.3),
  //             child: Text(
  //               text,
  //               style: TextStyle(
  //                 color: color,
  //                 fontSize: fontSize,
  //               ),
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           right: 0,
  //           bottom: 0,
  //           child: GestureDetector(
  //             onPanUpdate: (details) {
  //               onFontSizeChange(details.delta.dy);
  //             },
  //             child: Container(
  //               width: 20,
  //               height: 20,
  //               decoration: BoxDecoration(
  //                 color: color,
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Icon(Icons.zoom_out_map, size: 15, color: Colors.white),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDraggableLogo() {
    return Obx(() {
      return Positioned(
        left: _logoPosition.value.dx,
        top: _logoPosition.value.dy,
        child: Stack(
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                _logoPosition.value = _constrainLogoPosition(_logoPosition.value + details.delta);
              },
              child:widget.logoImagePath.isEmpty? Image.asset(
                'assets/logo.png',
                width: _logoSize.value,
                height: _logoSize.value,
                fit: BoxFit.cover,
              ):Image.file(File(
                  widget.logoImagePath),
                width: _logoSize.value,
                height: _logoSize.value,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  _logoSize.value = (_logoSize.value + details.delta.dy).clamp(50.0, 200.0);
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.zoom_out_map, size: 15, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Offset _constrainTextPosition(Offset position) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double x = position.dx.clamp(0.0, screenWidth - containerSize);
    double y = position.dy.clamp(0.0, screenHeight - containerSize);
    return Offset(x, y);
  }

  Offset _constrainLogoPosition(Offset position) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double x = position.dx.clamp(0.0, screenWidth - _logoSize.value);
    double y = position.dy.clamp(0.0, screenHeight - _logoSize.value);
    return Offset(x, y);
  }
}


// class _EditPositionScreenState extends State<EditPositionScreen> {
//   late Offset _datePosition;
//   late Offset _locationPosition;
//   late Offset _logoPosition;
//   late double _logoSize;
//   late double _dateFontSize;
//   late double _locationFontSize;
//   final double containerSize =
//   100; // Default container size for date and location
//
//   final SettingsController settingsController =
//   Get.find<SettingsController>(); // Get the SettingsController
//
//   @override
//   void initState() {
//     super.initState();
//     _datePosition = widget.datePosition;
//     _locationPosition = widget.locationPosition;
//     _logoPosition = widget.logoPosition;
//     _logoSize = widget.logoSize;
//     _dateFontSize = widget.dateFontSize;
//     _locationFontSize = widget.locationFontSize;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey,
//       appBar: AppBar(
//         title: Text("Edit Position"),
//         actions: [
//           IconButton(
//             onPressed: () {
//               // Update with positions and sizes
//               widget.onPositionUpdated(
//                 _datePosition,
//                 _locationPosition,
//                 _logoPosition,
//                 _dateFontSize, // Pass updated date font size
//                 _locationFontSize, // Pass updated location font size
//                 _logoSize, // Pass updated logo size
//               );
//               Navigator.pop(context);
//             },
//             icon: Icon(Icons.check),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Stack(
//           children: [
//             // Background Image
//             Positioned.fill(
//               child: Image.file(
//                 File(widget.imageFile.path),
//                 fit: BoxFit.contain,
//               ),
//             ),
//             // Conditionally render the date if it's visible
//             Obx(() {
//               return settingsController.showDateTime.value
//                   ? _buildDraggableTextContainer(
//                 position: _datePosition,
//                 text: widget.date,
//                 fontSize: _dateFontSize,
//                 onPositionChange: (newPosition) {
//                   setState(() {
//                     _datePosition = newPosition;
//                   });
//                 },
//                 onFontSizeChange: (delta) {
//                   setState(() {
//                     _dateFontSize =
//                         (_dateFontSize + delta).clamp(12.0, 30.0);
//                   });
//                 },
//                 color: settingsController.dateTextColor.value, bgcolor: settingsController.dBackgroundColor.value,
//               )
//                   : Container(); // Show an empty container when the date is hidden
//             }),
//             // Conditionally render the location if it's visible
//             Obx(() {
//               return settingsController.showLocation.value
//                   ? _buildDraggableTextContainer(
//                 position: _locationPosition,
//                 text: widget.location,
//                 fontSize: _locationFontSize,
//                 onPositionChange: (newPosition) {
//                   setState(() {
//                     _locationPosition = newPosition;
//                   });
//                 },
//                 onFontSizeChange: (delta) {
//                   setState(() {
//                     _locationFontSize =
//                         (_locationFontSize + delta).clamp(12.0, 30.0);
//                   });
//                 },
//                 color: settingsController.locationTextColor.value, bgcolor: settingsController.lBackgroundColor.value,
//               )
//                   : Container(); // Show an empty container when the location is hidden
//             }),
//             // Conditionally render the logo if it's visible
//             Obx(() {
//               return settingsController.showLogo.value
//                   ? _buildDraggableLogo()
//                   : Container(); // Show an empty container when the logo is hidden
//             }),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDraggableTextContainer({
//     required Offset position,
//     required String text,
//     required double fontSize,
//     required ValueChanged<Offset> onPositionChange,
//     required ValueChanged<double> onFontSizeChange,
//     required Color color,
//     required Color bgcolor,
//   }) {
//     return Positioned(
//       left: position.dx,
//       top: position.dy,
//       child: Stack(
//         children: [
//           GestureDetector(
//             // Allows dragging the text container
//             onPanUpdate: (details) {
//               onPositionChange(
//                   _constrainTextPosition(position + details.delta));
//             },
//             child: Container(
//               padding: const EdgeInsets.all(8.0),
//               color: bgcolor.withOpacity(0.3),
//               // Optional background color for text container
//               child: Text(
//                 text,
//                 style: TextStyle(
//                   color: color,
//                   fontSize: fontSize,
//                 ),
//               ),
//             ),
//           ),
//           // Pinch Button for resizing the text font size
//           Positioned(
//             right: 0,
//             bottom: 0,
//             child: GestureDetector(
//               onPanUpdate: (details) {
//                 onFontSizeChange(details.delta.dy);
//               },
//               child: Container(
//                 width: 20,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   color: color,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(Icons.zoom_out_map, size: 15, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Offset _constrainTextPosition(Offset position) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     // Constrain to the boundaries of the screen
//     double x = position.dx.clamp(0.0, screenWidth - containerSize);
//     double y = position.dy.clamp(0.0, screenHeight - containerSize);
//
//     return Offset(x, y);
//   }
//
//   Widget _buildDraggableLogo() {
//     return Positioned(
//       left: _logoPosition.dx,
//       top: _logoPosition.dy,
//       child: Stack(
//         children: [
//           GestureDetector(
//             // Allows for dragging anywhere within the logo bounds
//             onPanUpdate: (details) {
//               setState(() {
//                 _logoPosition =
//                     _constrainLogoPosition(_logoPosition + details.delta);
//               });
//             },
//             child: Image.asset(
//               widget.logoImagePath,
//               width: _logoSize,
//               height: _logoSize,
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Pinch Button for Logo Resizing
//           Positioned(
//             right: 0,
//             bottom: 0,
//             child: GestureDetector(
//               onPanUpdate: (details) {
//                 setState(() {
//                   _logoSize = (_logoSize + details.delta.dy).clamp(50.0, 200.0);
//                 });
//               },
//               child: Container(
//                 width: 20,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   color: Colors.green,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(Icons.zoom_out_map, size: 15, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Offset _constrainLogoPosition(Offset position) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     // Constrain to the boundaries of the screen/image to prevent overflow
//     double x = position.dx.clamp(0.0, screenWidth - _logoSize);
//     double y = position.dy.clamp(0.0, screenHeight - _logoSize);
//
//     return Offset(x, y);
//   }
//
//   Offset _constrainPosition(Offset position) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     double x = position.dx.clamp(0.0, screenWidth - containerSize);
//     double y = position.dy.clamp(0.0, screenHeight - containerSize);
//     return Offset(x, y);
//   }
// }