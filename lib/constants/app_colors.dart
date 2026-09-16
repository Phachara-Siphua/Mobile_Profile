import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // 🎨 ธีมหลัก (Modern Green & Clean)
  static const Color bgPrimary = Color(0xFFF5F9F6); // พื้นหลังสีเทาอมเขียวอ่อนๆ
  static const Color bgSecondary = Color(0xFFFFFFFF); // สีขาวสำหรับการ์ดและกล่องข้อความ
  
  static const Color primary = Color(0xFF2E7D32); // สีเขียวหลัก (Forest Green)
  static const Color secondary = Color(0xFF81C784); // สีเขียวอ่อน
  
  static const Color textPrimary = Color(0xFF1B2B22); // สีดำอมเขียวเข้ม สำหรับหัวข้อ
  static const Color textSecondary = Color(0xFF6D7A73); // สีเทา สำหรับข้อความรอง

  // 🍯 สีเพิ่มเติมสำหรับ Hover / Action
  static const Color hoverBg = Color(0xFFE8F5E9); 
  static const Color hoverBorder = Color(0xFF4CAF50); 

  // Status Colors อื่นๆ
  static const Color accent = Color(0xFF4CAF50);
  static const Color danger = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFB8C00);

  // 🌈 สี Gradient ที่ปรับให้ "ชัดเจนและสดใสขึ้น"
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFD1E9D2), // สีเขียวมินต์สว่าง (ทำให้ฝั่งบนซ้ายดูสว่างสดใส)
      Color(0xFFA3D5A6), // สีเขียวกลางที่ชัดเจน
      Color(0xFF6EBE71), // สีเขียวใบไม้ (เพิ่มความเข้มข้นที่มุมขวาล่าง)
    ],
  );

  // Gradient สำหรับปุ่มกด (ถ้าอยากให้ปุ่มเด่นขึ้นสามารถเรียกใช้ตัวนี้แทนสีพื้นได้)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF43A047), // สีเขียวสว่าง
      Color(0xFF2E7D32), // สีเขียวเข้ม (Primary)
    ],
  );
}