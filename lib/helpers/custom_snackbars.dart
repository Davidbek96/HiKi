import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showUndoSnackbar({required VoidCallback onUndoPressed}) {
  Get.snackbar(
    "data_deleted".tr,
    "restore_message".tr,

    snackPosition: SnackPosition.TOP, // Position of the snackbar
    backgroundColor: const Color.fromARGB(93, 0, 0, 0), // Background color
    colorText: const Color.fromARGB(222, 255, 255, 255), // Text color
    borderRadius: 10, // Rounded corners
    margin: EdgeInsets.all(10), // Margin from the edges
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
    duration: Duration(seconds: 3), // Duration the snackbar will stay
    icon: Icon(
      Icons.warning_amber_rounded,
      color: const Color.fromARGB(222, 255, 255, 255),
    ), // Icon to show in the snackbar
    isDismissible: true, // Snackbar can be dismissed
    barBlur: 20, // Blur effect behind the snackbar

    animationDuration: Duration(milliseconds: 250), // Animation duration
    snackStyle: SnackStyle.FLOATING, // Floating style for the snackbar
    mainButton: TextButton(
      onPressed: () {
        Get.back(); // Remove the blur effect first
        onUndoPressed(); // Call the undo function
      },
      style: TextButton.styleFrom(
        backgroundColor:
            const Color.fromARGB(222, 255, 255, 255), // Black background
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 8), // Padding for better look
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)), // Rounded corners
      ),
      child: Text(
        'restore'.tr,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(152, 0, 0, 0), // Green text for contrast
        ),
      ),
    ),
  );
}

void showInfoSnackbar({required String title, String? subtext}) {
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
    messageText: Icon(Icons.done_all_rounded),
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
