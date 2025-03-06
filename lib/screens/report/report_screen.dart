import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiki/controller/data_ctrl.dart';
import 'package:hiki/data/models/cashflow_model.dart';
import 'package:hiki/data/models/report_model.dart';
import 'package:hiki/helpers/get_filtered_cashflows.dart';
import 'package:hiki/helpers/period_toogle_button.dart';

import 'widgets/chart.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final DataCtrl c = Get.find();
  final RxBool isLoading = false.obs;
  final RxList<CashFlow> currentCashflows = <CashFlow>[].obs;

  @override
  void initState() {
    super.initState();
    _updateCashflows('Overall');
  }

  Future<void> _updateCashflows(String value) async {
    isLoading.value = true;

    final filteredCashflows = await filterCashflows(value, c.cashflows);
    currentCashflows.assignAll(filteredCashflows);
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Column(
      children: [
        PeriodToogleButton(
          onPressed: _updateCashflows,
        ),
        Expanded(
          child: Obx(() {
            if (isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blueGrey),
              );
            }

            final incomeInfo = ReportInfo(
              transactions: currentCashflows,
              isIncomeReport: true,
            );

            final expenseInfo = ReportInfo(
              transactions: currentCashflows,
              isIncomeReport: false,
            );

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: 2,
              itemBuilder: (context, index) {
                final reportInfo = index == 0 ? incomeInfo : expenseInfo;
                return Chart(
                  isIncome: reportInfo.isIncomeReport,
                  chartTitle:
                      index == 0 ? 'total_income'.tr : 'total_expense'.tr,
                  maxBucket: reportInfo.maxBucketValue,
                  buckets: reportInfo.filteredBuckets,
                  sortedBuckets: reportInfo.maxToMinBuckets,
                  isDarkMode: isDarkMode,
                  totalBucketsAmount: reportInfo.allBucketsAmount!,
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
