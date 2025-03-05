import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hiki/controller/input_ctrl.dart';
import 'package:get/get.dart';
import 'package:hiki/data/models/cashflow_model.dart';
import 'package:hiki/core/colors_const.dart';

class Categories extends StatelessWidget {
  Categories({
    super.key,
  });

  final InputCtrl c = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal:
                BorderSide(width: 2.5, color: Theme.of(context).highlightColor),
          ),
        ),
        child: Obx(
          () => GridView.builder(
            padding: EdgeInsets.only(top: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isSmallScreen ? 3 : 4,
              mainAxisSpacing: isSmallScreen ? 5 : 10,
              crossAxisSpacing: isSmallScreen ? 10 : 8,
              childAspectRatio: isSmallScreen ? 1.12 : 1,
            ),
            itemCount: c.categoryToggleIndex.value == 0
                ? IncomeCategory.values.length
                : ExpenseCategory.values.length,
            itemBuilder: (BuildContext context, int index) {
              return Obx(
                () => GestureDetector(
                  onTap: () {
                    c.onChooseCategory(index);
                    log("###########${c.selectedItemIndex.value}######");
                  },
                  child: Card(
                    elevation: 2, // Controls the depth of the shadow
                    shadowColor: Colors.black26, // Customize the shadow color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    margin: const EdgeInsets.all(6),
                    child: Container(
                      decoration: BoxDecoration(
                        border: c.selectedItemIndex.value == index
                            ? null
                            : Border.all(
                                color: Theme.of(context).colorScheme.surfaceDim,
                                width: 2.0, // Border width
                              ),
                        borderRadius: BorderRadius.circular(
                            12), // Match the card's rounded corners
                        gradient: index == c.selectedItemIndex.value
                            ? LinearGradient(
                                colors: c.categoryToggleIndex.value == 0
                                    ? [
                                        kIncomeColor.withAlpha(170),
                                        kIncomeColor.withAlpha(220),
                                      ]
                                    : [
                                        kExpenseColor.withAlpha(170),
                                        kExpenseColor.withAlpha(200),
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            c.categoryToggleIndex.value == 0
                                ? incomeCategoryIcons[
                                    IncomeCategory.values[index]]
                                : expenseCategoryIcons[
                                    ExpenseCategory.values[index]],
                            color: index == c.selectedItemIndex.value
                                ? Colors.white
                                : kGradientColors[
                                    index % kGradientColors.length][0],
                            //Theme.of(context).colorScheme.onSecondaryContainer,
                            size: 32,
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              c.categoryToggleIndex.value == 0
                                  ? IncomeCategory.values[index].name.tr
                                      .toUpperCase()
                                  : ExpenseCategory.values[index].name.tr
                                      .toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: index == c.selectedItemIndex.value
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
