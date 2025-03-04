import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hiki/controller/input_ctrl.dart';
import 'package:get/get.dart';
import 'package:hiki/controller/settings_ctrl.dart';
import 'package:hiki/core/colors_const.dart';
import 'package:hiki/data/models/cashflow_model.dart';
import 'package:intl/intl.dart';

class TitleDateInput extends StatelessWidget {
  TitleDateInput({super.key});

  final InputCtrl ctr = Get.find();
  final SettingsCtrl _settingsCtrl = Get.find();
  final NumberFormat numberFormatter = NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {
    final currencySymbol = _settingsCtrl.currencySymbol;
    final isShort = currencySymbol.length == 1;

    log('isUzbek ==> ${Get.locale!.languageCode}');
    log('isShort ==> $isShort');
    return Obx(
      () => Column(
        children: [
          TextField(
            autofocus: ctr.isEditMode.value,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            controller: ctr.titleController,
            maxLength: 60,
            decoration: InputDecoration(
              labelText: ctr.categoryToggleIndex.value == 0
                  ? 'income_name'.tr
                  : 'expense_name'.tr,
              prefixText: ' ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: ctr.categoryToggleIndex.value == 0
                      ? kIncomeColor.withAlpha(100)
                      : kExpenseColor.withAlpha(100),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  cursorColor: Colors.black54,
                  maxLength: 15,
                  controller: ctr.amountController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      ctr.amountController.text = '';
                      return;
                    }
                    log('value of emaunt controller: ${ctr.amountController.text}');
                    log('value of value: $value');

                    // Remove commas for saving or calculations
                    String valueWithoutCommas = value.replaceAll(',', '');
                    log('value of valueWithoutCommas: $valueWithoutCommas');

                    // Format the value with commas for display
                    final formattedValue = numberFormatter
                        .format(int.tryParse(valueWithoutCommas) ?? 0);

                    // Update the controller with the formatted value (with commas)
                    ctr.amountController.value = TextEditingValue(
                      text: formattedValue,
                      selection: TextSelection.collapsed(
                          offset: formattedValue.length),
                    );

                    // Save the value without commas (for backend or calculations)
                    ctr.savedAmountWithoutCommas.value = valueWithoutCommas;
                  },
                  decoration: InputDecoration(
                    labelText: 'amount'.tr,
                    prefixText: isShort ? currencySymbol.tr : null,
                    suffixText: isShort ? null : currencySymbol.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: ctr.categoryToggleIndex.value == 0
                            ? kIncomeColor.withAlpha(100)
                            : kExpenseColor.withAlpha(100),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => ctr.presentDatePicker(context),
                      icon: CircleAvatar(
                        backgroundColor: ctr.categoryToggleIndex.value == 0
                            ? kIncomeColor.withAlpha(50)
                            : kExpenseColor.withAlpha(50),
                        child: const Icon(
                          Icons.calendar_month,
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        ctr.selectedDate.value == null
                            ? 'select_date'.tr
                            : formatter.format(ctr.selectedDate.value!),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
