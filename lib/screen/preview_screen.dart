import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dcamera_application/screen/camera_screen.dart';
import 'package:dcamera_application/services/ad_provider.dart';
import 'package:dcamera_application/services/permission_handler.dart';
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
import 'package:widget_zoom/widget_zoom.dart';

import '../controller/setting_controller.dart';
import 'edit_screen.dart';
import '../main.dart';

class MainImagePreviewScreen extends StatefulWidget {
  final XFile imageFile;
  final SettingsController settingsController = Get.find<SettingsController>();

  MainImagePreviewScreen({super.key, required this.imageFile});

  @override
  _MainImagePreviewScreenState createState() => _MainImagePreviewScreenState();
}

class _MainImagePreviewScreenState extends State<MainImagePreviewScreen> {
  final SettingsController settingsController = Get.put(SettingsController());

  bool _hasPermission = true;
  String _currentAddress = 'Fetching address...';
  late Position _currentPosition;
  final GlobalKey _screenshotKey = GlobalKey();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    AdProvider adProvider = Provider.of<AdProvider>(context, listen: false);
    adProvider.initializeHomePageBanner();
    adProvider.initializeFullPageAd();
    _getCurrentLocation();
  }

  String getCurrentDate() {
    return DateFormat('yyyy-MM-dd hh:mm:a').format(DateTime.now());
  }

  void _openEditScreen() {
    AdProvider adProvider = Provider.of<AdProvider>(context, listen: false);
    if (adProvider.isFullPageAdLoaded) {
      adProvider.fullPageAd.show();
    }
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
    AdProvider adProvider = Provider.of<AdProvider>(context, listen: false);
    if (adProvider.isFullPageAdLoaded) {
      adProvider.fullPageAd.show();
    }
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
                ? CupertinoActivityIndicator(color: Colors.black)
                : Icon(Icons.download_rounded),
          ),
        ],
      ),
      body: Center(
        child: RepaintBoundary(
          key: _screenshotKey,
          child: Stack(
            children: [
              WidgetZoom(
                heroAnimationTag: 'tag',
                zoomWidget: Image.file(
                  File(widget.imageFile.path),
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
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
                                  fontSize:
                                      settingsController.dateFontSize.value),
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
                                  color: settingsController
                                      .locationTextColor.value,
                                  fontSize: settingsController
                                      .locationFontSize.value),
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
      bottomNavigationBar:
          Consumer<AdProvider>(builder: (context, adProvider, child) {
        if (adProvider.isHomePageBannerLoaded) {
          return Container(
            height: 50,
            width: double.infinity,
            child: AdWidget(ad: adProvider.homePageBanner),
          );
        } else {
          return Container(
            height: 10,
            width: 100,
            child: AdWidget(ad: adProvider.homePageBanner),
          );
        }
      }),
    );
  }
}


