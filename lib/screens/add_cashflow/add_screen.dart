import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiki/controller/input_ctrl.dart';
import 'package:hiki/controller/data_ctrl.dart';
import 'package:hiki/core/colors_const.dart';
import 'package:hiki/data/models/cashflow_model.dart';
import 'package:hiki/screens/add_cashflow/widgets/categories.dart';
import 'widgets/title_date_input.dart';

class AddCashflowScreen extends StatelessWidget {
  AddCashflowScreen({super.key, this.cashflow});

  final CashFlow? cashflow;
  final DataCtrl dataCtrl = Get.find();
  final InputCtrl inputCtrl = Get.put(InputCtrl()); // Pass `cashflow`

  void _submitCashflow() {
    dataCtrl.saveCashflow(
      id: cashflow?.id,
      title: inputCtrl.titleController.text,
      amount: inputCtrl.savedAmountWithoutCommas.value,
      date: inputCtrl.selectedDate.value!,
      category: inputCtrl.selectedCategory.value,
      isIncome: inputCtrl.categoryToggleIndex.value == 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    log("Main add screen built");
    //when editing a cashflow , assign all variable to show in editing ui
    if (cashflow != null) {
      inputCtrl.assignDataOnEdit(cashflow!);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
          child: Column(
            children: [
              Obx(
                () => ToggleButtons(
                  selectedBorderColor: inputCtrl.categoryToggleIndex.value == 0
                      ? kIncomeColor.withAlpha(240)
                      : kExpenseColor.withAlpha(210),
                  borderWidth: 2,
                  fillColor: inputCtrl.categoryToggleIndex.value == 0
                      ? kIncomeColor.withAlpha(240)
                      : kExpenseColor.withAlpha(210),
                  borderRadius: BorderRadius.circular(10.0),
                  isSelected: [
                    inputCtrl.categoryToggleIndex.value == 0,
                    inputCtrl.categoryToggleIndex.value == 1
                  ],
                  onPressed: (index) {
                    inputCtrl.categoryToggleIndex.value = index;
                    inputCtrl.selectedItemIndex.value = null;
                    FocusScope.of(context).unfocus();

                    log('====> ${inputCtrl.categoryToggleIndex.value}');
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'income'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: inputCtrl.categoryToggleIndex.value == 0
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'expense'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: inputCtrl.categoryToggleIndex.value == 1
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TitleDateInput(),
              const SizedBox(height: 15),
              Categories(),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Get.back(), child: Text('cancel'.tr)),
                  const SizedBox(width: 10),
                  Obx(
                    () => ElevatedButton(
                      onPressed: () {
                        log("title: ${inputCtrl.titleController.text}, amount: ${inputCtrl.savedAmountWithoutCommas.value}, chosenDate: ${inputCtrl.selectedDate.value!}, chosenCategory: ${inputCtrl.selectedCategory.value}, isIncome: ${inputCtrl.categoryToggleIndex.value == 0},");
                        _submitCashflow();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            inputCtrl.categoryToggleIndex.value == 0
                                ? kIncomeColor.withAlpha(240)
                                : kExpenseColor
                                    .withAlpha(210), // Set the background color
                        foregroundColor: Colors.white, // Set the text color
                        elevation: 5, // Optional: Adds a shadow effect
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        ),
                      ),
                      child: Text("save".tr),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
