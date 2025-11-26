import 'package:flutter/material.dart';
import 'locator.dart';
import 'presentation/router/app_router.dart';
import 'presentation/store/auth_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  

  final authStore = locator<AuthStore>();
  await authStore.checkAuthStatus();
  
  runApp(TelegramCloneApp());
}

class TelegramCloneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Telegram',
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
