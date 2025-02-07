import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiki/controller/data_ctrl.dart';
import 'package:hiki/screens/settings/about.dart';
import 'package:hiki/controller/settings_ctrl.dart';

extension ConvertFlag on String {
  String get toFlag {
    return (this).toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
  }
}

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final DataCtrl c = Get.find();
  final SettingsCtrl _settingsCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 10),

        // Dark Mode Toggle
        Obx(
          () => SwitchListTile(
            title: Text('dark_mode'.tr),
            secondary: const Icon(Icons.dark_mode),
            value: _settingsCtrl.themeMode.value == ThemeMode.dark,
            onChanged: (value) {
              _settingsCtrl.toggleThemeMode();
            },
          ),
        ),
        const Divider(indent: 15, endIndent: 15),

        // Language Selection
        ListTile(
          leading: const Icon(Icons.language),
          title: Text('language'.tr),
          subtitle: Text('select_language'.tr),
          onTap: () {
            _showLanguageDialog(context);
          },
        ),
        const Divider(indent: 15, endIndent: 15),

        // Delete All Data
        ListTile(
          leading: const Icon(Icons.delete_forever),
          title: Text('delete_all'.tr),
          subtitle: Text('delete_all_desc'.tr),
          onTap: c.deleteAllCashflows,
        ),

        const Divider(indent: 15, endIndent: 15),

        // About Section
        ListTile(
          leading: const Icon(Icons.info),
          title: Text('about'.tr),
          subtitle: Text('about_desc'.tr),
          onTap: () {
            Get.to(() => AboutPage());
          },
        ),
      ],
    );
  }

  // Function to show language selection dialog
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('choose_language'.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Text('UZ'.toFlag, style: TextStyle(fontSize: 24)),
                title: const Text("O'zbekcha"),
                onTap: () {
                  _settingsCtrl.updateLocale(Locale('uz'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Text('US'.toFlag, style: TextStyle(fontSize: 24)),
                title: const Text("English"),
                onTap: () {
                  _settingsCtrl.updateLocale(Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Text('KR'.toFlag, style: TextStyle(fontSize: 24)),
                title: const Text("한국어"),
                onTap: () {
                  _settingsCtrl.updateLocale(Locale('kr'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Text('RU'.toFlag, style: TextStyle(fontSize: 24)),
                title: const Text("Русский"),
                onTap: () {
                  _settingsCtrl.updateLocale(Locale('ru'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
