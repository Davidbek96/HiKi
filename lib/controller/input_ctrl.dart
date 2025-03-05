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
  final isEditMode = false.obs;

  bool isDataAssigned = false; // Track if data is assigned

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
    update();
  }

  void assignDataOnEdit(CashFlow cashflow) {
    if (!isDataAssigned) {
      isEditMode.value = true; //used for autofocus in textfield of title
      titleController.text = cashflow.title;
      amountController.text = cashflow.amount.toStringAsFixed(0);
      selectedDate.value = cashflow.date;
      selectedCategory.value = cashflow.category;
      categoryToggleIndex.value = cashflow.isIncome ? 0 : 1;
      savedAmountWithoutCommas.value = amountController.text;

      if (cashflow.isIncome) {
        selectedItemIndex.value =
            IncomeCategory.values.indexOf(cashflow.category as IncomeCategory);
      } else {
        selectedItemIndex.value = ExpenseCategory.values
            .indexOf(cashflow.category as ExpenseCategory);
      }
      isDataAssigned = true; // Mark as assigned
      // Update UI if necessary
    }
  }

  // Disposes of the text controllers to release resources when the controller is no longer needed.
  @override
  void onClose() {
    titleController.dispose();
    amountController.dispose();
    super.onClose();
  }
}
