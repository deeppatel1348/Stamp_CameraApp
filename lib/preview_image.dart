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
import 'edite.dart';
import 'main.dart';

class MainImagePreviewScreen extends StatefulWidget {
  final XFile imageFile;
  final SettingsController settingsController = Get.find<SettingsController>();

  MainImagePreviewScreen({super.key, required this.imageFile});

  @override
  _MainImagePreviewScreenState createState() => _MainImagePreviewScreenState();
}

class _MainImagePreviewScreenState extends State<MainImagePreviewScreen> {
  Offset _datePosition = Offset(100, 100);
  Offset _locationPosition = Offset(100, 200);
  Offset _logoPosition = Offset(100, 300);
  double _logoSize = 60;
  double _dateFontSize = 20;
  double _locationFontSize = 20;
  final SettingsController settingsController = Get.put(SettingsController());

  bool _hasPermission = true;
  String _currentAddress = 'Fetching address...';
  late Position _currentPosition;
  final GlobalKey _screenshotKey = GlobalKey();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // _checkAndInitializePermissions();
    // _initializePermissions();
   _getCurrentLocation();
  }

  String getCurrentDate() {
    return DateFormat('yyyy-MM-dd hh:mm:a').format(DateTime.now());
  }

  // void _openEditScreen() {
  //   if (widget.imageFile != null) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => EditPositionScreen(
  //           imageFile: widget.imageFile,
  //           datePosition: _datePosition,
  //           locationPosition: _locationPosition,
  //           logoPosition: _logoPosition,
  //           date: getCurrentDate(),
  //           location: _currentAddress,
  //           logoImagePath: settingsController.logoImagePath.value,
  //           logoSize: _logoSize,
  //           dateFontSize: _dateFontSize,
  //           locationFontSize: _locationFontSize,
  //           onPositionUpdated: (
  //             newDatePosition,
  //             newLocationPosition,
  //             newLogoPosition,
  //             newDateFontSize,
  //             newLocationFontSize,
  //             newLogoSize,
  //           ) {
  //             setState(() {
  //               _datePosition = newDatePosition;
  //               _locationPosition = newLocationPosition;
  //               _logoPosition = newLogoPosition;
  //               _dateFontSize = newDateFontSize;
  //               _locationFontSize = newLocationFontSize;
  //               _logoSize = newLogoSize;
  //             });
  //           },
  //         ),
  //       ),
  //     );
  //   }
  // }
  void _openEditScreen() {
    if (widget.imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPositionScreen(
            imageFile: widget.imageFile,
            datePosition: settingsController.datePosition.value,
            locationPosition: settingsController.locationPosition.value,
            logoPosition: settingsController.logoPosition.value,
            date: getCurrentDate(),

            location: _currentAddress,
            logoImagePath: settingsController.logoImagePath.value,
            logoSize: settingsController.logoSize.value,
            dateFontSize: settingsController.dateFontSize.value,
            locationFontSize: settingsController.locationFontSize.value,
            onPositionUpdated: (
                newDatePosition,
                newLocationPosition,
                newLogoPosition,
                newDateFontSize,
                newLocationFontSize,
                newLogoSize,
                ) {
              setState(() {
                settingsController.datePosition.value = newDatePosition;
                settingsController.locationPosition.value = newLocationPosition;
                settingsController.logoPosition.value = newLogoPosition;
                settingsController.dateFontSize.value = newDateFontSize;
                settingsController.locationFontSize.value = newLocationFontSize;
                settingsController.logoSize.value = newLogoSize;
              });
            },
          ),
        ),
      );
    }
  }


  Future<void> _initializePermissions() async {
    try {
      await PermissionService.initializePermissions();
    } catch (e) {
      print('Permission initialization error: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Location permissions are permanently denied. Please enable them in settings.'),
        ),
      );
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await _getAddressFromLatLng();
    }
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _takeScreenshot() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final filePath = await ScreenshotUtility.captureAndSaveScreenshot(
        _screenshotKey,
        context,
      );

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Screenshot saved to: $filePath'),
          duration: Duration(seconds: 3),
        ),
      );

      // Navigate back to the CameraScreen after saving the screenshot
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _checkAndInitializePermissions() async {
    try {
      _hasPermission = await PermissionService.initializePermissions();
      setState(() {});
    } catch (e) {
      print('Permission initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("Image Preview"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _openEditScreen,
          ),
          IconButton(
            onPressed: _isProcessing ? null : _takeScreenshot,
            icon: _isProcessing
                ? CupertinoActivityIndicator(color: Colors.white)
                : Icon(Icons.download_rounded),
          ),
        ],
      ),
      // body: Center(
      //   child: RepaintBoundary(
      //     key: _screenshotKey,
      //     child: Stack(
      //       children: [
      //         Image.file(
      //           File(widget.imageFile.path),
      //           fit: BoxFit.contain,
      //           width: double.infinity,
      //           height: double.infinity,
      //         ),
      //         // Overlay Date
      //         // Obx(() {
      //         //   return widget.settingsController.showDateTime.value
      //         //       ? Positioned(
      //         //     left: _datePosition.dx,
      //         //     top: _datePosition.dy,
      //         //     child: Text(
      //         //       getCurrentDate(),
      //         //       style: TextStyle(
      //         //           color: Colors.white, fontSize: _dateFontSize),
      //         //     ),
      //         //   )
      //         //       : Container(); // Show an empty container when the date is hidden
      //         // }),
      //         Obx(() {
      //           return widget.settingsController.showDateTime.value
      //               ? Positioned(
      //                   left: _datePosition.dx,
      //                   top: _datePosition.dy,
      //                   child: Container(
      //                       padding: EdgeInsets.all(8.0),
      //                       color: widget.settingsController.showDB.value
      //                           ? widget
      //                               .settingsController.dBackgroundColor.value
      //                               .withOpacity(0.3)
      //                           : Colors.transparent,
      //                       // Optional background color for text container
      //                       child: Text(
      //                         getCurrentDate(),
      //                         style: TextStyle(
      //                             color: widget
      //                                 .settingsController.dateTextColor.value,
      //                             fontSize: _dateFontSize),
      //                       )),
      //                 )
      //               : SizedBox();
      //         }),
      //         // Overlay Location
      //         Obx(() {
      //           return widget.settingsController.showLocation.value
      //               ? Positioned(
      //                   left: _locationPosition.dx,
      //                   top: _locationPosition.dy,
      //                   child: Container(
      //                       padding: const EdgeInsets.all(8.0),
      //                       color: widget.settingsController.showLB.value
      //                           ? widget
      //                               .settingsController.lBackgroundColor.value
      //                               .withOpacity(0.3)
      //                           : Colors.transparent,
      //                       // Optional background color for text container
      //                       child: Text(
      //                         _currentAddress,
      //                         style: TextStyle(
      //                             color: widget.settingsController
      //                                 .locationTextColor.value,
      //                             fontSize: _dateFontSize),
      //                       )),
      //                 )
      //               : Container(); // Show an empty container when the location is hidden
      //         }),
      //         // Overlay Logo
      //         Obx(() {
      //           return widget.settingsController.showLogo.value
      //               ? Positioned(
      //                   left: _logoPosition.dx,
      //                   top: _logoPosition.dy,
      //                   child: settingsController.logoImagePath.value.isNotEmpty
      //                       ? Image.file(
      //                           File(settingsController.logoImagePath.value),
      //                           width: _logoSize,
      //                           height: _logoSize,
      //                           fit: BoxFit.cover,
      //                         )
      //                       : Image.asset(
      //                           'assets/logo.png',
      //                           width: _logoSize,
      //                           height: _logoSize,
      //                           fit: BoxFit.cover,
      //                         ),
      //                 )
      //               : Container(); // Show an empty container when the logo is hidden
      //         }),
      //       ],
      //     ),
      //   ),
      // ),
      body: Center(
        child: RepaintBoundary(
          key: _screenshotKey,
          child: Stack(
            children: [
              Image.file(
                File(widget.imageFile.path),
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
              // Overlay Date
              Obx(() {
                return settingsController.showDateTime.value
                    ? Positioned(
                  left: settingsController.datePosition.value.dx,
                  top: settingsController.datePosition.value.dy,
                  child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: settingsController.showDB.value
                          ? settingsController.dBackgroundColor.value
                          .withOpacity(0.3)
                          : Colors.transparent,
                      child: Text(
                        getCurrentDate(),
                        style: TextStyle(
                            color: settingsController.dateTextColor.value,
                            fontSize: settingsController.dateFontSize.value),
                      )),
                )
                    : SizedBox();
              }),
              // Overlay Location
              Obx(() {
                return settingsController.showLocation.value
                    ? Positioned(
                  left: settingsController.locationPosition.value.dx,
                  top: settingsController.locationPosition.value.dy,
                  child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: settingsController.showLB.value
                          ? settingsController.lBackgroundColor.value
                          .withOpacity(0.3)
                          : Colors.transparent,
                      child: Text(
                        _currentAddress,
                        style: TextStyle(
                            color: settingsController.locationTextColor.value,
                            fontSize:
                            settingsController.locationFontSize.value),
                      )),
                )
                    : SizedBox();
              }),
              // Overlay Logo
              Obx(() {
                return settingsController.showLogo.value
                    ? Positioned(
                  left: settingsController.logoPosition.value.dx,
                  top: settingsController.logoPosition.value.dy,
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

class PermissionService {
  static Future<bool> initializePermissions() async {
    try {
      if (Platform.isAndroid) {
        // Request both permissions for all Android versions
        final storageStatus = await Permission.storage.request();
        final photosStatus = await Permission.photos.request();

        // For older Android versions, storage permission is enough
        if (storageStatus.isGranted) {
          return true;
        }

        // For newer Android versions, need both permissions
        return storageStatus.isGranted && photosStatus.isGranted;
      } else if (Platform.isIOS) {
        final status = await Permission.photos.request();
        return status.isGranted;
      }
      return false;
    } catch (e) {
      print('Permission initialization error: $e');
      return false;
    }
  }

  static Future<bool> checkPermissionStatus() async {
    try {
      if (Platform.isAndroid) {
        final storageStatus = await Permission.storage.status;
        final photosStatus = await Permission.photos.status;

        // Check if either permission is granted
        return storageStatus.isGranted || photosStatus.isGranted;
      } else if (Platform.isIOS) {
        return await Permission.photos.status.isGranted;
      }
      return false;
    } catch (e) {
      print('Permission check error: $e');
      return false;
    }
  }
}

class ScreenshotUtility {
  static Future<String> captureAndSaveScreenshot(
      GlobalKey key, BuildContext context) async {
    try {
      // Check and request permissions
      bool hasPermission = await PermissionService.checkPermissionStatus();

      if (!hasPermission) {
        hasPermission = await PermissionService.initializePermissions();
      }

      if (!hasPermission) {
        // Show settings dialog if permission denied
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Permission Required'),
            content: Text('Storage permission is required to save screenshots. '
                'Please enable it in app settings.'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Open Settings'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await openAppSettings();
                },
              ),
            ],
          ),
        );
        throw Exception('Storage permission not granted');
      }

      // Get the appropriate directory
      final String dirPath = await _getStoragePath();
      final directory = Directory(dirPath);

      // Create directory if it doesn't exist
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Capture the screenshot
      final RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Add delay for rendering
      await Future.delayed(const Duration(milliseconds: 100));

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to generate image data');
      }

      // Save the screenshot
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final String filePath = '${directory.path}/screenshot_$timestamp.png';
      final File file = File(filePath);
      await file.writeAsBytes(byteData.buffer.asUint8List());

      return filePath;
    } catch (e) {
      throw Exception('Failed to capture screenshot: $e');
    }
  }


  static Future<List<File>> getSavedImages() async {
    final String dirPath = await _getStoragePath();
    final directory = Directory(dirPath);

    // Check if the directory exists
    if (await directory.exists()) {
      // List all files in the directory
      List<FileSystemEntity> files = directory.listSync();
      // Filter only PNG files (assuming screenshots are saved as PNG)
      List<File> imageFiles = files
          .whereType<File>()
          .where((file) => file.path.endsWith('.png'))
          .toList();

      return imageFiles;
    } else {
      throw Exception('Directory does not exist');
    }
  }

  static Future<String> _getStoragePath() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Could not access external storage');
      }
      return '${directory.path}/flutterstamp';
    } else {
      final appDir = await getApplicationDocumentsDirectory();
      return '${appDir.path}/flutterstamp';
    }
  }
}
