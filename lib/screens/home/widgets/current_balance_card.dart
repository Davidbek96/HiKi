import 'package:hiki/core/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class CurrentBalanceCard extends StatelessWidget {
  const CurrentBalanceCard({
    super.key,
    required this.totalExpenses,
    required this.totalIncomes,
    required this.currentBalance,
    required this.title,
  });

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screnHeight =
        MediaQuery.of(context).size.height; // Adjust dynamically
    return Container(
      width: double.infinity,
      height: screnHeight / 4.5,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: 8),
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.03,
        horizontal: screenWidth * 0.05,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? kGradientDark
              : kGradientLight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              formattedCurrentBalance,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Income Section
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
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              formattedIncomes,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Expense Section
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
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              formattedExpenses,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
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
