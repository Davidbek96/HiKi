import 'package:hiki/controller/settings_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageTile extends StatelessWidget {
  final String language;
  final Locale locale;
  final String flag;

  LanguageTile(
      {super.key,
      required this.language,
      required this.locale,
      required this.flag});

  final SettingsCtrl settingsCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          settingsCtrl.updateLocale(locale);
        },
        child: Container(
          width: 300,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            color: settingsCtrl.currentLocale.value == locale
                ? Get.isDarkMode
                    ? Colors.transparent
                    : Theme.of(context).colorScheme.surface
                : Colors.transparent,
            border: Border.all(
              color: settingsCtrl.currentLocale.value == locale
                  ? Colors.blueGrey[600]!
                  : Get.isDarkMode
                      ? Colors.grey[900]!
                      : Colors.grey[300]!,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(flag, style: TextStyle(fontSize: 24)),
                  SizedBox(width: 15),
                  Text(language, style: TextStyle(fontSize: 18)),
                ],
              ),
              if (settingsCtrl.currentLocale.value == locale)
                Icon(
                  Icons.check_circle,
                  color: Get.isDarkMode
                      ? const Color.fromARGB(201, 255, 255, 255)
                      : Colors.blue,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
