import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

//creating new intance of named DateFormat.yMd() constructor from intl package
final formatter = DateFormat.yMd();

//Uuid is a package to generate unique id
var uuid = const Uuid();

//Base class for categories
abstract class Category {
  const Category();
}

//Enum for Expense Categories
enum ExpenseCategory implements Category {
  food,
  transport,
  shopping,
  utilities,
  education,
  work,
  doctor,
  personal,
  others
}

//Enum for Income Categories
enum IncomeCategory implements Category {
  salary,
  investment,
  gift,
  service,
  rent,
  business,
  trade,
  reward,
  others
}

//creating a Map with key (enum Category) and value (icons)
const expenseCategoryIcons = {
  ExpenseCategory.food: Icons.dining,
  ExpenseCategory.transport: Icons.subway,
  ExpenseCategory.shopping: Icons.shopping_cart,
  ExpenseCategory.utilities: Icons.gas_meter_sharp,
  ExpenseCategory.education: Icons.menu_book,
  ExpenseCategory.work: Icons.work,
  ExpenseCategory.doctor: Icons.monitor_heart,
  ExpenseCategory.personal: Icons.person_3,
  ExpenseCategory.others: Icons.category,
};

const incomeCategoryIcons = {
  IncomeCategory.salary: Icons.work_history,
  IncomeCategory.investment: Icons.trending_up,
  IncomeCategory.gift: Icons.card_giftcard,
  IncomeCategory.service: Icons.construction,
  IncomeCategory.rent: Icons.home,
  IncomeCategory.business: Icons.business_center,
  IncomeCategory.trade: Icons.savings,
  IncomeCategory.reward: Icons.emoji_events,
  IncomeCategory.others: Icons.more_horiz,
};

// Transaction class can now handle both types of categories (Expense and Income)
class CashFlow {
  CashFlow({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.isIncome,
  }) : id = uuid.v4();

  String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category
      category; // Can now accept both ExpenseCategory and IncomeCategory
  final bool isIncome;

  String get formattedDate {
    return formatter.format(date);
  }

  // Convert Transaction object to a Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.toString(), // Store enum as String
      'isIncome': isIncome ? 1 : 0, // SQLite uses integers for boolean
    };
  }

  // Convert a Map from the database to a Transaction object
  // ..id = map['id'] => it is used  to assign the id after the CashFlow object has been created.
  // It is needed to assign id from database. Otherwise new id will be assigned using uuid
  static CashFlow fromMap(Map<String, dynamic> map) {
    return CashFlow(
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['isIncome'] == 1
          ? IncomeCategory.values.firstWhere(
              (e) => e.toString() == map['category'],
            )
          : ExpenseCategory.values.firstWhere(
              (e) => e.toString() == map['category'],
            ),
      isIncome: map['isIncome'] == 1,
    )..id = map['id'];
  }
}

// A class to handle grouped transactions by category (Expense or Income)
class TransactionBucket {
  TransactionBucket({
    required this.category,
    required this.transactions,
  });

  // This constructor filters transactions by the given category
  TransactionBucket.forCategory(List<CashFlow> allTransactions, this.category)
      : transactions = allTransactions
            .where((transaction) => transaction.category == category)
            .toList();

  final Category category;
  final List<CashFlow> transactions;

  // Returns the total amount of all transactions (expenses or income)
  double get totalAmount {
    double sum = 0;
    for (final transaction in transactions) {
      sum += transaction.amount;
    }
    return sum;
  }
}
