import 'package:exchats/core/assets/gen/assets.gen.dart';
import 'package:flutter/material.dart';

final class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Assets.auth.logo.image(width: 100, height: 100)),
    );
  }
}
