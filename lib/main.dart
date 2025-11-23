import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exchats/locator.dart';
import 'package:exchats/ui/theming/theme_provider.dart';
import 'package:exchats/services/auth_service.dart';
import 'package:exchats/ui/router.dart';
import 'package:exchats/ui/theming/material_themes.dart' show MaterialThemes, TextThemeExtension;
import 'package:exchats/ui/theming/theme_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(TelegramCloneApp());
}

class TelegramCloneApp extends StatefulWidget {
  @override
  _TelegramCloneAppState createState() => _TelegramCloneAppState();
}

class _TelegramCloneAppState extends State<TelegramCloneApp> {
  String _initialRoute = AppRoutes.Auth; // Начинаем с авторизации
  bool _initialized = true;

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return _SplashScreen();
    }

    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: _MainScreen(
        initialRoute: _initialRoute,
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MaterialThemes.lightTheme,
      home: Scaffold(
        body: Container(
          child: Center(
            child: Text(
              'Telegram',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 250, 255, 255),
              ),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _MainScreen extends StatelessWidget {
  const _MainScreen({
    Key? key,
    required this.initialRoute,
  }) : super(key: key);

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return ThemeManager(
      builder: (context, theme) {
        return MaterialApp(
          title: 'Telegram',
          theme: theme,
          initialRoute: initialRoute,
          onGenerateRoute: RootRouter.generateRoute,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
