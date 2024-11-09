import 'dart:io';

import 'package:dcamera_application/main.dart';
import 'package:dcamera_application/services/ad_provider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/setting_controller.dart';

class DefaultPositionScreen extends StatefulWidget {
  const DefaultPositionScreen({Key? key}) : super(key: key);

  @override
  State<DefaultPositionScreen> createState() => _DefaultPositionScreenState();
}

class _DefaultPositionScreenState extends State<DefaultPositionScreen> {
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

  String _currentAddress = 'Fetching address...';
  late Position _currentPosition;
  late Size _containerSize = Size.zero;
  late Rect _imageBounds = Rect.zero;
  bool _isInitialized = false;

  final SettingsController settingsController = Get.find<SettingsController>();

  @override
  void initState() {
    super.initState();
    AdProvider adProvider = Provider.of<AdProvider>(context, listen: false);
    adProvider.initializeHomePageBanner();
    _loadSavedPositions();
    _getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeBounds();
    });
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


  Future<void> _loadSavedPositions() async {
    final prefs = await SharedPreferences.getInstance();

    // Load positions with defaults if not found
    _datePosition = Rx<Offset>(Offset(
      prefs.getDouble('default_date_position_x') ??
          settingsController.datePosition.value.dx,
      prefs.getDouble('default_date_position_y') ??
          settingsController.datePosition.value.dy,
    ));

    _locationPosition = Rx<Offset>(Offset(
      prefs.getDouble('default_location_position_x') ??
          settingsController.locationPosition.value.dx,
      prefs.getDouble('default_location_position_y') ??
          settingsController.locationPosition.value.dy,
    ));

    _logoPosition = Rx<Offset>(Offset(
      prefs.getDouble('default_logo_position_x') ??
          settingsController.logoPosition.value.dx,
      prefs.getDouble('default_logo_position_y') ??
          settingsController.logoPosition.value.dy,
    ));

    _logoSize = RxDouble(prefs.getDouble('default_logo_size') ??
        settingsController.logoSize.value);
    _dateFontSize = RxDouble(prefs.getDouble('default_date_font_size') ??
        settingsController.dateFontSize.value);
    _locationFontSize = RxDouble(
        prefs.getDouble('default_location_font_size') ??
            settingsController.locationFontSize.value);

    setState(() {});
  }

  Future<void> _savePositions() async {
    final prefs = await SharedPreferences.getInstance();

    // Save positions to SharedPreferences
    await prefs.setDouble('default_date_position_x', _datePosition.value.dx);
    await prefs.setDouble('default_date_position_y', _datePosition.value.dy);
    await prefs.setDouble(
        'default_location_position_x', _locationPosition.value.dx);
    await prefs.setDouble(
        'default_location_position_y', _locationPosition.value.dy);
    await prefs.setDouble('default_logo_position_x', _logoPosition.value.dx);
    await prefs.setDouble('default_logo_position_y', _logoPosition.value.dy);
    await prefs.setDouble('default_logo_size', _logoSize.value);
    await prefs.setDouble('default_date_font_size', _dateFontSize.value);
    await prefs.setDouble(
        'default_location_font_size', _locationFontSize.value);

    // Update SettingsController values
    settingsController.datePosition.value = _datePosition.value;
    settingsController.locationPosition.value = _locationPosition.value;
    settingsController.logoPosition.value = _logoPosition.value;
    settingsController.logoSize.value = _logoSize.value;
    settingsController.dateFontSize.value = _dateFontSize.value;
    settingsController.locationFontSize.value = _locationFontSize.value;

    // Save to SettingsController's SharedPreferences
    settingsController.saveDatePosition(_datePosition.value);
    settingsController.saveLocationPosition(_locationPosition.value);
    settingsController.saveLogoPosition(_logoPosition.value);
    await settingsController.savePreference('logoSize', _logoSize.value);
    await settingsController.savePreference(
        'dateFontSize', _dateFontSize.value);
    await settingsController.savePreference(
        'locationFontSize', _locationFontSize.value);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Default positions saved successfully')),
    );
    Get.offAll(CameraScreen());
  }

  void _initializeBounds() {
    final RenderBox? containerBox =
    _imageContainerKey.currentContext?.findRenderObject() as RenderBox?;
    if (containerBox != null) {
      _containerSize = containerBox.size;

      // Load the asset image and calculate bounds
      AssetImage('assets/default16,9.jpg')
          .resolve(ImageConfiguration())
          .addListener(ImageStreamListener((info, _) {
        final imageWidth = info.image.width.toDouble();
        final imageHeight = info.image.height.toDouble();
        final imageAspectRatio = imageWidth / imageHeight;
        final containerAspectRatio =
            _containerSize.width / _containerSize.height;

        double imageDisplayWidth;
        double imageDisplayHeight;
        double offsetX = 0;
        double offsetY = 0;

        if (imageAspectRatio > containerAspectRatio) {
          imageDisplayWidth = _containerSize.width;
          imageDisplayHeight = imageDisplayWidth / imageAspectRatio;
          offsetY = (_containerSize.height - imageDisplayHeight) / 2;
        } else {
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

  String getCurrentDate() {
    return DateFormat('yyyy-MM-dd hh:mm:a').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("Set Default Positions"),
        actions: [
          IconButton(
            onPressed: _savePositions,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        key: _imageContainerKey,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image

            Image.asset(
              'assets/default16,9.jpg',
              fit: BoxFit.contain,
            ),
            if (_isInitialized) ...[
              // Date
              Obx(() {
                return settingsController.showDateTime.value
                    ? _buildDraggableTextContainer(
                  key: _dateKey,
                  position: _datePosition.value,
                  text: getCurrentDate(),
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
                  text: _currentAddress,
                  fontSize: _locationFontSize.value,
                  onPositionChange: (newPosition) {
                    _locationPosition.value = _constrainPosition(
                      newPosition,
                      _getSize(_locationKey),
                    );
                  },
                  onFontSizeChange: (delta) {
                    _locationFontSize.value =
                        (_locationFontSize.value + delta)
                            .clamp(5.0, 20.0);
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
              child: settingsController.logoImagePath.value.isNotEmpty
                  ? Image.file(
                File(settingsController.logoImagePath.value),
                width: _logoSize.value,
                height: _logoSize.value,
                fit: BoxFit.contain,
              )
                  : Image.asset(
                'assets/logo.png',
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
                double newSize =
                (_logoSize.value + details.delta.dy).clamp(50.0, 200.0);
                _logoSize.value = newSize;
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
    final RenderBox? renderBox =
    key.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size ?? Size.zero;
  }

  Offset _constrainPosition(Offset position, Size elementSize) {
    if (!_isInitialized) return position;

    double maxX = _imageBounds.right - elementSize.width;
    double maxY = _imageBounds.bottom - elementSize.height;

    double x = position.dx.clamp(_imageBounds.left, maxX);
    double y = position.dy.clamp(_imageBounds.top, maxY);

    return Offset(x, y);
  }
}





// Future<void> _loadSavedPositions() async {
//   final prefs = await SharedPreferences.getInstance();
//
//   // Load positions with defaults if not found
//   _datePosition = Rx<Offset>(Offset(
//     prefs.getDouble('default_date_position_x') ?? 20.0,
//     prefs.getDouble('default_date_position_y') ?? 20.0,
//   ));
//
//   _locationPosition = Rx<Offset>(Offset(
//     prefs.getDouble('default_location_position_x') ?? 20.0,
//     prefs.getDouble('default_location_position_y') ?? 60.0,
//   ));
//
//   _logoPosition = Rx<Offset>(Offset(
//     prefs.getDouble('default_logo_position_x') ?? 20.0,
//     prefs.getDouble('default_logo_position_y') ?? 100.0,
//   ));
//
//   _logoSize = RxDouble(prefs.getDouble('default_logo_size') ?? 100.0);
//   _dateFontSize = RxDouble(prefs.getDouble('default_date_font_size') ?? 14.0);
//   _locationFontSize = RxDouble(prefs.getDouble('default_location_font_size') ?? 14.0);
//
//   setState(() {});
// }

// Future<void> _savePositions() async {
//   final prefs = await SharedPreferences.getInstance();
//
//   // Save positions
//   await prefs.setDouble('default_date_position_x', _datePosition.value.dx);
//   await prefs.setDouble('default_date_position_y', _datePosition.value.dy);
//   await prefs.setDouble('default_location_position_x', _locationPosition.value.dx);
//   await prefs.setDouble('default_location_position_y', _locationPosition.value.dy);
//   await prefs.setDouble('default_logo_position_x', _logoPosition.value.dx);
//   await prefs.setDouble('default_logo_position_y', _logoPosition.value.dy);
//
//   // Save sizes
//   await prefs.setDouble('default_logo_size', _logoSize.value);
//   await prefs.setDouble('default_date_font_size', _dateFontSize.value);
//   await prefs.setDouble('default_location_font_size', _locationFontSize.value);
//
//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(content: Text('Default positions saved successfully')),
//   );
// }