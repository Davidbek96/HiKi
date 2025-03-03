import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hiki/home_navigation.dart';
import 'package:hiki/screens/onboarding_language/onboarding_language.dart';
import 'controller/settings_ctrl.dart';
import 'core/themes.dart';
import 'localization/app_localization.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await GetStorage.init();
  final Themes theme = Themes();
  final ctrl = Get.put(SettingsCtrl());

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Enable edge-to-edge display
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor:
        Colors.transparent, // Makes the bottom nav transparent
    statusBarColor: Colors.transparent, // Makes the top status bar transparent
    statusBarIconBrightness: Brightness.dark, // Dark icons for light background
    systemNavigationBarIconBrightness:
        Brightness.dark, // Dark icons for bottom nav
  ));

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: theme.darkThemeData,
      theme: theme.lightThemeData,
      themeMode: ctrl.themeMode.value,
      translations: AppLocalization(),
      locale: ctrl.currentLocale.value,
      fallbackLocale: const Locale('en'),
      home: ctrl.isFirstTime ? OnboardingLanguageSecreen() : HomeNavigation(),
    ),
  );
}
