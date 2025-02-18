import 'package:hiki/controller/data_ctrl.dart';
import 'package:hiki/core/themes.dart';
import 'package:hiki/data/models/cashflow_model.dart';
import 'package:hiki/screens/home/widgets/list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListeviewCashflows extends StatelessWidget {
  const ListeviewCashflows({
    super.key,
    required this.transactions,
    required this.c,
  });

  final List<CashFlow> transactions;
  final DataCtrl c;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (ctx, index) {
          final cashflow = transactions[index];
          final isSelected = c.selectedIds.contains(cashflow.id);

          if (c.isSelectionMode.value) {
            // Selection mode (Disable swipe-to-delete)
            return GestureDetector(
                onLongPress: () => c.toggleSelection(cashflow.id),
                onTap: () => c.toggleSelection(cashflow.id),
                child: TransactionItem(
                  transaction: cashflow,
                  index: index,
                  isSelected: isSelected,
                  c: c,
                ));
          } else {
            // Normal mode (Enable swipe-to-delete)
            return Dismissible(
              key: ValueKey(cashflow),
              background: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  color: Theme.of(context)
                      .colorScheme
                      .error
                      .withValues(alpha: 0.75),
                  margin: EdgeInsets.symmetric(
                    horizontal: Theme.of(context).cardTheme.margin!.horizontal,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'delete'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.onError,
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                ),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                c.deleteCashflow(cashflow);
              },
              child: GestureDetector(
                onLongPress: () => c.toggleSelection(cashflow.id),
                child: TransactionItem(
                  transaction: cashflow,
                  index: index,
                  isSelected: isSelected,
                  c: c,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
