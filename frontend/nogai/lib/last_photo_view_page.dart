import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'gallery_page.dart';
import 'camera_page.dart';

class LastPhotoViewPage extends StatelessWidget {
  final File imageFile;

  const LastPhotoViewPage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Photo'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.file(imageFile), // 촬영한 이미지 표시
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const GalleryPage()), 
                      (route) => false,
                    );
                  },
                  child: const Text('Gallery'), // 버튼 텍스트
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraPage(
                          onPictureTaken:
                              (Uint8List imageBytes, String savedPath) {
                            // 이미지 처리
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text('Retake'), // 버튼 텍스트
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
