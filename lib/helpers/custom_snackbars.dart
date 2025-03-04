import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:async';

void showUndoSnackbar({required VoidCallback onUndoPressed}) {
  ValueNotifier<int> countdown = ValueNotifier(3); // Timer starts from 3
  Timer.periodic(const Duration(seconds: 1), (timer) {
    if (countdown.value > 0) {
      countdown.value--;
    } else {
      timer.cancel();
    }
  });

  Get.snackbar(
    "data_deleted".tr,
    "restore_message".tr,

    snackPosition: SnackPosition.TOP,
    backgroundColor: const Color.fromARGB(93, 0, 0, 0),
    colorText: const Color.fromARGB(222, 255, 255, 255),
    borderRadius: 10,
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    duration: const Duration(seconds: 3),
    isDismissible: true,
    barBlur: 20,
    animationDuration: const Duration(milliseconds: 250),
    snackStyle: SnackStyle.FLOATING,

    // Show timer instead of icon
    icon: ValueListenableBuilder<int>(
      valueListenable: countdown,
      builder: (context, value, child) {
        return CircleAvatar(
          backgroundColor: Colors.white.withAlpha(200),
          child: Text(
            value.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color.fromARGB(152, 0, 0, 0),
            ),
          ),
        );
      },
    ),

    mainButton: TextButton(
      onPressed: () {
        Get.back(); // Remove the snackbar
        onUndoPressed(); // Call undo function
      },
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(222, 255, 255, 255),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        'restore'.tr,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(152, 0, 0, 0),
        ),
      ),
    ),
  );
}

void showInfoSnackbar({
  required String title,
  String? subtext,
  IconData? icon,
}) {
  Get.snackbar(
    title,
    subtext ?? "",
    titleText: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    messageText: Icon(icon ?? Icons.done_all_rounded),
    snackPosition: SnackPosition.TOP, // Position of the snackbar
    backgroundColor: Colors.blueGrey.shade300, // Background color
    colorText: Colors.white, // Text color
    borderRadius: 10, // Rounded corners
    margin: EdgeInsets.all(10), // Margin from the edges
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
    duration: Duration(seconds: 2), // Duration the snackbar will stay
    isDismissible: true, // Snackbar can be dismissed
    barBlur: 20, // Blur effect behind the snackbar

    animationDuration: Duration(milliseconds: 300), // Animation duration
    snackStyle: SnackStyle.FLOATING, // Floating style for the snackbar
  );
}
