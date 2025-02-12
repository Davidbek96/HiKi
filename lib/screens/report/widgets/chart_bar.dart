import 'package:hiki/core/colors_const.dart';
import 'package:flutter/material.dart';
import 'package:hiki/data/models/cashflow_model.dart';
import 'package:intl/intl.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    super.key,
    required this.fill,
    required this.bucketAmount,
    required this.colorIndex,
    required this.category,
    required this.isIncome,
  });

  final double fill;
  final double bucketAmount;
  final int colorIndex;
  final Category category;
  final bool isIncome;

  String get bucketAmountAsString {
    var amountAsString = bucketAmount.toInt() == 0
        ? '0.00'
        : NumberFormat('#,###').format(bucketAmount);
    amountAsString = (amountAsString.length > 7
        ? '${amountAsString.substring(0, 8)}..'
        : amountAsString);
    return amountAsString;
  }

  List<List<Color>> get gradientColors =>
      isIncome ? kIncomeGradientColors : kExpenseGradientColors;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: FractionallySizedBox(
          heightFactor:
              fill.clamp(0.05, 1.0), // Ensures a minimum visible height
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: gradientColors[colorIndex],
              ),
              shape: BoxShape.rectangle,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
            ),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -20,
                  child: SizedBox(
                    width: 60, // Set max width
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        bucketAmountAsString,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      isIncome
                          ? incomeCategoryIcons[category]
                          : expenseCategoryIcons[category],
                      color: gradientColors[colorIndex][0],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
