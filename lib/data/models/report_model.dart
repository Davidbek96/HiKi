import 'package:hiki/data/models/cashflow_model.dart';

class ReportInfo {
  ReportInfo({
    required this.transactions,
    required this.isIncomeReport,
  });

  final List<CashFlow> transactions;
  final bool isIncomeReport;

  // Get all income transactions
  List<CashFlow> get incomeTransactions =>
      transactions.where((transaction) => transaction.isIncome).toList();

  // Get all expense transactions
  List<CashFlow> get expenseTransactions =>
      transactions.where((transaction) => !transaction.isIncome).toList();

  //categorize all incomes into buckets and save it as a list
  //or categorize all expenses into buckets and save it as a list
  List<TransactionBucket> get categorizedBuckets {
    List<TransactionBucket> buckets = [];

    if (isIncomeReport) {
      for (var category in IncomeCategory.values) {
        buckets
            .add(TransactionBucket.forCategory(incomeTransactions, category));
      }
    } else {
      for (var category in ExpenseCategory.values) {
        buckets
            .add(TransactionBucket.forCategory(expenseTransactions, category));
      }
    }
    return buckets;
  }

  double get maxBucketInBuckets {
    double maxBucket = 0;
    for (final bucket in categorizedBuckets) {
      if (bucket.totalAmount > maxBucket) {
        maxBucket = bucket.totalAmount;
      }
    }
    return maxBucket;
  }

  //Sorting buckets by total expenses in the list big -> small
  List<TransactionBucket> get sortedBuckets {
    List<TransactionBucket> newBuckets = categorizedBuckets;

    newBuckets.sort((b, a) => a.totalAmount.compareTo(b.totalAmount));

    return newBuckets;
  }

  //get overall expenses of all buckets
  double? get allBucketsAmount {
    double sum = 0;
    for (var bucket in sortedBuckets) {
      sum += bucket.totalAmount;
    }
    return sum;
  }
}
