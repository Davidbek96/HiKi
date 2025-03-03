import 'dart:developer';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hiki/data/services/database_helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hiki/data/models/cashflow_model.dart';
import 'package:flutter/material.dart';
import '../helpers/custom_snackbars.dart';
import '../core/default_list_cashflows.dart';

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
    log('Data inserting database started');
    for (var expense in defaultCashFlows) {
      await _dbHelper.insertCashflow(expense);
      log('Data inserted');
    }
    await fetchCashflows();
    box.write('first_time', false);
    isLoading.value = false;
  }

  /// **Fetch all cashflows from the database**
  Future<void> fetchCashflows() async {
    isLoading.value = true;
    final data = await _dbHelper.fetchCashflows();
    cashflows.assignAll(data);
    updateIncomeExpenseAmount(cashflows);
    isLoading.value = false;
  }

  /// **Update total income, expenses, and balance**
  void updateIncomeExpenseAmount(List<CashFlow> currentCashflows) {
    totalIncomes.value = currentCashflows
        .where((transaction) => transaction.isIncome)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

    totalExpenses.value = currentCashflows
        .where((transaction) => !transaction.isIncome)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

    currentBalance.value = totalIncomes.value - totalExpenses.value;
  }

  /// **Get filtered cashflows based on selected period and type**
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

  /// **Apply filters and update UI**
  void applyFilters(String period, String type) async {
    filterPeriod.value = period;
    filterType.value = type;
    update();
  }

  /// **Insert a new cashflow**
  void insertCashflow({
    required String title,
    required String amount,
    required DateTime chosenDate,
    required Category? chosenCategory,
    required bool isIncome,
  }) async {
    final enteredAmount = double.tryParse(amount);
    final isAmountInvalid = enteredAmount == null || enteredAmount <= 0;

    if (title.trim().isEmpty || isAmountInvalid || chosenCategory == null) {
      Get.defaultDialog(
        title: 'warning'.tr,
        middleText: 'please_enter_valid'.tr,
        confirm: TextButton(
          onPressed: () => Get.back(),
          child: Text('confirm'.tr),
        ),
      );
      return;
    }

    final newCashflow = CashFlow(
      title: title,
      amount: enteredAmount,
      date: chosenDate,
      category: chosenCategory,
      isIncome: isIncome,
    );

    cashflows.add(newCashflow);
    cashflows.sort((a, b) => b.date.compareTo(a.date));

    updateIncomeExpenseAmount(cashflows);
    update();

    await _dbHelper.insertCashflow(newCashflow);
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

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: Text("deleting_all".tr),
        content: Text('remember_delete_action'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text("cancel".tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
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

  void cancelSelection() {
    selectedIds.clear();
    isSelectionMode.value = false;
  }

  void deleteSelectedCashflows() async {
    Get.closeCurrentSnackbar();

    // Store removed items for undo
    final removedCashflows =
        cashflows.where((c) => selectedIds.contains(c.id)).toList();

    for (var id in selectedIds) {
      await _dbHelper.deleteCashflow(id);
      cashflows.removeWhere((item) => item.id == id);
    }

    updateIncomeExpenseAmount(cashflows);
    update();
    cancelSelection();

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
}
