
import 'package:camera/camera.dart';
import 'package:dcamera_application/controller/setting_controller.dart';
import 'package:dcamera_application/screen/preview_screen.dart';
import 'package:dcamera_application/services/ad_provider.dart';
import 'package:dcamera_application/screen/setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String _currentAddress = 'Fetching address...';
  late Position _currentPosition;

  late CameraController _cameraController;
  XFile? _imageFile;
  FlashMode _flashMode = FlashMode.off; // Default flash mode is off
  final ImagePicker _picker = ImagePicker(); // For picking gallery images

  SettingsController settingsController = Get.put(SettingsController());

  @override
  void initState() {
    super.initState();
    AdProvider adProvider = Provider.of<AdProvider>(context, listen: false);
    adProvider.initializeHomePageBanner();
    _cameraController =
        CameraController(cameras[0], ResolutionPreset.ultraHigh);
    _getCurrentLocation();

    _cameraController.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void deactivate() {
    print("flash mode ");
  } // Method to toggle flash

  void _toggleFlash() {
    setState(() {
      _flashMode =
      (_flashMode == FlashMode.off) ? FlashMode.torch : FlashMode.off;
      _cameraController.setFlashMode(_flashMode);
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

  // Method to pick an image from the gallery
  Future<void> _pickFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _imageFile = XFile(pickedFile.path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainImagePreviewScreen(imageFile: _imageFile!),
        ),
      );
    }
  }

  Future<void> _takePicture() async {
    if (!_cameraController.value.isInitialized) return;

    try {
      _imageFile = await _cameraController.takePicture();
      if (_imageFile != null) {
        // Turn off the flash after capturing the image
        await _cameraController.setFlashMode(FlashMode.off);

        // Navigate to the ImagePreviewScreen with the captured image
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MainImagePreviewScreen(imageFile: _imageFile!),
          ),
        );
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Center(child: CupertinoActivityIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      // extendBody: true,
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   toolbarHeight: 0,
      //   backgroundColor: Colors.black,
      // ),

      body: Center(
        child: CameraPreview(
            child: Align(
              alignment: Alignment(0.95, -1),
              child: IconButton(
                icon: Icon(size: 30, Icons.settings, color: Colors.white),
                onPressed: () {
                  Get.to(SettingPage());
                }, // Call method to open settings
              ),
            ),
            _cameraController),
      ),


      floatingActionButton:  Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // Distribute buttons evenly
        children: [
          Container(
            height: 50,
            width: 50,
            child: IconButton(
              onPressed: _pickFromGallery,
              icon: Icon(
                Icons.photo,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.white),
            child: IconButton(
              onPressed: _takePicture,
              icon: Icon(Icons.camera),
            ),
          ),
          Container(
            height: 45,
            width: 45,
            child: IconButton(
              onPressed: _toggleFlash,
              icon: Icon(
                _flashMode == FlashMode.off
                    ? Icons.flash_off
                    : Icons.flash_on,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Consumer<AdProvider>(builder: (context, adProvider ,child){
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
}