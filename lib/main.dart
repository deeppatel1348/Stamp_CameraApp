import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dcamera_application/controller/setting_controller.dart';
import 'package:dcamera_application/screen/camera_screen.dart';
import 'package:dcamera_application/screen/preview_screen.dart';
import 'package:dcamera_application/screen/splashscreen.dart';
import 'package:dcamera_application/services/ad_provider.dart';
import 'package:dcamera_application/screen/setting_page.dart';
import 'package:dcamera_application/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AdProvider>(create: (context) => AdProvider())
      ],
      child: GetMaterialApp(
        title: 'Custom Camera App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen()
      ),
    );
  }
}

