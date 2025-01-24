import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'json_map/photo.dart';

class ClassificationPage extends StatefulWidget {
  final Photo photo;
  final List<Photo> photos;

  const ClassificationPage(
      {super.key, required this.photo, required this.photos});

  @override
  _ClassificationPageState createState() => _ClassificationPageState();
}

class _ClassificationPageState extends State<ClassificationPage> {
  String species = '';
  double confidence = 0.0;
  double inferenceTime = 0.0;
  bool isLoading = false;

  Future<void> sendImageToBackend(File imageFile, String modelOption,
      Function(String, double, double) onResult) async {
    setState(() {
      isLoading = true;
    });

    print('Sending image to backend with model option: $modelOption');

    final request = http.MultipartRequest('POST',
        Uri.parse('https://a645-121-150-54-218.ngrok-free.app/predict'));
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.fields['option'] = modelOption;

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final result = jsonDecode(responseData);
      print('Received response: $result');
      onResult(
          result['species'], result['confidence'], result['inference_time']);
    } else {
      print('Error: ${response.reasonPhrase}');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: widget.photos.length,
        controller:
            PageController(initialPage: widget.photos.indexOf(widget.photo)),
        itemBuilder: (context, index) {
          final currentPhoto = widget.photos[index];
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
                    if (isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
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
                          sendImageToBackend(File(currentPhoto.url), 'fast',
                              (s, c, i) {
                            setState(() {
                              species = s;
                              confidence = c;
                              inferenceTime = i;
                            });
                          });
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
                          sendImageToBackend(File(currentPhoto.url), 'balanced',
                              (s, c, i) {
                            setState(() {
                              species = s;
                              confidence = c;
                              inferenceTime = i;
                            });
                          });
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
                          sendImageToBackend(File(currentPhoto.url), 'accurate',
                              (s, c, i) {
                            setState(() {
                              species = s;
                              confidence = c;
                              inferenceTime = i;
                            });
                          });
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
                height: 200,
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
                                TextSpan(text: species),
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
                                TextSpan(text: '$confidence'),
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
                                TextSpan(
                                    text:
                                        '${inferenceTime.toStringAsFixed(4)} s'),
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
