import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // For getting app directory

class AutoShowLastImage extends StatefulWidget {
  @override
  _AutoShowLastImageState createState() => _AutoShowLastImageState();
}

class _AutoShowLastImageState extends State<AutoShowLastImage> {
  File? _latestImage; // To store the last added image

  @override
  void initState() {
    super.initState();
    // Load the latest image when the app starts
    _loadLatestImage();
  }

  // Function to get the most recent image from a directory
  Future<void> _loadLatestImage() async {
    // Get the directory where images are stored
    Directory appDir = await getApplicationDocumentsDirectory();
    String imagePath = appDir.path;

    // Get the list of files in the directory
    List<FileSystemEntity> files = Directory(imagePath).listSync()
      ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

    // Filter the files to get only images
    List<FileSystemEntity> imageFiles = files.where((file) {
      return file.path.endsWith(".png") || file.path.endsWith(".jpg");
    }).toList();

    // Check if there are any images, and get the latest one
    if (imageFiles.isNotEmpty) {
      setState(() {
        _latestImage = File(imageFiles.first.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Last Added Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _latestImage != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _latestImage!,
                  fit: BoxFit.cover,
                ),
              )
                  : Center(child: Text('No image available')),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadLatestImage, // Button to manually reload the latest image
              child: Text('Reload Latest Image'),
            ),
          ],
        ),
      ),
    );
  }
}
