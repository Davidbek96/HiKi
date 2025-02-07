import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsCtrl extends GetxController {
  final GetStorage storage = GetStorage();
  Rx<ThemeMode> themeMode = ThemeMode.system.obs; // Default to system mode
  bool get isFirstTime => storage.read('first_time') ?? true;
  // Locale? get getSavedLocale =>
  //     isFirstTime ? null : Locale(storage.read('language') ?? 'uz');
  Rx<Locale> currentLocale = Locale('uz').obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
    currentLocale.value = Locale(storage.read('language') ?? 'uz');
  }

  void updateLocale(Locale locale) {
    currentLocale.value = locale;
    Get.updateLocale(locale); // Change app language
    storage.write('language', locale.languageCode); // Save selection
  }

  void _loadThemeMode() {
    String? savedTheme = storage.read('theme_mode');

    if (savedTheme == null) {
      themeMode.value =
          Get.isPlatformDarkMode ? ThemeMode.dark : ThemeMode.light;
    } else {
      themeMode.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }
  }

  void toggleThemeMode() {
    if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
      storage.write('theme_mode', 'light');
    } else {
      themeMode.value = ThemeMode.dark;
      storage.write('theme_mode', 'dark');
    }
    Get.changeThemeMode(themeMode.value); //
  }
}
