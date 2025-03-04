import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hiki/controller/data_ctrl.dart';
import 'package:hiki/data/models/cashflow_model.dart';
import 'package:hiki/screens/add_cashflow/add_screen.dart';
import 'package:hiki/screens/home/widgets/list_item.dart';

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
      child: SlidableAutoCloseBehavior(
        child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (ctx, index) {
            final cashflow = transactions[index];
            final isSelected = c.selectedIds.contains(cashflow.id);

            if (c.isSelectionMode.value) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: GestureDetector(
                  onLongPress: () => c.toggleSelection(cashflow.id),
                  onTap: () => c.toggleSelection(cashflow.id),
                  child: TransactionItem(
                    transaction: cashflow,
                    index: index,
                    isSelected: isSelected,
                    c: c,
                  ),
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: Slidable(
                  key: ValueKey(cashflow.id),

                  // Allow only right-to-left swipe
                  startActionPane: null,
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(), // Smooth sliding motion
                    extentRatio: 0.5, // Takes half of the item width
                    children: [
                      // Edit Button
                      SlidableAction(
                        onPressed: (context) {
                          Get.to(
                            () => AddCashflowScreen(cashflow: cashflow),
                          );
                        },
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        backgroundColor: Colors.blue.shade300,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'edit'.tr,
                      ),

                      // Delete Button
                      SlidableAction(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        onPressed: (context) async {
                          final bool confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('confirm_delete'.tr),
                              content: Text('delete_message'.tr),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('cancel'.tr),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text('delete'.tr),
                                ),
                              ],
                            ),
                          );

                          if (confirm) {
                            c.deleteCashflow(cashflow);
                          }
                        },
                        backgroundColor: const Color.fromARGB(255, 215, 91, 89),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'delete'.tr,
                      ),
                    ],
                  ),

                  child: GestureDetector(
                    onLongPress: () => c.toggleSelection(cashflow.id),
                    child: TransactionItem(
                      transaction: cashflow,
                      index: index,
                      isSelected: isSelected,
                      c: c,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
