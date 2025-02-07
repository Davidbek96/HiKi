import 'package:hiki/controller/data_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiki/home_navigation.dart';
import 'package:hiki/screens/choose_language/colorful_text.dart';
import 'package:hiki/screens/choose_language/language_tile.dart';

extension ConvertFlag on String {
  String get toFlag {
    return (this).toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
  }
}

class LanguageSelectionScreen extends StatelessWidget {
  LanguageSelectionScreen({super.key});
  final dataCtrl = Get.put(DataCtrl());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Image.asset(
                  'assets/wallet.png', // Replace with your image file
                  width: 100,
                  height: 100,
                ),
                ColorfulText(),
                SizedBox(height: 40),
                LanguageTile(
                  language: "O'zbekcha",
                  locale: Locale('uz'),
                  flag: "UZ".toFlag,
                ),
                SizedBox(height: 10),
                LanguageTile(
                  language: "English",
                  locale: Locale('en'),
                  flag: "US".toFlag,
                ),
                SizedBox(height: 10),
                LanguageTile(
                  language: "한국어",
                  locale: Locale('kr'),
                  flag: "KR".toFlag,
                ),
                SizedBox(height: 10),
                LanguageTile(
                  language: "Русский",
                  locale: Locale('ru'),
                  flag: "RU".toFlag,
                ),
                SizedBox(height: 60),
                // Pushes the button to the bottom
                ElevatedButton(
                  onPressed: () {
                    dataCtrl.loadFirstTimeData();
                    Get.off(
                        () => HomeNavigation()); // Navigate to HomeNavigation
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(180, 50),
                    backgroundColor: const Color.fromARGB(255, 54, 130, 165),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "continue".tr,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
