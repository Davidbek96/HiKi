import 'package:get/get.dart';
import 'package:hiki/data/models/cashflow_model.dart';

DateTime _today = DateTime.now();
DateTime _startOfWeek = _today.subtract(Duration(days: _today.weekday - 1));
DateTime _startOfMonth = DateTime(_today.year, _today.month, 1);
DateTime _twoYearsAgo = DateTime(_today.year - 2, _today.month, _today.day);

List<CashFlow> defaultCashFlows = [
  CashFlow(
    title: 'swipe_to_remove'.tr,
    amount:
        200000, // Amount can be set as needed for this action (it's just a message)
    date: _today,
    category: IncomeCategory.others,
    isIncome: true,
  ),
  CashFlow(
    title: 'buying_groceries'.tr,
    amount: 90000,
    date: _twoYearsAgo,
    category: ExpenseCategory.food,
    isIncome: false,
  ),
  CashFlow(
    title: 'salary'.tr,
    amount: 700000,
    date: _startOfMonth,
    category: IncomeCategory.salary,
    isIncome: true,
  ),
  CashFlow(
    title: 'electricity'.tr,
    amount: 200000,
    date: _startOfWeek,
    category: ExpenseCategory.utilities,
    isIncome: false,
  ),
];
