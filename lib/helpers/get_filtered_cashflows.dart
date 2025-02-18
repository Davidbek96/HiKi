import 'package:hiki/data/models/cashflow_model.dart';

Future<List<CashFlow>> filterCashflows(
    String filterPeriod, List<CashFlow> cashflows) async {
  List<CashFlow> filteredList = [];
  DateTime now = DateTime.now();
  DateTime startOfPeriod;

  switch (filterPeriod) {
    case 'Today':
      startOfPeriod = DateTime(now.year, now.month, now.day);
      break;
    case 'Week':
      DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
      startOfPeriod = DateTime(
          firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day);
      break;
    case 'Month':
      startOfPeriod = DateTime(now.year, now.month, 1);
      break;
    case 'Year':
      startOfPeriod = DateTime(now.year, 1, 1);
      break;
    default:
      startOfPeriod = DateTime(now.year - 10);
  }

  filteredList = cashflows.where((transaction) {
    final transactionDate = transaction.date;
    if (transactionDate.isBefore(startOfPeriod)) return false;
    return true;
  }).toList();

  return filteredList;
}
