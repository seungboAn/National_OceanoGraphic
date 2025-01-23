import 'dart:io';
import 'package:flutter/material.dart';
import 'json_map/photo.dart';

class ClassificationPage extends StatelessWidget {
  final Photo photo;
  final List<Photo> photos;

  const ClassificationPage(
      {super.key, required this.photo, required this.photos});

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

                    // 모델 선택 버튼
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          // Classification 로직 추가
                        },
                        child: Text(
                          '   Fast Model   ',
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 145,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          // Classification 로직 추가
                        },
                        child: Text(
                          'Balanced Model',
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 16,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          // Classification 로직 추가
                        },
                        child: Text(
                          'Accurate Model',
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Backend Response Print
              SizedBox(
                height: 200, // Fixed height for the response section
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/seabottom.png',
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Model Responses',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: '\n'),
                              ],
                            ),
                            style: TextStyle(fontSize: 14),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '* Species : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                // TextSpan(text: '${species}'),
                              ],
                            ),
                            style: TextStyle(fontSize: 14),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '* Confidence : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                // TextSpan(text: confidence),
                              ],
                            ),
                            style: TextStyle(fontSize: 14),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '* Inference Time : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                // TextSpan(text: inferenceTime),
                              ],
                            ),
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
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
