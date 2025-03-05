import 'dart:developer' as dev;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hiki/data/services/database_helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hiki/data/models/cashflow_model.dart';
import 'package:flutter/material.dart';
import '../helpers/custom_snackbars.dart';
import '../core/default_list_cashflows.dart';
import 'dart:math';

class DataCtrl extends GetxController {
  final cashflows = <CashFlow>[].obs;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final box = GetStorage();

  final filterPeriod = 'Overall'.obs;
  final filterType = 'All'.obs;
  var totalIncomes = 0.0.obs;
  var totalExpenses = 0.0.obs;
  var currentBalance = 0.0.obs;
  var isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchCashflows();
    FlutterNativeSplash.remove();
  }

  /// **Insert default expenses into the database (only once)**
  Future<void> loadFirstTimeData() async {
    isLoading.value = true;
    dev.log('Data inserting into database started');

    await _dbHelper.insertBatchCashflows(defaultCashFlows);

    dev.log('Data inserted');
    await fetchCashflows();
    box.write('first_time', false);
    isLoading.value = false;
  }

  /// **Fetch all cashflows from the database**
  Future<void> fetchCashflows() async {
    isLoading.value = true;
    try {
      final data = await _dbHelper.fetchCashflows();
      cashflows.assignAll(data);
      updateIncomeExpenseAmount(cashflows);
    } finally {
      isLoading.value = false;
    }
  }

  /// **Update sum of all incomes, sum of all expenses and current balance**
  void updateIncomeExpenseAmount(List<CashFlow> currentCashflows) {
    totalIncomes.value = currentCashflows
        .where((transaction) => transaction.isIncome)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

    totalExpenses.value = currentCashflows
        .where((transaction) => !transaction.isIncome)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

    currentBalance.value = totalIncomes.value - totalExpenses.value;
  }

  /// **Get filtered cashflows based on selected period and type (today/this week, this year) **
  List<CashFlow> get filteredCashflows {
    List<CashFlow> filteredList = [];
    DateTime now = DateTime.now();
    DateTime startOfPeriod;

    switch (filterPeriod.value) {
      case 'Today':
        startOfPeriod = DateTime(now.year, now.month, now.day);
        break;
      case 'Week':
        DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
        startOfPeriod = DateTime(
            firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day);
        break;
      case 'Month':
        startOfPeriod = DateTime(now.year, now.month, 1);
        break;
      case 'Year':
        startOfPeriod = DateTime(now.year, 1, 1);
        break;
      default:
        startOfPeriod = DateTime(now.year - 10);
    }

    filteredList = cashflows.where((transaction) {
      final transactionDate = transaction.date;
      if (transactionDate.isBefore(startOfPeriod)) return false;
      if (filterType.value == 'Income' && !transaction.isIncome) return false;
      if (filterType.value == 'Expense' && transaction.isIncome) return false;
      return true;
    }).toList();

    updateIncomeExpenseAmount(filteredList);
    return filteredList;
  }

  /// **Apply filters and update UI - push filteredCashflows to get new value**
  void applyFilters(String period, String type) async {
    filterPeriod.value = period;
    filterType.value = type;
    update();
  }

  /// **Insert or Update a cashflow**
  Future<void> saveCashflow({
    String? id,
    required String title,
    required String amount,
    required DateTime date,
    required Category? category,
    required bool isIncome,
  }) async {
    final parsedAmount = double.tryParse(amount);
    if (title.trim().isEmpty ||
        parsedAmount == null ||
        parsedAmount <= 0 ||
        category == null) {
      Get.defaultDialog(
        title: 'warning'.tr,
        middleText: 'please_enter_valid'.tr,
        confirm: TextButton(onPressed: Get.back, child: Text('confirm'.tr)),
      );
      return;
    }

    final newCashflow = CashFlow(
      id: id,
      title: title,
      amount: parsedAmount,
      date: date,
      category: category,
      isIncome: isIncome,
    );

    if (id == null) {
      await _dbHelper.insertCashflow(newCashflow);
      cashflows.add(newCashflow);
    } else {
      await _dbHelper.updateCashflow(id, newCashflow);
      final index = cashflows.indexWhere((c) => c.id == id);
      if (index != -1) cashflows[index] = newCashflow;
    }

    cashflows.sort((a, b) => b.date.compareTo(a.date));
    updateIncomeExpenseAmount(cashflows);
    update();
    Get.back();
  }

  /// **Delete a cashflow**
  void deleteCashflow(CashFlow cashflow) async {
    Get.closeCurrentSnackbar();
    await _dbHelper.deleteCashflow(cashflow.id);

    final removedCashflow =
        cashflows.firstWhere((item) => item.id == cashflow.id);
    final removedIndex = cashflows.indexOf(removedCashflow);
    cashflows.remove(removedCashflow);

    updateIncomeExpenseAmount(cashflows);
    update();

    showUndoSnackbar(
      onUndoPressed: () async {
        await _dbHelper.insertCashflow(removedCashflow);
        cashflows.insert(removedIndex, removedCashflow);
        updateIncomeExpenseAmount(cashflows);
        update();
        Get.closeCurrentSnackbar();
      },
    );
  }

  /// **Delete all cashflows**
  void deleteAllCashflows() async {
    Get.closeCurrentSnackbar();

    // Generate a random 6-digit number for confirmation
    String confirmationNumber = _generateRandomNumber();

    // Create a text editing controller to capture user input
    TextEditingController confirmationController = TextEditingController();

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: Text("deleting_all".tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('remember_delete_action'.tr),
            SizedBox(height: 10),
            Text(
              confirmationNumber,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ), // Show the number to the user
            ),
            SizedBox(height: 10),
            TextField(
              controller: confirmationController,
              decoration: InputDecoration(
                hintText:
                    'please_enter_number_above'.tr, // Hint for input field
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number, // Set keyboard to number
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text("cancel".tr),
          ),
          TextButton(
            onPressed: () {
              // Check if the user entered the correct number
              if (confirmationController.text == confirmationNumber) {
                Get.back(result: true);
              } else {
                // Show an error message if confirmation is incorrect
                showInfoSnackbar(title: 'error'.tr, icon: Icons.error);
              }
            },
            child: Text(
              "delete".tr,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _dbHelper.deleteAllCashflows();
      cashflows.clear();

      updateIncomeExpenseAmount(cashflows);
      update();

      showInfoSnackbar(title: "all_data_deleted".tr);
    }
  }

  /// **Multiple select and delete operations**
  var selectedIds = <String>[].obs;
  var isSelectionMode = false.obs;

  void toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }

    isSelectionMode.value = selectedIds.isNotEmpty;
  }

  void clearSelections() {
    selectedIds.clear();
    isSelectionMode.value = false;
  }

  /// **Delete selected multiple cashflows at once**
  void deleteSelectedCashflows() async {
    if (selectedIds.isEmpty) return;
    Get.closeCurrentSnackbar();

    // Store removed items for undo
    final removedCashflows =
        cashflows.where((c) => selectedIds.contains(c.id)).toList();

    await _dbHelper.deleteBatchCashflows(selectedIds);
    cashflows.removeWhere((c) => selectedIds.contains(c.id));

    updateIncomeExpenseAmount(cashflows);
    update();
    clearSelections();

    showUndoSnackbar(
      onUndoPressed: () async {
        for (var cashflow in removedCashflows) {
          await _dbHelper.insertCashflow(cashflow);
          cashflows.add(cashflow);
        }
        cashflows.sort((a, b) => b.date.compareTo(a.date));
        updateIncomeExpenseAmount(cashflows);
        update();
        Get.closeCurrentSnackbar();
      },
    );
  }

  /// ** Function to generate a random 6-digit positive number**
  String _generateRandomNumber() {
    Random random = Random();
    int number = 100000 +
        random.nextInt(900000); // Generate a number between 100000 and 999999
    return number.toString();
  }
}
