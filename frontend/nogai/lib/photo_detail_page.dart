import 'dart:io';
import 'package:flutter/material.dart';
import 'json_map/photo.dart';
import 'ai_powered_page/ai_edit_page.dart';
import 'classification_page.dart';

class PhotoDetailPage extends StatelessWidget {
  final Photo photo;
  final List<Photo> photos;

  const PhotoDetailPage({super.key, required this.photo, required this.photos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: photos.length,
        controller: PageController(initialPage: photos.indexOf(photo)),
        itemBuilder: (context, index) {
          final currentPhoto = photos[index];
          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Image.file(
                      File(currentPhoto.url),
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Text('Error loading image'));
                      },
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white, width: 2),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClassificationPage(
                                  photo: currentPhoto, photos: photos),
                            ),
                          );
                        },
                        child: Text(
                          'Classification',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      right: 16,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        elevation: 5,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AIEditPage(imageFile: File(photo.url)),
                            ),
                          );
                        },
                        shape: CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/gemini.png',
                              fit: BoxFit.cover,
                              width: 50.0,
                              height: 50.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'ID: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '${currentPhoto.id}'),
                        ],
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'URL: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: currentPhoto.url),
                        ],
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Title: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: currentPhoto.title),
                        ],
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
