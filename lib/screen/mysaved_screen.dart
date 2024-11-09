import 'dart:io';
import 'package:dcamera_application/services/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dcamera_application/screen/preview_screen.dart';
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
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
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
    currentIndex = widget.initialIndex;
  }

  void _showPreviousImage() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      }
    });
  }

  void _showNextImage() {
    setState(() {
      if (currentIndex < widget.images.length - 1) {
        currentIndex++;
      }
    });
  }

  Future<void> _shareImage() async {
    try {
      final file = widget.images[currentIndex];
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Check out this image!',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Image ${currentIndex + 1}/${widget.images.length}'),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: _shareImage,
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Image.file(
              widget.images[currentIndex],
              fit: BoxFit.contain,
            ),
          ),
          if (currentIndex > 0)
            Positioned(
              left: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 40, color: Colors.white),
                onPressed: _showPreviousImage,
              ),
            ),
          if (currentIndex < widget.images.length - 1)
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