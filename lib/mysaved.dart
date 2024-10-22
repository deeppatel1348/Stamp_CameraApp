import 'dart:io';

import 'package:dcamera_application/preview_image.dart';
import 'package:flutter/material.dart';

class ImageGalleryScreen extends StatefulWidget {
  @override
  _ImageGalleryScreenState createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  late Future<List<File>> _imagesFuture;

  @override
  void initState() {
    super.initState();
    _imagesFuture = ScreenshotUtility.getSavedImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Image'),
      ),
      body: FutureBuilder<List<File>>(
        future: _imagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('No Saved Found'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No screenshots found.'));
          }

          final List<File> images = snapshot.data!;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Display 2 images per row
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // When the image is tapped, open the full screen viewer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageViewer(
                        images: images,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: Image.file(
                  images[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class FullScreenImageViewer extends StatefulWidget {
  final List<File> images;
  final int initialIndex;

  FullScreenImageViewer({
    required this.images,
    required this.initialIndex,
  });

  @override
  _FullScreenImageViewerState createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex; // Set the initial image index
  }

  void _showPreviousImage() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--; // Navigate to the previous image
      }
    });
  }

  void _showNextImage() {
    setState(() {
      if (currentIndex < widget.images.length - 1) {
        currentIndex++; // Navigate to the next image
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Image ${currentIndex + 1}/${widget.images.length}'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Display the image
          Center(
            child: Image.file(
              widget.images[currentIndex],
              fit: BoxFit.contain,
            ),
          ),
          // Previous button
          if (currentIndex > 0) // Only show if not the first image
            Positioned(
              left: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 40, color: Colors.white),
                onPressed: _showPreviousImage,
              ),
            ),
          // Next button
          if (currentIndex < widget.images.length - 1) // Only show if not the last image
            Positioned(
              right: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios, size: 40, color: Colors.white),
                onPressed: _showNextImage,
              ),
            ),
        ],
      ),
    );
  }
}
