import 'package:flutter/material.dart';
import 'embedded_model_page.dart';
import 'research_model_page.dart';
import 'gallery_page.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  _CompanyProfileState createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startProfile();
  }

  Future<void> _startProfile() async {
    // 약간의 지연 후 애니메이션 시작
    await Future.delayed(const Duration(milliseconds: 50));
    setState(() {
      _opacity = 1.0;
    });

    // Fade-In 애니메이션이 5초라면, 5.0초간 대기
    // await Future.delayed(const Duration(seconds: 5));
    // Remove automatic navigation
    // await Future.delayed(const Duration(seconds: 3));
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (context) => GalleryPage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(seconds: 3),
        curve: Curves.easeInOut,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // 배경 이미지
            Image.asset(
              'assets/ocean.png',
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
            Align(
              alignment: Alignment.topLeft, // 왼쪽 상단으로 정렬
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, top: 100.0), // 왼쪽 패딩 추가
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      '"Understand \n the ocean \n through AI, \n protect \n the future."',
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      '  In the era of climate change, \nNational Oceanographic AI stands at the forefront of marine ecosystem research, delivering cutting-edge AI solutions. \n  Our mission is to empower researchers \nand institutions with advanced AI models \nand data analytics to precisely study marine biodiversity and environmental changes.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      'Core Services: \n- 해양 생물 분류 및 탐지 AI 모델\n   AI models for marine species classification \n- 기후 변화에 따른 해양 데이터 분석 솔루션\n   Data analytics solutions for  marine studies \n- 해양 생태계 모니터링 및 예측 도구\n   Monitoring and prediction for marine ecosystems',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 50.0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to Embedded Model page
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EmbeddedModelPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Embedded Model',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Research Model 페이지로 이동
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ResearchModelPage(),
                        ),
                      );
                    },
                    child: Text(
                      ' Research Model ',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
