import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // เพิ่มบรรทัดนี้
import 'package:firebase_auth/firebase_auth.dart'; // เพิ่มบรรทัดนี้

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/on_boarding_screen.dart';
import 'firebase_options.dart'; // ต้องมีไฟล์นี้ก่อน

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // บังคับใส่สำหรับ Web
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
        fontFamily: 'Itim',
      ),
      // ใช้ AuthGate เป็นตัวจัดการหน้าแรก
      home: const AuthGate(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/onboarding': (context) => const OnBoardingScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}

// สร้าง AuthGate เพื่อตรวจสอบว่า User ล็อกอินอยู่หรือไม่
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        // ถ้ามีข้อมูล User แสดงว่าล็อกอินแล้ว ให้ไปหน้า Main[cite: 32]
        if (snapshot.hasData) {
          return const MainScreen(); 
        }
        // ถ้ายังไม่ล็อกอิน ให้ไปหน้า Onboarding หรือ Login[cite: 32]
        return const OnBoardingScreen(); 
      },
    );
  }
}