import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:exchats/core/di/init.dart';
import 'package:exchats/generated/locale_loader.g.dart';
import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDI();

  runApp(
    EasyLocalization(
      ignorePluralRules: false,
      supportedLocales: const [Locale('ru')],
      path: 'assets/lang',
      fallbackLocale: const Locale('ru'),
      assetLoader: const CodegenLoader(),
      child: const ExChatsApp(),
    ),
  );
}

class ExChatsApp extends StatelessWidget {
  const ExChatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = EasyLocalization.of(context);

    final theme = ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
        ),
      ),
      splashFactory: NoSplash.splashFactory,
    );

    return MaterialApp.router(
      title: 'ExChats',
      theme: theme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        ...localization?.delegates ?? [],
        CountryLocalizations.delegate,
      ],
      supportedLocales: localization?.supportedLocales ?? const [Locale('ru')],
      locale: localization?.locale,
    );
  }
}
