import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

class UpdateCtrl extends GetxController {
  final RxBool isUpdateAvailable = false.obs;
  final RxBool flexibleUpdateAvailable = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        isUpdateAvailable.value = true;

        if (updateInfo.immediateUpdateAllowed) {
          showUpdateDialog(forceUpdate: true);
        } else if (updateInfo.flexibleUpdateAllowed) {
          flexibleUpdateAvailable.value = true;
          showUpdateDialog(forceUpdate: false);
        }
      }
    } catch (e) {
      log("Update check failed: $e");
    }
  }

  void showUpdateDialog({required bool forceUpdate}) {
    Get.defaultDialog(
      titlePadding: EdgeInsetsDirectional.all(30),
      title: "update_available".tr,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Text("new_version_available".tr),
      ),
      barrierDismissible: !forceUpdate, // Force update if immediate is required
      actions: [
        if (!forceUpdate)
          TextButton(
            onPressed: () => Get.back(),
            child: Text("later".tr),
          ),
        ElevatedButton(
          onPressed: () {
            if (forceUpdate) {
              startImmediateUpdate();
            } else {
              startFlexibleUpdate();
            }
          },
          child: Text("update_now".tr),
        ),
      ],
    );
  }

  void startImmediateUpdate() async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      log("Immediate update failed: $e");
    }
  }

  void startFlexibleUpdate() async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      // Show restart dialog after flexible update is completed
      showRestartDialog();
    } catch (e) {
      log("Flexible update failed: $e");
    }
  }

  void showRestartDialog() {
    Get.defaultDialog(
      titlePadding: EdgeInsets.all(30),
      contentPadding: EdgeInsets.symmetric(horizontal: 30),
      title: "warning".tr, // Translated restart message
      content: Text("restart_prompt".tr),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Perform restart logic here
            exit(1);
          },
          child: Text("update_now".tr),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: Text("later".tr),
        ),
      ],
    );
  }

  void restartApp() {
    // Close the app completely
    SystemNavigator.pop(); // Close the app

    // Reset GetX state and controllers
    Get.deleteAll(); // Delete all controllers and state
    Get.reset(); // Reset all GetX states
  }
}
