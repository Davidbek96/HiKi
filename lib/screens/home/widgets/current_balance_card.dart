import 'package:hiki/core/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class CurrentBalanceCard extends StatelessWidget {
  const CurrentBalanceCard(
      {super.key,
      required this.totalExpenses,
      required this.totalIncomes,
      required this.currentBalance,
      required this.title});

  final double totalExpenses;
  final double totalIncomes;
  final double currentBalance;
  final String title;

  String get formattedExpenses =>
      totalExpenses == 0 ? '0.00' : NumberFormat('#,###').format(totalExpenses);
  String get formattedIncomes =>
      totalIncomes == 0 ? '0.00' : NumberFormat('#,###').format(totalIncomes);
  String get formattedCurrentBalance => currentBalance == 0
      ? '0.00'
      : NumberFormat('#,###').format(currentBalance);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      margin: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        boxShadow: [],
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? [
                  Color.fromARGB(200, 0, 37, 43),
                  Color.fromARGB(200, 3, 50, 58),
                  Color.fromARGB(200, 0, 37, 43),
                ]
              : [
                  Color.fromARGB(255, 29, 226, 247),

                  Color.fromARGB(255, 163, 104, 245), // Light purple
                  Colors.orange, // Orange
                ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            formattedCurrentBalance,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white30,
                      radius: 14,
                      child: Icon(Icons.arrow_upward,
                          size: 18, color: kIncomeColor),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'income'.tr,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            formattedIncomes,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'expense'.tr,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            formattedExpenses,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.white30,
                      radius: 14,
                      child: Icon(Icons.arrow_downward,
                          size: 18, color: kExpenseColor),
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
