import 'package:flutter/material.dart';
import 'package:hiki/screens/home/main_screen.dart';
import 'package:upgrader/upgrader.dart';
import 'package:get/get.dart';
//If you want to remove upgrader package in the future
//just delete this file and call MainScreen widget in home_navigation file

class UpgraderWidget extends StatelessWidget {
  const UpgraderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      shouldPopScope: () => true, //android back button to remove dialog
      showReleaseNotes: false,
      showIgnore: false,
      upgrader: Upgrader(
        durationUntilAlertAgain: const Duration(days: 1),
        messages: CustomMessages(),
      ),
      child: MainScreen(),
    );
  }
}

class CustomMessages extends UpgraderMessages {
  /// Override the message function to provide custom language localization.
  @override
  String message(UpgraderMessage messageKey) {
    switch (messageKey) {
      case UpgraderMessage.title:
        return 'update_available'.tr;
      case UpgraderMessage.body:
        return 'new_version_available'.tr;
      case UpgraderMessage.buttonTitleLater:
        return 'later'.tr;
      case UpgraderMessage.buttonTitleUpdate:
        return 'update_now'.tr;
      case UpgraderMessage.prompt:
        return 'update_prompt'.tr;
      default: //it is needed for future developent
        return super.message(messageKey)!;
    }
  }
}
