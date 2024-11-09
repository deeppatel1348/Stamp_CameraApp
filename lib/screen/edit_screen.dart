// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'controller/setting_controller.dart';
// import 'main.dart';
//
// class EditPositionScreen extends StatefulWidget {
//   final XFile imageFile;
//   final String logoImagePath;
//   final String date;
//   final String location;
//   final Offset datePosition;
//   final Offset locationPosition;
//   final Offset logoPosition;
//   final double logoSize;
//   final double dateFontSize;
//   final double locationFontSize;
//   final Function(
//     Offset datePosition,
//     Offset locationPosition,
//     Offset logoPosition,
//     double dateFontSize,
//     double locationFontSize,
//     double logoSize,
//   ) onPositionUpdated;
//
//   const EditPositionScreen({
//     Key? key,
//     required this.imageFile,
//     required this.logoImagePath,
//     required this.date,
//     required this.location,
//     required this.datePosition,
//     required this.locationPosition,
//     required this.logoPosition,
//     required this.logoSize,
//     required this.dateFontSize,
//     required this.locationFontSize,
//     required this.onPositionUpdated,
//   }) : super(key: key);
//
//   @override
//   State<EditPositionScreen> createState() => _EditPositionScreenState();
// }
//
// class _EditPositionScreenState extends State<EditPositionScreen> {
//   // Declare Rx variables for positions and sizes
//   late Rx<Offset> _datePosition;
//   late Rx<Offset> _locationPosition;
//   late Rx<Offset> _logoPosition;
//   late RxDouble _logoSize;
//   late RxDouble _dateFontSize;
//   late RxDouble _locationFontSize;
//
//   // Keys for size measurement
//   final GlobalKey _dateKey = GlobalKey();
//   final GlobalKey _locationKey = GlobalKey();
//   final GlobalKey _logoKey = GlobalKey();
//
//   final SettingsController settingsController = Get.find<SettingsController>();
//
//   @override
//   void initState() {
//     super.initState();
//     _datePosition = Rx<Offset>(widget.datePosition);
//     _locationPosition = Rx<Offset>(widget.locationPosition);
//     _logoPosition = Rx<Offset>(widget.logoPosition);
//     _logoSize = RxDouble(widget.logoSize);
//     _dateFontSize = RxDouble(widget.dateFontSize);
//     _locationFontSize = RxDouble(widget.locationFontSize);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey,
//       appBar: AppBar(
//         title: const Text("Edit Position"),
//         actions: [
//           IconButton(
//             onPressed: () {
//               // Update with positions and sizes
//               widget.onPositionUpdated(
//                 _datePosition.value,
//                 _locationPosition.value,
//                 _logoPosition.value,
//                 _dateFontSize.value,
//                 _locationFontSize.value,
//                 _logoSize.value,
//               );
//               Navigator.pop(context);
//             },
//             icon: const Icon(Icons.check),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // Background Image
//           Positioned.fill(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             top: 0,
//             child: Image.file(
//               File(widget.imageFile.path),
//               fit: BoxFit.contain,
//             ),
//           ),
//           // Date
//           Obx(() {
//             return settingsController.showDateTime.value
//                 ? _buildDraggableTextContainer(
//                     key: _dateKey,
//                     position: _datePosition.value,
//                     text: widget.date,
//                     fontSize: _dateFontSize.value,
//                     onPositionChange: (newPosition) {
//                       _datePosition.value = _constrainPosition(
//                         newPosition,
//                         _getSize(_dateKey),
//                       );
//                     },
//                     onFontSizeChange: (delta) {
//                       _dateFontSize.value =
//                           (_dateFontSize.value + delta).clamp(10.0, 30.0);
//                     },
//                     color: settingsController.dateTextColor.value,
//                     bgcolor: settingsController.dBackgroundColor.value,
//                   )
//                 : Container();
//           }),
//           // Location
//           Obx(() {
//             return settingsController.showLocation.value
//                 ? _buildDraggableTextContainer(
//                     key: _locationKey,
//                     position: _locationPosition.value,
//                     text: widget.location,
//                     fontSize: _locationFontSize.value,
//                     onPositionChange: (newPosition) {
//                       _locationPosition.value = _constrainPosition(
//                         newPosition,
//                         _getSize(_locationKey),
//                       );
//                     },
//                     onFontSizeChange: (delta) {
//                       _locationFontSize.value =
//                           (_locationFontSize.value + delta).clamp(12.0, 30.0);
//                     },
//                     color: settingsController.locationTextColor.value,
//                     bgcolor: settingsController.lBackgroundColor.value,
//                   )
//                 : Container();
//           }),
//           // Logo
//           Obx(() {
//             return settingsController.showLogo.value
//                 ? _buildDraggableLogo(key: _logoKey)
//                 : Container();
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDraggableTextContainer({
//     Key? key,
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
//         key: key,
//         children: [
//           GestureDetector(
//             onPanUpdate: (details) {
//               onPositionChange(position + details.delta);
//             },
//             child: Container(
//               padding: const EdgeInsets.all(8.0),
//               decoration: BoxDecoration(
//                 color: bgcolor.withOpacity(0.3),
//                 borderRadius: BorderRadius.circular(4.0),
//               ),
//               child: Text(
//                 text,
//                 style: TextStyle(
//                   color: color,
//                   fontSize: fontSize,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//           // Resize handle
//           Positioned(
//             right: -10,
//             bottom: -10,
//             child: GestureDetector(
//               onPanUpdate: (details) {
//                 onFontSizeChange(details.delta.dy);
//               },
//               child: Container(
//                 width: 24,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.8),
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white, width: 2),
//                 ),
//                 child: const Icon(
//                   Icons.zoom_out_map,
//                   size: 16,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDraggableLogo({Key? key}) {
//     return Obx(() {
//       return Positioned(
//         left: _logoPosition.value.dx,
//         top: _logoPosition.value.dy,
//         child: Stack(
//           key: key,
//           children: [
//             GestureDetector(
//               onPanUpdate: (details) {
//                 _logoPosition.value = _constrainPosition(
//                   _logoPosition.value + details.delta,
//                   Size(_logoSize.value, _logoSize.value),
//                 );
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.white.withOpacity(0.5),
//                     width: 1,
//                   ),
//                 ),
//                 child: widget.logoImagePath.isEmpty
//                     ? Image.asset(
//                         'assets/logo.png',
//                         width: _logoSize.value,
//                         height: _logoSize.value,
//                         fit: BoxFit.cover,
//                       )
//                     : Image.file(
//                         File(widget.logoImagePath),
//                         width: _logoSize.value,
//                         height: _logoSize.value,
//                         fit: BoxFit.cover,
//                       ),
//               ),
//             ),
//             // Resize handle
//             Positioned(
//               right: -10,
//               bottom: -10,
//               child: GestureDetector(
//                 onPanUpdate: (details) {
//                   double newSize =
//                       (_logoSize.value + details.delta.dy).clamp(50.0, 200.0);
//                   _logoSize.value = newSize;
//
//                   // Recheck position constraints after size change
//                   _logoPosition.value = _constrainPosition(
//                     _logoPosition.value,
//                     Size(newSize, newSize),
//                   );
//                 },
//                 child: Container(
//                   width: 24,
//                   height: 24,
//                   decoration: BoxDecoration(
//                     color: Colors.green.withOpacity(0.8),
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 2),
//                   ),
//                   child: const Icon(
//                     Icons.zoom_out_map,
//                     size: 16,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   Size _getSize(GlobalKey key) {
//     final RenderBox? renderBox =
//         key.currentContext?.findRenderObject() as RenderBox?;
//     return renderBox?.size ?? Size.zero;
//   }
//
//   Offset _constrainPosition(Offset position, Size elementSize) {
//     final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
//     if (renderBox == null) return position;
//
//     final Size imageSize = renderBox.size;
//
//     // Calculate maximum allowed positions
//     double maxX = imageSize.width - elementSize.width;
//     double maxY = imageSize.height - elementSize.height;
//
//     // Constrain the position
//     double x = position.dx.clamp(0.0, maxX);
//     double y = position.dy.clamp(0.0, maxY);
//
//     return Offset(x, y);
//   }
// }
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dcamera_application/services/ad_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'controller/setting_controller.dart';
import 'main.dart';


