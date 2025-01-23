import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'json_map/photo.dart';
import 'camera_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'photo_detail_page.dart';
import 'package:crypto/crypto.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  GalleryPageState createState() => GalleryPageState();
}

class GalleryPageState extends State<GalleryPage> {
  List<Photo> photos = [];
  Set<int> selectedPhotos = {};
  bool isSelectionMode = false; // Track selection mode

  @override
  void initState() {
    super.initState();
    _loadPhotos().then((_) => _updatePhotoIds());
  }

  Future<void> _loadPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('photos');
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      setState(() {
        photos = jsonList.map((e) => Photo.fromJson(e)).toList();
        photos.sort((a, b) => b.url.compareTo(a.url)); // 갤러리 SORTING 방식
      });
    }
  }

  Future<void> _savePhotos() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString =
        jsonEncode(photos.map((e) => e.toJson()).toList());
    await prefs.setString('photos', jsonString);
  }

  Future<void> _updatePhotoIds() async {
    setState(() {
      for (var photo in photos) {
        final fileName = photo.url.split('/').last;
        final bytes = utf8.encode(fileName);
        final digest = sha256.convert(bytes);
        photo.id = digest.hashCode;
      }
    });
    await _savePhotos();
  }

  void _toggleSelectionMode() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      if (!isSelectionMode) {
        selectedPhotos.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isSelectionMode
                ? "${selectedPhotos.length} Selected"
                : "National Oceanographic",
            style: TextStyle(fontSize: 15.0)),
        centerTitle: true,
        actions: [
          if (isSelectionMode)
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: _toggleSelectionMode,
            ),
          if (isSelectionMode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: confirmDeleteSelectedPhotos,
            ),
          if (!isSelectionMode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _toggleSelectionMode,
            ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/ocean2.png',
            fit: BoxFit.cover,
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              final isSelected = selectedPhotos.contains(photo.id);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelectionMode) {
                      if (isSelected) {
                        selectedPhotos.remove(photo.id);
                      } else {
                        selectedPhotos.add(photo.id);
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PhotoDetailPage(photo: photo, photos: photos),
                        ),
                      );
                    }
                  });
                },
                child: Stack(
                  children: [
                    Image.file(
                      File(photo.url),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    if (isSelectionMode)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? Colors.blue : Colors.white,
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            isSelected ? Icons.check : null,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: isSelectionMode
          ? FloatingActionButton(
              onPressed: confirmDeleteSelectedPhotos,
              child: Icon(Icons.delete),
            )
          : FloatingActionButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        CameraPage(onPictureTaken: addPhoto),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.fastOutSlowIn;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
              backgroundColor: Colors.white,
              shape: CircleBorder(),
              child: Icon(Icons.camera_alt, size: 30, color: Colors.grey),
            ),
    );
  }

  void confirmDeleteSelectedPhotos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Photos"),
          content: Text("Are you sure you want to delete the selected photos?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteSelectedPhotos();
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void deleteSelectedPhotos() {
    setState(() {
      photos.removeWhere((photo) {
        if (selectedPhotos.contains(photo.id)) {
          try {
            File(photo.url).deleteSync(); // Attempt to delete the file
            print('Deleted file: ${photo.url}');
          } catch (e) {
            print('Error deleting file: ${photo.url}, $e');
          }
          return true;
        }
        return false;
      });
      selectedPhotos.clear();
      isSelectionMode = false;
    });
    _savePhotos();
    print('Selected IDs: $selectedPhotos');
    print('Photo IDs: ${photos.map((photo) => photo.id).toList()}');
  }

  void addPhoto(Uint8List imageBytes, String savedPath) {
    final fileName = savedPath.split('/').last;
    print('Saved path: $savedPath');
    print('Extracted file name: $fileName');
    setState(() {
      final newPhoto = Photo(
        id: DateTime.now().millisecondsSinceEpoch, // Ensure unique ID
        url: savedPath,
        title: fileName,
      );
      photos.add(newPhoto);
    });
    _savePhotos();
  }
}
