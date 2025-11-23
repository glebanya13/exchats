import 'package:flutter/material.dart';
import 'package:exchats/ui/theming/material_themes.dart';

class ThemeProvider extends ChangeNotifier {
  AppTheme _customTheme = LightAppTheme();

  AppTheme get theme => _customTheme;
}

abstract class AppTheme {
  Brightness get brightness;

  ThemeData get data;

  Color get drawerHeaderBackground;

  Color get drawerHeaderTitleColor;

  Color get drawerHeaderSubtitleColor;
}

class LightAppTheme extends AppTheme {
  Brightness get brightness => Brightness.light;

  ThemeData get data => MaterialThemes.lightTheme;

  Color get drawerHeaderBackground => Color.fromARGB(255, 90, 143, 187);

  Color get drawerHeaderTitleColor => Color.fromARGB(255, 250, 255, 255);

  Color get drawerHeaderSubtitleColor => Color.fromARGB(255, 187, 231, 255);
}
