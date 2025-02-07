import 'package:get/get.dart';
import 'package:hiki/data/models/cashflow_model.dart';
import 'package:flutter/material.dart';

class InputCtrl extends GetxController {
  late TextEditingController titleController;
  late TextEditingController amountController;

  // Observable variable to hold the selected date. Initially null.
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<Category?> selectedCategory = Rx<Category?>(null);

  // Observable to track the index of the selected category in the grid view.
  Rx<int?> selectedItemIndex = Rx<int?>(null);
  final categoryToggleIndex = 0.obs;
  final savedAmountWithoutCommas = ''.obs;

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController();
    amountController = TextEditingController();
    selectedDate.value = DateTime.now(); // Set default to current date
  }

  // Opens the date picker dialog for the user to select a date.
  // Updates the selectedDate with the picked date.
  Future<void> presentDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    selectedDate.value = pickedDate; // Update selected date after picking
  }

  // Handles category selection by updating the selectedItemIndex and selectedCategory observables.
  // It sets the category based on the toggle state (income or expense).
  void onChooseCategory(int index) {
    selectedItemIndex.value = index;
    selectedCategory.value = categoryToggleIndex.value == 0
        ? IncomeCategory.values[index]
        : ExpenseCategory.values[index];
  }

  // Disposes of the text controllers to release resources when the controller is no longer needed.
  @override
  void onClose() {
    titleController.dispose();
    amountController.dispose();
    super.onClose();
  }
}