class EditPositionScreen extends StatefulWidget {
  final XFile imageFile;
  final String logoImagePath;
  final String date;
  final String location;
  final Offset datePosition;
  final Offset locationPosition;
  final Offset logoPosition;
  final double logoSize;
  final double dateFontSize;
  final double locationFontSize;
  final Function(
      Offset datePosition,
      Offset locationPosition,
      Offset logoPosition,
      double dateFontSize,
      double locationFontSize,
      double logoSize,
      ) onPositionUpdated;

  const EditPositionScreen({
    Key? key,
    required this.imageFile,
    required this.logoImagePath,
    required this.date,
    required this.location,
    required this.datePosition,
    required this.locationPosition,
    required this.logoPosition,
    required this.logoSize,
    required this.dateFontSize,
    required this.locationFontSize,
    required this.onPositionUpdated,
  }) : super(key: key);

  @override
  State<EditPositionScreen> createState() => _EditPositionScreenState();
}

class _EditPositionScreenState extends State<EditPositionScreen> {
  late Rx<Offset> _datePosition;
  late Rx<Offset> _locationPosition;
  late Rx<Offset> _logoPosition;
  late RxDouble _logoSize;
  late RxDouble _dateFontSize;
  late RxDouble _locationFontSize;

  final GlobalKey _dateKey = GlobalKey();
  final GlobalKey _locationKey = GlobalKey();
  final GlobalKey _logoKey = GlobalKey();
  final GlobalKey _imageContainerKey = GlobalKey();

