import 'dart:developer';

import 'package:hiki/controller/data_ctrl.dart';
import 'package:hiki/screens/home/widgets/current_balance_card.dart';
import 'package:hiki/screens/home/widgets/choose_period_btn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiki/screens/home/widgets/loading_indicator.dart';
import 'package:hiki/screens/home/widgets/listview_cashflows.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final DataCtrl c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          log('New Built');
          var transactions = c.filteredCashflows;
          return Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 8),
                  // Smooth toggle switch for filters
                  Row(
                    children: [
                      Expanded(child: ChoosePeriodButtons(c: c)),
                    ],
                  ),
                  // Current balance card
                  CurrentBalanceCard(
                    totalExpenses: c.totalExpenses.value,
                    totalIncomes: c.totalIncomes.value,
                    currentBalance: c.currentBalance.value,
                    title: c.filterPeriod.value == 'Overall'
                        ? 'current_balance'.tr
                        : 'total_profit'.tr, // Using translation keys
                  ),
                  // Transactions list
                  c.isLoading.value
                      ? Expanded(child: LoadingIndicator())
                      : transactions.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "no_data_message".tr, // Translation key
                                  ),
                                ),
                              ),
                            )
                          : ListeviewCashflows(
                              transactions: transactions, c: c),
                ],
              ),
              // Top selection action bar
              if (c.isSelectionMode.value)
                Positioned(
                  top: 10.0,
                  left: 15.0,
                  right: 15.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          child: Text(
                            '${c.selectedIds.length}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => c.cancelSelection(),
                              child: Text('cancel'.tr),
                            ),
                            SizedBox(width: 5),
                            ElevatedButton.icon(
                              onPressed: () => c.deleteSelectedCashflows(),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              label: Text('delete'.tr),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade400,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
