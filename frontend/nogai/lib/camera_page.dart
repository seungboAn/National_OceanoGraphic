import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'last_photo_view_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraPage extends StatefulWidget {
  final Function(Uint8List, String) onPictureTaken;

  const CameraPage({super.key, required this.onPictureTaken});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with SingleTickerProviderStateMixin {
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  bool isCameraInitialized = false;
  bool isFlashVisible = false;
  File? lastPhoto;
  int selectedCameraIndex = 0;
  late AnimationController _flashAnimationController;
  late Animation<double> _flashAnimation;

  @override
  void initState() {
    super.initState();
    initializeCamera(); // 카메라 초기화
    _flashAnimationController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );
    _flashAnimation = Tween<double>(begin: 0.0, end: 0.5)
        .animate(_flashAnimationController); // 플래시 애니메이션 설정
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras(); // 사용 가능한 카메라 가져오기
      final prefs = await SharedPreferences.getInstance();
      selectedCameraIndex =
          prefs.getInt('selectedCameraIndex') ?? 0; // 선택된 카메라 인덱스 가져오기
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras[selectedCameraIndex],
          ResolutionPreset.high,
        );
        await _cameraController.initialize(); // 카메라 컨트롤러 초기화
        setState(() {
          isCameraInitialized = true; // 카메라 초기화 상태 업데이트
        });
      } else {
        print("No cameras available"); // 사용 가능한 카메라가 없을 때
      }
    } catch (e) {
      print("Error initializing camera: $e"); // 카메라 초기화 오류 처리
    }
  }

  void switchCamera() async {
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length; // 카메라 전환
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'selectedCameraIndex', selectedCameraIndex); // 선택된 카메라 인덱스 저장
    initializeCamera(); // 카메라 다시 초기화
  }

  @override
  void dispose() {
    _cameraController.dispose(); // 카메라 컨트롤러 해제
    _flashAnimationController.dispose(); // 플래시 애니메이션 컨트롤러 해제
    super.dispose();
  }

  Future<void> takePicture() async {
    if (!isCameraInitialized) {
      print("Camera is not initialized"); // 카메라가 초기화되지 않았을 때
      return;
    }

    try {
      setState(() {
        isFlashVisible = true; // 플래시 표시
      });
      _flashAnimationController.forward(from: 0.0); // 플래시 애니메이션 시작

      final now = DateTime.now();
      final formattedDate =
          "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}.jpg";
      print('Formatted date: $formattedDate'); // 날짜 형식 지정

      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        print(
            "Error: Unable to access external storage directory."); // 외부 저장소 디렉토리에 접근할 수 없을 때
        return;
      }
      final imagePath = '${directory.path}/DCIM/Camera/$formattedDate';
      print('Saving image to: $imagePath'); // 이미지 저장 경로

      final image = await _cameraController.takePicture(); // 사진 촬영
      final newFile = await File(image.path).copy(imagePath); // 이미지 파일 복사
      print('Image saved: ${newFile.existsSync()}'); // 이미지 저장 확인

      await Future.delayed(const Duration(milliseconds: 50));
      _flashAnimationController.reverse().then((_) {
        setState(() {
          isFlashVisible = false; // 플래시 숨기기
        });
      });

      setState(() {
        lastPhoto = newFile; // 마지막 사진 업데이트
      });

      widget.onPictureTaken(
          await newFile.readAsBytes(), imagePath); // 사진 촬영 콜백 호출
    } catch (e) {
      print("Error taking picture: $e"); // 사진 촬영 오류 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Camera"),
          centerTitle: true,
        ),
        body: Center(child: CircularProgressIndicator()), // 카메라 초기화 중 로딩 표시
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Camera"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Transform.rotate(
              angle: 0, // 세로 모드로 고정
              child: CameraPreview(_cameraController), // 카메라 미리보기
            ),
          ),
          if (isFlashVisible)
            FadeTransition(
              opacity: _flashAnimation,
              child: Container(
                color: Colors.white.withAlpha((0.5 * 255).toInt()), // 플래시 효과
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (lastPhoto != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LastPhotoViewPage(
                                imageFile: lastPhoto!), // 마지막 사진 보기 페이지로 이동
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: lastPhoto != null
                            ? DecorationImage(
                                image: FileImage(lastPhoto!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: takePicture, // 사진 촬영
                    child: Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: switchCamera, // 카메라 전환
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.flip_camera_android,
                          color: const Color.fromARGB(255, 134, 109, 109),
                          size: 30.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
