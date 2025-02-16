import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsCtrl extends GetxController {
  final GetStorage storage = GetStorage();

  Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  Rx<Locale> currentLocale = Locale('uz').obs;
  RxString currency = 'UZS'.obs;
  final List<String> availableCurrencies = ['USD', 'UZS', 'RUB', 'KRW'];

  final Map<String, String> currencySymbols = {
    'USD': '\$',
    'UZS': "som",
    'RUB': '₽',
    'KRW': '₩',
  };

  bool get isFirstTime => storage.read('first_time') ?? true;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
    currentLocale.value = Locale(storage.read('language') ?? 'uz');
    currency.value = storage.read('currency') ?? 'UZS';
  }

  /// Updates the app's locale and saves the selection.
  void updateLocale(Locale locale) {
    currentLocale.value = locale;
    Get.updateLocale(locale);
    storage.write('language', locale.languageCode);
  }

  /// Updates the selected currency and saves the preference.
  void updateCurrency(String newCurrency) {
    if (availableCurrencies.contains(newCurrency)) {
      currency.value = newCurrency;
      storage.write('currency', newCurrency);
    }
  }

  /// Returns the symbol of the currently selected currency.
  String get currencySymbol =>
      currencySymbols[currency.value] ?? currency.value;

  /// Loads and sets the theme mode based on stored preferences.
  void _loadThemeMode() {
    String? savedTheme = storage.read('theme_mode');
    themeMode.value = savedTheme == 'dark'
        ? ThemeMode.dark
        : savedTheme == 'light'
            ? ThemeMode.light
            : (Get.isPlatformDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  /// Toggles between light and dark theme and updates the app theme.
  void toggleThemeMode() {
    themeMode.value =
        themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    storage.write(
        'theme_mode', themeMode.value == ThemeMode.dark ? 'dark' : 'light');
    Get.changeThemeMode(themeMode.value);
  }
}