  late Size _containerSize = Size.zero;
  late Rect _imageBounds = Rect.zero;
  bool _isInitialized = false;

  final SettingsController settingsController = Get.find<SettingsController>();

  @override
  void initState() {
    super.initState();
    AdProvider adProvider = Provider.of<AdProvider>(context, listen: false);
    adProvider.initializeHomePageBanner();
    _datePosition = Rx<Offset>(widget.datePosition);
    _locationPosition = Rx<Offset>(widget.locationPosition);
    _logoPosition = Rx<Offset>(widget.logoPosition);
    _logoSize = RxDouble(widget.logoSize);
    _dateFontSize = RxDouble(widget.dateFontSize);
    _locationFontSize = RxDouble(widget.locationFontSize);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeBounds();
    });
  }

  void _initializeBounds() {
    final RenderBox? containerBox =
    _imageContainerKey.currentContext?.findRenderObject() as RenderBox?;
    if (containerBox != null) {
      _containerSize = containerBox.size;

      // Get the actual image size and calculate aspect ratio
      final imageFile = File(widget.imageFile.path);
      Image.file(imageFile)
          .image
          .resolve(ImageConfiguration())
          .addListener(ImageStreamListener((info, _) {
        final imageWidth = info.image.width.toDouble();
        final imageHeight = info.image.height.toDouble();
        final imageAspectRatio = imageWidth / imageHeight;
        final containerAspectRatio = _containerSize.width / _containerSize.height;

        double imageDisplayWidth;
        double imageDisplayHeight;
        double offsetX = 0;
        double offsetY = 0;

        if (imageAspectRatio > containerAspectRatio) {
          // Image is wider than container
          imageDisplayWidth = _containerSize.width;
          imageDisplayHeight = imageDisplayWidth / imageAspectRatio;
          offsetY = (_containerSize.height - imageDisplayHeight) / 2;
        } else {
          // Image is taller than container
          imageDisplayHeight = _containerSize.height;
          imageDisplayWidth = imageDisplayHeight * imageAspectRatio;
          offsetX = (_containerSize.width - imageDisplayWidth) / 2;
        }

        setState(() {
          _imageBounds = Rect.fromLTWH(
            offsetX,
            offsetY,
            imageDisplayWidth,
            imageDisplayHeight,
          );
          _isInitialized = true;
        });
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("Edit Position"),
        actions: [
          IconButton(
            onPressed: () {
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
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Container(
        key: _imageContainerKey,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.file(
              File(widget.imageFile.path),
              fit: BoxFit.contain,
            ),
            if (_isInitialized) ...[
              // Date
              Obx(() {
                return settingsController.showDateTime.value
                    ? _buildDraggableTextContainer(
                  key: _dateKey,
                  position: _datePosition.value,
                  text: widget.date,
                  fontSize: _dateFontSize.value,
                  onPositionChange: (newPosition) {
                    _datePosition.value = _constrainPosition(
                      newPosition,
                      _getSize(_dateKey),
                    );
                  },
                  onFontSizeChange: (delta) {
                    _dateFontSize.value =
                        (_dateFontSize.value + delta).clamp(5.0, 20.0);
                    // Recheck position after size change
                    _datePosition.value = _constrainPosition(
                      _datePosition.value,
                      _getSize(_dateKey),
                    );
                  },
                  color: settingsController.dateTextColor.value,
                  bgcolor: settingsController.dBackgroundColor.value,
                )
                    : Container();
              }),
              // Location
              Obx(() {
                return settingsController.showLocation.value
                    ? _buildDraggableTextContainer(
                  key: _locationKey,
                  position: _locationPosition.value,
                  text: widget.location,
                  fontSize: _locationFontSize.value,
                  onPositionChange: (newPosition) {
                    _locationPosition.value = _constrainPosition(
                      newPosition,
                      _getSize(_locationKey),
                    );
                  },
                  onFontSizeChange: (delta) {
                    _locationFontSize.value =
                        (_locationFontSize.value + delta).clamp(5.0, 20.0);
                    // Recheck position after size change
                    _locationPosition.value = _constrainPosition(
                      _locationPosition.value,
                      _getSize(_locationKey),
                    );
                  },
                  color: settingsController.locationTextColor.value,
                  bgcolor: settingsController.lBackgroundColor.value,
                )
                    : Container();
              }),
              // Logo
              Obx(() {
                return settingsController.showLogo.value
                    ? _buildDraggableLogo()
                    : Container();
              }),
            ],
          ],
        ),
      ),
      bottomNavigationBar:  Consumer<AdProvider>(builder: (context, adProvider ,child){
        if(adProvider.isHomePageBannerLoaded){
          return Container(
            height: 50,
            width: double.infinity,
            child: AdWidget(ad: adProvider.homePageBanner),
          );
        }
        else{
          return Container( height: 10,
            width: 100,
            child: AdWidget(ad: adProvider.homePageBanner),);
        }
      } ),
    );
  }

  Widget _buildDraggableTextContainer({
    Key? key,
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
        key: key,
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              onPositionChange(position + details.delta);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: bgcolor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: GestureDetector(
              onPanUpdate: (details) {
                onFontSizeChange(details.delta.dy);
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.8),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.zoom_out_map,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableLogo() {
    return Positioned(
      left: _logoPosition.value.dx,
      top: _logoPosition.value.dy,
      child: Stack(
        key: _logoKey,
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              _logoPosition.value = _constrainPosition(
                _logoPosition.value + details.delta,
                Size(_logoSize.value, _logoSize.value),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: widget.logoImagePath.isEmpty
                  ? Image.asset(
                'assets/logo.png',
                width: _logoSize.value,
                height: _logoSize.value,
                fit: BoxFit.cover,
              )
                  : Image.file(
                File(widget.logoImagePath),
                width: _logoSize.value,
                height: _logoSize.value,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: GestureDetector(
              onPanUpdate: (details) {
                double newSize = (_logoSize.value + details.delta.dy)
                    .clamp(50.0, 200.0);
                _logoSize.value = newSize;

                // Recheck position after size change
                _logoPosition.value = _constrainPosition(
                  _logoPosition.value,
                  Size(newSize, newSize),
                );
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.8),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.zoom_out_map,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Size _getSize(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size ?? Size.zero;
  }

  Offset _constrainPosition(Offset position, Size elementSize) {
    if (!_isInitialized) return position;

    // Calculate the maximum allowed positions within the image bounds
    double maxX = _imageBounds.right - elementSize.width;
    double maxY = _imageBounds.bottom - elementSize.height;

    // Constrain the position to stay within the image bounds
    double x = position.dx.clamp(_imageBounds.left, maxX);
    double y = position.dy.clamp(_imageBounds.top, maxY);

    return Offset(x, y);
  }
}






// class EditPositionScreen extends StatefulWidget {
//   final XFile imageFile;
//   final String logoImagePath;
//   final String date;
//   final String location;
//   final Offset datePosition;
//   final Offset locationPosition;
//   final Offset logoPosition;
//   final double logoSize;
//   final double dateFontSize;
//   final double locationFontSize;
//   final Function(
//       Offset datePosition,
//       Offset locationPosition,
//       Offset logoPosition,
//       double dateFontSize,
//       double locationFontSize,
//       double logoSize,
//       ) onPositionUpdated;
//
//   const EditPositionScreen({
//     Key? key,
//     required this.imageFile,
//     required this.logoImagePath,
//     required this.date,
//     required this.location,
//     required this.datePosition,
//     required this.locationPosition,
//     required this.logoPosition,
//     required this.logoSize,
//     required this.dateFontSize,
//     required this.locationFontSize,
//     required this.onPositionUpdated,
//   }) : super(key: key);
//
//   @override
//   State<EditPositionScreen> createState() => _EditPositionScreenState();
// }

// class _EditPositionScreenState extends State<EditPositionScreen> {
//   // Declare Rx variables for positions and sizes
//   late Rx<Offset> _datePosition;
//   late Rx<Offset> _locationPosition;
//   late Rx<Offset> _logoPosition;
//   late RxDouble _logoSize;
//   late RxDouble _dateFontSize;
//   late RxDouble _locationFontSize;
//
//   // Keys for size measurement
//   final GlobalKey _dateKey = GlobalKey();
//   final GlobalKey _locationKey = GlobalKey();
//   final GlobalKey _logoKey = GlobalKey();
//
//   final SettingsController settingsController = Get.find<SettingsController>();
//
//   @override
//   void initState() {
//     super.initState();
//     _datePosition = Rx<Offset>(widget.datePosition);
//     _locationPosition = Rx<Offset>(widget.locationPosition);
//     _logoPosition = Rx<Offset>(widget.logoPosition);
//     _logoSize = RxDouble(widget.logoSize);
//     _dateFontSize = RxDouble(widget.dateFontSize);
//     _locationFontSize = RxDouble(widget.locationFontSize);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey,
//       appBar: AppBar(
//         title: const Text("Edit Position"),
//         actions: [
//           IconButton(
//             onPressed: () {
//               // Update with positions and sizes
//               widget.onPositionUpdated(
//                 _datePosition.value,
//                 _locationPosition.value,
//                 _logoPosition.value,
//                 _dateFontSize.value,
//                 _locationFontSize.value,
//                 _logoSize.value,
//               );
//               Navigator.pop(context);
//             },
//             icon: const Icon(Icons.check),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // Background Image
//           Positioned.fill(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             top: 0,
//             child: Image.file(
//               File(widget.imageFile.path),
//               fit: BoxFit.contain,
//             ),
//           ),
//           // Date
//           Obx(() {
//             return settingsController.showDateTime.value
//                 ? _buildDraggableTextContainer(
//               key: _dateKey,
//               position: _datePosition.value,
//               text: widget.date,
//               fontSize: _dateFontSize.value,
//               onPositionChange: (newPosition) {
//                 _datePosition.value = _constrainPosition(
//                   newPosition,
//                   _getSize(_dateKey),
//                 );
//               },
//               onFontSizeChange: (delta) {
//                 _dateFontSize.value =
//                     (_dateFontSize.value + delta).clamp(10.0, 30.0);
//               },
//               color: settingsController.dateTextColor.value,
//               bgcolor: settingsController.dBackgroundColor.value,
//             )
//                 : Container();
//           }),
//           // Location
//           Obx(() {
//             return settingsController.showLocation.value
//                 ? _buildDraggableTextContainer(
//               key: _locationKey,
//               position: _locationPosition.value,
//               text: widget.location,
//               fontSize: _locationFontSize.value,
//               onPositionChange: (newPosition) {
//                 _locationPosition.value = _constrainPosition(
//                   newPosition,
//                   _getSize(_locationKey),
//                 );
//               },
//               onFontSizeChange: (delta) {
//                 _locationFontSize.value =
//                     (_locationFontSize.value + delta).clamp(12.0, 30.0);
//               },
//               color: settingsController.locationTextColor.value,
//               bgcolor: settingsController.lBackgroundColor.value,
//             )
//                 : Container();
//           }),
//           // Logo
//           Obx(() {
//             return settingsController.showLogo.value
//                 ? _buildDraggableLogo(key: _logoKey)
//                 : Container();
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDraggableTextContainer({
//     Key? key,
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
//         key: key,
//         children: [
//           GestureDetector(
//             onPanUpdate: (details) {
//               onPositionChange(position + details.delta);
//             },
//             child: Container(
//               padding: const EdgeInsets.all(8.0),
//               decoration: BoxDecoration(
//                 color: bgcolor.withOpacity(0.3),
//                 borderRadius: BorderRadius.circular(4.0),
//               ),
//               child: Text(
//                 text,
//                 style: TextStyle(
//                   color: color,
//                   fontSize: fontSize,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//           // Resize handle
//           Positioned(
//             right: -10,
//             bottom: -10,
//             child: GestureDetector(
//               onPanUpdate: (details) {
//                 onFontSizeChange(details.delta.dy);
//               },
//               child: Container(
//                 width: 24,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.8),
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white, width: 2),
//                 ),
//                 child: const Icon(
//                   Icons.zoom_out_map,
//                   size: 16,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDraggableLogo({Key? key}) {
//     return Obx(() {
//       return Positioned(
//         left: _logoPosition.value.dx,
//         top: _logoPosition.value.dy,
//         child: Stack(
//           key: key,
//           children: [
//             GestureDetector(
//               onPanUpdate: (details) {
//                 _logoPosition.value = _constrainPosition(
//                   _logoPosition.value + details.delta,
//                   Size(_logoSize.value, _logoSize.value),
//                 );
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.white.withOpacity(0.5),
//                     width: 1,
//                   ),
//                 ),
//                 child: widget.logoImagePath.isEmpty
//                     ? Image.asset(
//                   'assets/logo.png',
//                   width: _logoSize.value,
//                   height: _logoSize.value,
//                   fit: BoxFit.cover,
//                 )
//                     : Image.file(
//                   File(widget.logoImagePath),
//                   width: _logoSize.value,
//                   height: _logoSize.value,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             // Resize handle
//             Positioned(
//               right: -10,
//               bottom: -10,
//               child: GestureDetector(
//                 onPanUpdate: (details) {
//                   double newSize =
//                   (_logoSize.value + details.delta.dy).clamp(50.0, 200.0);
//                   _logoSize.value = newSize;
//
//                   // Recheck position constraints after size change
//                   _logoPosition.value = _constrainPosition(
//                     _logoPosition.value,
//                     Size(newSize, newSize),
//                   );
//                 },
//                 child: Container(
//                   width: 24,
//                   height: 24,
//                   decoration: BoxDecoration(
//                     color: Colors.green.withOpacity(0.8),
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 2),
//                   ),
//                   child: const Icon(
//                     Icons.zoom_out_map,
//                     size: 16,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   Size _getSize(GlobalKey key) {
//     final RenderBox? renderBox =
//     key.currentContext?.findRenderObject() as RenderBox?;
//     return renderBox?.size ?? Size.zero;
//   }
//
//   Offset _constrainPosition(Offset position, Size elementSize) {
//     final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
//     if (renderBox == null) return position;
//
//     final Size imageSize = renderBox.size;
//
//     // Calculate maximum allowed positions
//     double maxX = imageSize.width - elementSize.width;
//     double maxY = imageSize.height - elementSize.height;
//
//     // Constrain the position
//     double x = position.dx.clamp(0.0, maxX);
//     double y = position.dy.clamp(0.0, maxY);
//
//     return Offset(x, y);
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';