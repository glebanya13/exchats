import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:exchats/util/custom_ink_splash.dart';

extension TextThemeExtension on TextTheme {
  TextStyle? get headline1 => displayLarge;
  TextStyle? get headline2 => displayMedium;
  TextStyle? get headline3 => displaySmall;
  TextStyle? get headline5 => headlineMedium;
  TextStyle? get headline6 => headlineSmall;
}

class MaterialThemes {
  static ThemeData get lightTheme {
    final baseTextTheme = Typography.material2018(platform: TargetPlatform.iOS).black;
    return ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme.light(
        primary: Color.fromARGB(255, 81, 125, 162),
        secondary: Color(0xFF1677FF),
      ),
      appBarTheme: AppBarTheme(
        elevation: 1.5,
        color: Color.fromARGB(255, 81, 125, 162),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      primaryColor: Color.fromARGB(255, 81, 125, 162),
      primaryColorLight: Color.fromARGB(255, 90, 143, 187),
      splashFactory: CustomInkSplash.splashFactory,
      splashColor: Color.fromRGBO(175, 175, 175, 0.25),
      highlightColor: Colors.transparent,
      textTheme: baseTextTheme.copyWith(
        displayLarge: TextStyle(color: Color.fromARGB(255, 63, 63, 63)),
        displayMedium: TextStyle(color: Color.fromARGB(255, 134, 134, 134)),
        displaySmall: TextStyle(color: Color.fromARGB(255, 107, 125, 137)),
        headlineMedium: TextStyle(color: Color.fromARGB(255, 149, 194, 235)),
        headlineSmall: TextStyle(color: Color.fromARGB(255, 138, 179, 210)),
      ),
      canvasColor: Color.fromARGB(255, 255, 255, 255),
      scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
      dividerColor: Color.fromARGB(255, 230, 230, 230),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 90, 158, 207),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseTextTheme = Typography.material2018(platform: TargetPlatform.iOS).white;
    return ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme.dark(
        primary: Color.fromARGB(255, 31, 43, 55),
        secondary: Color(0xFF1677FF),
      ),
      appBarTheme: AppBarTheme(
        elevation: 1.5,
        color: Color.fromARGB(255, 31, 43, 55),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      primaryColor: Color.fromARGB(255, 31, 43, 55),
      primaryColorLight: Color.fromARGB(255, 59, 93, 128),
      splashFactory: CustomInkSplash.splashFactory,
      splashColor: Color.fromRGBO(96, 125, 139, 0.25),
      highlightColor: Colors.transparent,
      textTheme: baseTextTheme.copyWith(
        displayLarge: TextStyle(color: Color.fromARGB(255, 250, 255, 255)),
        displayMedium: TextStyle(color: Color.fromARGB(255, 135, 147, 159)),
        displaySmall: TextStyle(color: Color.fromARGB(255, 107, 125, 137)),
        headlineMedium: TextStyle(color: Color.fromARGB(255, 149, 194, 235)),
        headlineSmall: TextStyle(color: Color.fromARGB(255, 138, 179, 210)),
      ),
      canvasColor: Color.fromARGB(255, 27, 37, 47),
      scaffoldBackgroundColor: Color.fromARGB(255, 27, 37, 47),
      dividerColor: Color.fromARGB(255, 8, 18, 27),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 90, 158, 207),
        foregroundColor: Color.fromARGB(255, 250, 255, 255),
      ),
    );
  }
}
