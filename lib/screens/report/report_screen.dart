import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiki/controller/data_ctrl.dart';
import 'package:hiki/data/models/report_model.dart';

import 'widgets/chart.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({
    super.key,
  });

  final DataCtrl c = Get.find();

  @override
  Widget build(BuildContext context) {
    final transactions = c.cashflows;
    final incomeInfo = ReportInfo(
      transactions: transactions,
      isIncomeReport: true,
    );

    final expenseInfo = ReportInfo(
      transactions: transactions,
      isIncomeReport: false,
    );

    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  'report_title'.tr, // Using key for "Hisobot"
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 20),
                ),
              ),
            ),
          ),
          Chart(
            isIncome: incomeInfo.isIncomeReport,
            chartTitle: 'total_income'.tr, // Using key for "Umumiy Daromad"
            maxBucket: incomeInfo.maxBucketInBuckets,
            buckets: incomeInfo.categorizedBuckets,
            sortedBuckets: incomeInfo.sortedBuckets,
            isDarkMode: isDarkMode,
            totalBucketsAmount: incomeInfo.allBucketsAmount!,
          ),
          Chart(
            isIncome: expenseInfo.isIncomeReport,
            chartTitle: 'total_expense'.tr, // Using key for "Umumiy Xarajat"
            maxBucket: expenseInfo.maxBucketInBuckets,
            buckets: expenseInfo.categorizedBuckets,
            sortedBuckets: expenseInfo.sortedBuckets,
            isDarkMode: isDarkMode,
            totalBucketsAmount: expenseInfo.allBucketsAmount!,
          ),
        ],
      ),
    );
  }
}
