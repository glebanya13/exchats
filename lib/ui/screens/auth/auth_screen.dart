import 'package:flutter/material.dart';
import 'package:exchats/ui/screens/auth/router.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: AuthRoutes.Login,
      onGenerateRoute: AuthRouter.generateRoute,
    );
  }
}
