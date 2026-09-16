import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  // ปรับฟังก์ชันแสดงรูปภาพให้ใหญ่ขึ้น และชิดด้านล่าง
  Widget _buildImage(String imagePath) {
    return Align(
      alignment: Alignment.bottomCenter, // บังคับให้รูปชิดกรอบด้านล่าง
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain, // ให้รูปขยายใหญ่ที่สุดโดยไม่โดนตัด
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }

  // เมื่อดูจบ หรือกดข้าม
  void _onIntroEnd(BuildContext context) {
    // เปลี่ยนจาก '/main' เป็น '/login'
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    // กำหนดสไตล์ของหน้าแต่ละหน้า
    final pageDecoration = PageDecoration(
      titleTextStyle: AppTextStyles.heading1.copyWith(
        color: AppColors
            .textPrimary, // เปลี่ยนสีหัวข้อให้เด่นขึ้นเมื่ออยู่บนพื้นขาว
        fontSize: 28,
      ),
      bodyTextStyle: AppTextStyles.heading3.copyWith(
        color: AppColors.textSecondary.withOpacity(0.8),
        fontSize: 16,
      ),
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
      pageColor:
          Colors.transparent, // โปร่งใสเพื่อให้ทะลุไปเห็นพื้นหลังที่เราวาดเอง
      imagePadding: const EdgeInsets.fromLTRB(
        10,
        50,
        10,
        0,
      ), // ลดขอบเพื่อให้รูปขยายใหญ่ได้เต็มที่
      imageFlex: 10, // ให้พื้นที่รูปภาพ 10 ส่วน (รูปจะใหญ่ขึ้นมาก)
      bodyFlex: 3, // ให้พื้นที่ข้อความ 3 ส่วน
      imageAlignment: Alignment.bottomCenter, // รูปจะเลื่อนมาทับรอยต่อพอดี
    );

    return Scaffold(
      body: Stack(
        children: [
          // 1. วาดพื้นหลัง: แบ่งครึ่งสี (บน Gradient / ล่างสีขาว)
          Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.bgGradient,
                  ),
                ),
              ),
              Expanded(flex: 4, child: Container(color: Colors.white)),
            ],
          ),

          // 2. วาดส่วนขอบมน (Rounded Corners) เชื่อมตรงกลาง
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height:
                  MediaQuery.of(context).size.height *
                  0.48, // ความสูงประมาณครึ่งล่าง
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ), // ทำขอบมนด้านบน
              ),
            ),
          ),

          // 3. วางเนื้อหา Onboarding ทับด้านบนสุด
          IntroductionScreen(
            globalBackgroundColor: Colors.transparent,
            pages: [
              PageViewModel(
                title: "Welcome to Feed",
                body:
                    "อัปเดตเรื่องราวใหม่ๆ และเชื่อมต่อกับเพื่อนในคอมมูนิตี้ของคุณได้ง่ายๆ ในที่เดียว",
                image: _buildImage('assets/images/onboarding/o1.png'),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Explore the Trend",
                body:
                    "ค้นหาแรงบันดาลใจใหม่ๆ และภาพสวยๆ ผ่านหน้าค้นหาที่จัดเรียงมาเพื่อคุณโดยเฉพาะ",
                image: _buildImage('assets/images/onboarding/o2.png'),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Manage Your Profile",
                body:
                    "จัดการบัญชี ตั้งค่าความเป็นส่วนตัว และปรับแต่งแอปพลิเคชันในแบบที่คุณชอบ",
                image: _buildImage('assets/images/onboarding/o3.png'),
                decoration: pageDecoration,
              ),
            ],
            onDone: () => _onIntroEnd(context),
            onSkip: () => _onIntroEnd(context),
            showSkipButton: true,
            skipOrBackFlex: 0,
            nextFlex: 0,
            showBackButton: false,

            // ตกแต่งปุ่ม
            skip: const Text(
              'Skip',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                fontSize: 18,
              ),
            ),
            next: const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.primary,
              size: 30,
            ),
            done: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Start',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),

            curve: Curves.fastLinearToSlowEaseIn,
            controlsMargin: const EdgeInsets.all(16),

            // ตกแต่งจุดไข่ปลา (Dots) ให้ตัดกับพื้นหลังสีขาว
            dotsDecorator: DotsDecorator(
              size: const Size(10.0, 10.0),
              color: AppColors.primary.withOpacity(
                0.2,
              ), // สีตอนยังไม่แอคทีฟเป็นสีเขียวอ่อน
              activeSize: const Size(26.0, 10.0),
              activeColor: AppColors.primary, // สีแอคทีฟเป็นเขียวเข้ม
              activeShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
