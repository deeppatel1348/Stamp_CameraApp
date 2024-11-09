import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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

      // Get the appropriate directory for gallery visibility
      final String dirPath = await _getGalleryStoragePath();
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

      final ui.Image image = await boundary.toImage(pixelRatio: 6.0);
      final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to generate image data');
      }

      // Save the screenshot
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final String filePath = '${directory.path}/photostamp$timestamp.png';
      final File file = File(filePath);
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // Make image appear in gallery
      await _updateGallery(filePath);

      return filePath;
    } catch (e) {
      throw Exception('Failed to capture screenshot: $e');
    }
  }

  static Future<List<File>> getSavedImages() async {
    final String dirPath = await _getGalleryStoragePath();
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

  static Future<String> _getGalleryStoragePath() async {
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/DCIM/ZionCamera');
      return directory.path;
    } else {
      final appDir = await getApplicationDocumentsDirectory();
      return '${appDir.path}/ZionCamera';
    }
  }

  static Future<void> _updateGallery(String filePath) async {
    if (Platform.isAndroid) {
      // Notify media scanner to add the file to the gallery
      final file = File(filePath);
      await file.exists();
      await Process.run('am', ['broadcast', '-a', 'android.intent.action.MEDIA_SCANNER_SCAN_FILE', '-d', 'file://$filePath']);
    }
  }
}
