import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1677FF);
  static const Color background = Color(0xFFF5F5F5);
  static const Color iconGray = Color(0xFF62697B);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  static Color? grey(int shade) => Colors.grey[shade];
}
