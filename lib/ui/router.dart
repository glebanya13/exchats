import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exchats/view_models/home/home_viewmodel.dart';
import 'package:exchats/util/slide_left_with_fade_route.dart';

import 'screens/auth/auth_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/router.dart' show HomeRouter, HomeRoutes;

abstract class AppRoutes {
  static const String Home = '/';
  static const String Auth = 'auth';
}

class RootRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.Auth:
        return SlideWithFadeRoute(
          builder: (context) => AuthScreen(),
        );
      case AppRoutes.Home:
        return SlideWithFadeRoute(
          builder: (context) => ChangeNotifierProvider<HomeViewModel>(
            create: (_) => HomeViewModel(),
            child: HomeScreen(),
          ),
        );
      default:
        // Try to handle HomeRoutes
        return HomeRouter.generateRoute(settings);
    }
  }
}
