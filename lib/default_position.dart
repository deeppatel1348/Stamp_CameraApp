import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/switch_controller.dart';
//
class DefaultPosition extends StatefulWidget {
  const DefaultPosition({super.key});

  @override
  State<DefaultPosition> createState() => _DefaultPositionState();
}
//
// class _DefaultPositionState extends State<DefaultPosition> {
//   final SettingsController settingsController = Get.find<SettingsController>();
//
//   // Custom dimensions for boundary checks (400x800)
//   final double customWidth = 400;
//   final double customHeight = double.infinity;
//
//   // Default positions for date, location, and logo
//   final Offset defaultDatePosition = Offset(20, 20); // Adjust as needed
//   final Offset defaultLocationPosition = Offset(20, 100); // Adjust as needed
//   final Offset defaultLogoPosition = Offset(20, 200); // Adjust as needed
//
//   // Method to ensure positions stay within boundaries
//   Offset _constrainPosition(Offset position, double elementWidth, double elementHeight) {
//     double newX = position.dx;
//     double newY = position.dy;
//
//     // Ensure the element stays within the custom 400x800 area
//     if (newX < 0) newX = 0; // Prevent from going off the left
//     if (newY < 0) newY = 0; // Prevent from going off the top
//     if (newX + elementWidth > customWidth) newX = customWidth - elementWidth; // Prevent going off the right
//     if (newY + elementHeight > customHeight) newY = customHeight - elementHeight; // Prevent going off the bottom
//
//     return Offset(newX, newY);
//   }
//
//   void _updateDatePosition(DragUpdateDetails details) {
//     Offset newPosition = settingsController.datePosition.value + details.delta;
//     newPosition = _constrainPosition(newPosition, 150, settingsController.dateFontSize.value); // Assuming width of the date text
//     settingsController.datePosition.value = newPosition;
//
//     // Save the updated position
//     settingsController.saveDatePosition(newPosition);
//   }
//
//   void _updateLocationPosition(DragUpdateDetails details) {
//     Offset newPosition = settingsController.locationPosition.value + details.delta;
//     newPosition = _constrainPosition(newPosition, 200, settingsController.locationFontSize.value); // Assuming width of the location text
//     settingsController.locationPosition.value = newPosition;
//
//     // Save the updated position
//     settingsController.saveLocationPosition(newPosition);
//   }
//
//   void _updateLogoPosition(DragUpdateDetails details) {
//     Offset newPosition = settingsController.logoPosition.value + details.delta;
//     newPosition = _constrainPosition(newPosition, settingsController.logoSize.value, settingsController.logoSize.value);
//     settingsController.logoPosition.value = newPosition;
//
//     // Save the updated position
//     settingsController.saveLogoPosition(newPosition);
//   }
//
//   void _resetPositions() {
//     // Reset positions to defaults
//     settingsController.datePosition.value = defaultDatePosition;
//     settingsController.locationPosition.value = defaultLocationPosition;
//     settingsController.logoPosition.value = defaultLogoPosition;
//
//     // Save the default positions
//     settingsController.saveDatePosition(defaultDatePosition);
//     settingsController.saveLocationPosition(defaultLocationPosition);
//     settingsController.saveLogoPosition(defaultLogoPosition);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Default Position"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _resetPositions, // Reset button
//           ),
//         ],
//       ),
//       body: Center(
//         child: Container(
//           width: customWidth, // Set custom width (400)
//           height: customHeight, // Set custom height (800)
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black), // Optional border to visualize boundaries
//           ),
//           child: Stack(
//             children: [
//               // Background Image
//               Image.asset(
//                 "assets/default.jpg",
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: double.infinity,
//               ),
//
//               // Editable DateTime Position
//               Obx(() {
//                 return settingsController.showDateTime.value
//                     ? Positioned(
//                   left: settingsController.datePosition.value.dx,
//                   top: settingsController.datePosition.value.dy,
//                   child: GestureDetector(
//                     onPanUpdate: _updateDatePosition, // Allow dragging
//                     child: Container(
//                       padding: EdgeInsets.all(8.0),
//                       color: settingsController.showDB.value
//                           ? settingsController.dBackgroundColor.value.withOpacity(0.3)
//                           : Colors.transparent,
//                       child: Text(
//                         "0000-00-00 00:00 PM", // Static for now
//                         style: TextStyle(
//                           color: settingsController.dateTextColor.value,
//                           fontSize: settingsController.dateFontSize.value,
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//                     : SizedBox();
//               }),
//
//               // Editable Location Position
//               Obx(() {
//                 return settingsController.showLocation.value
//                     ? Positioned(
//                   left: settingsController.locationPosition.value.dx,
//                   top: settingsController.locationPosition.value.dy,
//                   child: GestureDetector(
//                     onPanUpdate: _updateLocationPosition, // Allow dragging
//                     child: Container(
//                       padding: const EdgeInsets.all(8.0),
//                       color: settingsController.showLB.value
//                           ? settingsController.lBackgroundColor.value.withOpacity(0.3)
//                           : Colors.transparent,
//                       child: Text(
//                         "Current Location", // Static for now
//                         style: TextStyle(
//                           color: settingsController.locationTextColor.value,
//                           fontSize: settingsController.locationFontSize.value,
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//                     : SizedBox();
//               }),
//
//               // Editable Logo Position
//               Obx(() {
//                 return settingsController.showLogo.value
//                     ? Positioned(
//                   left: settingsController.logoPosition.value.dx,
//                   top: settingsController.logoPosition.value.dy,
//                   child: GestureDetector(
//                     onPanUpdate: _updateLogoPosition, // Allow dragging
//                     child: settingsController.logoImagePath.value.isNotEmpty
//                         ? Image.file(
//                       File(settingsController.logoImagePath.value),
//                       width: settingsController.logoSize.value,
//                       height: settingsController.logoSize.value,
//                       fit: BoxFit.cover,
//                     )
//                         : Image.asset(
//                       'assets/logo.png',
//                       width: settingsController.logoSize.value,
//                       height: settingsController.logoSize.value,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 )
//                     : SizedBox();
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class _DefaultPositionState extends State<DefaultPosition> {
  final SettingsController settingsController = Get.find<SettingsController>();

  // Custom dimensions for boundary checks (400x800)
  final double customWidth = 400;
  final double customHeight = double.infinity;

  // Default positions for date, location, and logo
  final Offset defaultDatePosition = Offset(20, 20);
  final Offset defaultLocationPosition = Offset(20, 100);
  final Offset defaultLogoPosition = Offset(20, 200);

  // Method to ensure positions stay within boundaries
  Offset _constrainPosition(Offset position, double elementWidth, double elementHeight) {
    double newX = position.dx;
    double newY = position.dy;

    // Ensure the element stays within the custom 400x800 area
    if (newX < 0) newX = 0; // Prevent from going off the left
    if (newY < 0) newY = 0; // Prevent from going off the top
    if (newX + elementWidth > customWidth) newX = customWidth - elementWidth; // Prevent going off the right
    if (newY + elementHeight > customHeight) newY = customHeight - elementHeight; // Prevent going off the bottom

    return Offset(newX, newY);
  }

  void _updatePosition(Offset newPosition, String positionType) {
    // Update position based on type
    if (positionType == 'date') {
      settingsController.datePosition.value = newPosition;
      settingsController.saveDatePosition(newPosition);
    } else if (positionType == 'location') {
      settingsController.locationPosition.value = newPosition;
      settingsController.saveLocationPosition(newPosition);
    } else if (positionType == 'logo') {
      settingsController.logoPosition.value = newPosition;
      settingsController.saveLogoPosition(newPosition);
    }
  }

  void _updateDatePosition(DragUpdateDetails details) {
    Offset newPosition = settingsController.datePosition.value + details.delta;
    newPosition = _constrainPosition(newPosition, 150, settingsController.dateFontSize.value);
    _updatePosition(newPosition, 'date');
  }

  void _updateLocationPosition(DragUpdateDetails details) {
    Offset newPosition = settingsController.locationPosition.value + details.delta;
    newPosition = _constrainPosition(newPosition, 200, settingsController.locationFontSize.value);
    _updatePosition(newPosition, 'location');
  }

  void _updateLogoPosition(DragUpdateDetails details) {
    Offset newPosition = settingsController.logoPosition.value + details.delta;
    newPosition = _constrainPosition(newPosition, settingsController.logoSize.value, settingsController.logoSize.value);
    _updatePosition(newPosition, 'logo');
  }

  void _resetPositions() {
    settingsController.datePosition.value = defaultDatePosition;
    settingsController.locationPosition.value = defaultLocationPosition;
    settingsController.logoPosition.value = defaultLogoPosition;

    settingsController.saveDatePosition(defaultDatePosition);
    settingsController.saveLocationPosition(defaultLocationPosition);
    settingsController.saveLogoPosition(defaultLogoPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Default Position"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetPositions, // Reset button
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: customWidth,
          height: customHeight,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Stack(
            children: [
              // Background Image
              Image.asset(
                "assets/default.jpg",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),

              // Editable DateTime Position
              Obx(() {
                return settingsController.showDateTime.value
                    ? Positioned(
                  left: settingsController.datePosition.value.dx,
                  top: settingsController.datePosition.value.dy,
                  child: GestureDetector(
                    onPanUpdate: _updateDatePosition,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: settingsController.showDB.value
                          ? settingsController.dBackgroundColor.value.withOpacity(0.3)
                          : Colors.transparent,
                      child: Text(
                        "0000-00-00 00:00 PM", // Static for now
                        style: TextStyle(
                          color: settingsController.dateTextColor.value,
                          fontSize: settingsController.dateFontSize.value,
                        ),
                      ),
                    ),
                  ),
                )
                    : SizedBox();
              }),

              // Editable Location Position
              Obx(() {
                return settingsController.showLocation.value
                    ? Positioned(
                  left: settingsController.locationPosition.value.dx,
                  top: settingsController.locationPosition.value.dy,
                  child: GestureDetector(
                    onPanUpdate: _updateLocationPosition,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: settingsController.showLB.value
                          ? settingsController.lBackgroundColor.value.withOpacity(0.3)
                          : Colors.transparent,
                      child: Text(
                        "Current Location", // Static for now
                        style: TextStyle(
                          color: settingsController.locationTextColor.value,
                          fontSize: settingsController.locationFontSize.value,
                        ),
                      ),
                    ),
                  ),
                )
                    : SizedBox();
              }),

              // Editable Logo Position
              Obx(() {
                return settingsController.showLogo.value
                    ? Positioned(
                  left: settingsController.logoPosition.value.dx,
                  top: settingsController.logoPosition.value.dy,
                  child: GestureDetector(
                    onPanUpdate: _updateLogoPosition,
                    child: settingsController.logoImagePath.value.isNotEmpty
                        ? Image.file(
                      File(settingsController.logoImagePath.value),
                      width: settingsController.logoSize.value,
                      height: settingsController.logoSize.value,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      'assets/logo.png',
                      width: settingsController.logoSize.value,
                      height: settingsController.logoSize.value,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                    : SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
