import 'package:hiki/controller/data_ctrl.dart';
import 'package:hiki/controller/settings_ctrl.dart';
import 'package:hiki/core/colors_const.dart';
import 'package:hiki/data/models/cashflow_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem(
      {required this.transaction,
      required this.index,
      required this.isSelected,
      required this.c,
      super.key});

  final CashFlow transaction;
  final int index;
  final bool isSelected;
  final DataCtrl c;
  // Formatter for transaction amounts
  String get formattedAmount {
    try {
      return NumberFormat('#,###', 'en_US').format(transaction.amount);
    } catch (e) {
      return transaction.amount.toString();
    }
  }

  final SettingsCtrl _settingsCtrl = Get.find();

  // Transaction sign based on income or expense
  String get transactionSign => transaction.isIncome ? '+ ' : '- ';

  // Icon based on transaction category
  IconData? get categoryIcon => transaction.isIncome
      ? incomeCategoryIcons[transaction.category] ?? Icons.category
      : expenseCategoryIcons[transaction.category] ?? Icons.category;

  // Color based on income or expense
  Color get transactionAmountColor =>
      transaction.isIncome ? kIncomeColor : kExpenseColor;

  // Gradient colors for transaction icon
  List<Color> get iconGradientColors =>
      kGradientColors[index % kExpenseGradientColors.length];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected & c.isSelectionMode.value
          ? Theme.of(context).colorScheme.error.withAlpha(50)
          : null,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
        child: Row(
          children: [
            _buildIcon(),
            const SizedBox(width: 12),
            _buildTitleAndDate(context),
            _buildAmountAndCurrency(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.center,
          colors: [
            iconGradientColors[0].withAlpha(190),
            iconGradientColors[1].withAlpha(190)
          ],
        ),
      ),
      child: Icon(categoryIcon, size: 22),
    );
  }

  Widget _buildTitleAndDate(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 14,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            transaction.formattedDate.isNotEmpty
                ? transaction.formattedDate
                : 'date_not_entered'.tr,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountAndCurrency(BuildContext context) {
    return Expanded(
      flex: 3,
      child: _settingsCtrl.currencySymbol.tr.length == 1
          ? Row(
              children: [
                Expanded(
                  child: Text(
                    '$transactionSign$formattedAmount ${_settingsCtrl.currencySymbol.tr}',
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: transactionAmountColor,
                        ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$transactionSign$formattedAmount',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: transactionAmountColor,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  _settingsCtrl.currencySymbol.tr,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
    );
  }
}
