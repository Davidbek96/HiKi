import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

class AppUpdateCtrl extends GetxController {
  // Flags to track update availability
  bool isUpdateAvailable = false;
  bool flexibleUpdateAvailable = false;

  @override
  void onInit() {
    super.onInit();
    // Ensure update check runs after the UI is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForUpdate();
    });
  }

  // Checks for available app updates
  Future<void> checkForUpdate() async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        isUpdateAvailable = true;

        if (updateInfo.immediateUpdateAllowed) {
          // Show mandatory update dialog
          showUpdateDialog(forceUpdate: true);
        } else if (updateInfo.flexibleUpdateAllowed) {
          flexibleUpdateAvailable = true;
          // Show optional update dialog
          showUpdateDialog(forceUpdate: false);
        }
      }
    } catch (e) {
      log("Update check failed: $e");
    }
  }

  // Displays update prompt dialog
  void showUpdateDialog({required bool forceUpdate}) {
    Get.defaultDialog(
      title: "update_available".tr,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Text("new_version_available".tr),
      ),
      barrierDismissible: !forceUpdate, // Prevent dismissing if forced update
      actions: [
        if (!forceUpdate)
          TextButton(
            onPressed: () => Get.back(),
            child: Text("later".tr),
          ),
        ElevatedButton(
          onPressed: () =>
              forceUpdate ? startImmediateUpdate() : startFlexibleUpdate(),
          child: Text("update_now".tr),
        ),
      ],
    );
  }

  // Starts an immediate update (requires app restart)
  Future<void> startImmediateUpdate() async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      log("Immediate update failed: $e");
    }
  }

  // Starts a flexible update (allows user to continue using the app)
  Future<void> startFlexibleUpdate() async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      // Prompt user to restart after update
      showRestartDialog();
    } catch (e) {
      log("Flexible update failed: $e");
    }
  }

  // Shows restart prompt after a flexible update
  void showRestartDialog() {
    Get.defaultDialog(
      title: "warning".tr,
      content: Text("restart_prompt".tr),
      actions: [
        ElevatedButton(
          onPressed: () => exit(1), // Forces app restart
          child: Text("update_now".tr),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: Text("later".tr),
        ),
      ],
    );
  }

  // Restarts the app (useful after updates)
  void restartApp() {
    SystemNavigator.pop(); // Close the app
    Get.deleteAll(); // Clear GetX controllers
    Get.reset(); // Reset application state
  }
}
