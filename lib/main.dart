import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hiki/home_navigation.dart';
import 'package:hiki/screens/choose_language/choose_language_screen.dart';
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

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: theme.darkThemeData,
      theme: theme.lightThemeData,
      themeMode: ctrl.themeMode.value,
      translations: AppLocalization(),
      locale: ctrl.currentLocale.value,
      fallbackLocale: const Locale('en'),
      home: ctrl.isFirstTime ? LanguageSelectionScreen() : HomeNavigation(),
    ),
  );
}
