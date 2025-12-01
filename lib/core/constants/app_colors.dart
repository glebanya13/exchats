import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1677FF);
  static const Color iconGray = Color(0xFF62697B);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  static const onPrimary = Color(0xFFFFFFFF);
  static const surface = Color(0xFFE8EAEC);
  static const subSurface = Color(0xFFF8F9FA);
  static const onSurface = Color(0xFF020C19);
  static const onSubSurface = Color(0xFF62697B);
  static const borderPrimary = Color(0xFFE1E7F1);
  static const gray = Color(0xFFA3A9B9);
  static const errorPrimary = Color(0xFFEF4444);

  static Color? grey(int shade) => Colors.grey[shade];
}
