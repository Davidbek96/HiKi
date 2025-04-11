import 'package:get/get.dart';
import 'package:hiki/core/colors_const.dart';
import 'package:hiki/data/models/cashflow_model.dart';
import 'package:hiki/screens/report/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  const Chart({
    super.key,
    required this.chartTitle,
    required this.buckets,
    required this.sortedBuckets,
    required this.maxBucket,
    required this.isDarkMode,
    required this.totalBucketsAmount,
    required this.isIncome,
  });

  final String chartTitle;
  final List<TransactionBucket> buckets;
  final List<TransactionBucket> sortedBuckets;
  final double maxBucket;
  final bool isDarkMode;
  final double totalBucketsAmount;
  final bool isIncome;

  String get _commaSeperatedAmount =>
      NumberFormat('#,###').format(totalBucketsAmount);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isScrenLarge = screenWidth > 800;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  chartTitle.tr, // Added translation for chart title
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                Flexible(
                  child: Text(
                    _commaSeperatedAmount,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: isIncome ? kIncomeColor : kExpenseColor,
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                width: isScrenLarge
                    ? sortedBuckets.length * 140
                    : sortedBuckets.length * 70, // Adjust the width as needed
                height: screenHeight / 3,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // for (final bucket in sortedBuckets)
                          for (int i = 0; i < sortedBuckets.length; i++)
                            ChartBar(
                              fill: sortedBuckets[i].totalAmount == 0
                                  ? 0
                                  : sortedBuckets[i].totalAmount / maxBucket,
                              bucketAmount: sortedBuckets[i].totalAmount,
                              colorIndex:
                                  (i % kExpenseGradientColors.length).toInt(),
                              category: sortedBuckets[i].category,
                              isIncome: isIncome,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
