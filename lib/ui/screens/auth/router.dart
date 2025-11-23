import 'package:flutter/material.dart';
import 'package:exchats/util/slide_left_with_fade_route.dart';

import 'login/login_screen.dart';
import 'verification/verification_screen.dart';

abstract class AuthRoutes {
  static const String Login = 'login';
  static const String Verification = 'verification';
}

class AuthRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AuthRoutes.Login:
        return SlideWithFadeRoute(
          builder: (context) => LoginScreen(),
        );
      case AuthRoutes.Verification:
        final args = settings.arguments as Map<String, dynamic>?;
        return SlideWithFadeRoute(
          builder: (context) => VerificationScreen(
            phoneNumber: args?['phoneNumber'] ?? '',
          ),
        );
      default:
        return SlideWithFadeRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Telegram'),
              ),
              body: Center(
                child: Text(
                  'No route defined for ${settings.name}',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
            );
          },
        );
    }
  }
}
