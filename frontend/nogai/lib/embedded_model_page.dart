import 'package:flutter/material.dart';
import 'camera_page.dart';
import 'gallery_page.dart'; // Import the gallery page
import 'dart:typed_data'; // Import if needed

class EmbeddedModelPage extends StatelessWidget {
  const EmbeddedModelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/aijelly.png',
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 16.0,
            right: 16.0,
            child: IconButton(
              icon: Icon(Icons.photo, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GalleryPage(),
                  ),
                );
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Embedded Model Description',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Text(
                    "NOG's Embedded Model technology leverages lightweight models like MobileNet and EfficientNet, enabling seamless integration into underwater exploration robots and camera equipment. This on-device capability ensures efficient and real-time processing, enhancing the performance and autonomy of your marine exploration tools.\n\n"
                    ' 우리의 Embedded Model 기술은 MobileNet 및 EfficientNet과 같이 연산 효율성을 극대화한 경량 모델을 활용하여 해저 탐사 로봇 및 카메라 장비에 원활하게 통합됩니다. 이 온디바이스 기능은 효율적이고 실시간 처리를 보장하여 해양 탐사 도구의 성능과 자율성을 향상시킵니다.',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 350,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        'assets/acc1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20.0,
            right: 16.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(128),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.camera_alt, size: 30.0, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CameraPage(onPictureTaken: addPhoto),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addPhoto(Uint8List image, String path) {
    print("Photo added at path: $path");
  }
}
