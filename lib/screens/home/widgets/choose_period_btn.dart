import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiki/controller/data_ctrl.dart';
import 'package:hiki/core/themes.dart';

class ChoosePeriodButtons extends StatelessWidget {
  ChoosePeriodButtons({
    super.key,
    required this.c,
  });

  final DataCtrl c;

  // Mapping the period options
  final Map<String, String> periodOptions = {
    'Overall': 'overall_period'.tr,
    'Today': 'today_period'.tr,
    'Week': 'week_period'.tr,
    'Month': 'month_period'.tr,
    'Year': 'year_period'.tr,
  };

  @override
  Widget build(BuildContext context) {
    // Extracting the keys (English labels) and values (Translated labels) from the map
    final List<String> keys = periodOptions.keys.toList();
    final List<String> values = periodOptions.values.toList();

    // Getting screen width to make the design responsive
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05), // Dynamic horizontal padding
        child: Row(
          children: values.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final label = entry.value;
              final isSelected = c.filterPeriod.value == keys[index];

              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02), // Dynamic button spacing
                child: ElevatedButton(
                  onPressed: () {
                    // Apply the selected filter based on the button pressed
                    c.applyFilters(keys[index], c.filterType.value);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(0.0),
                    elevation: isSelected ? 2 : 1,
                    shadowColor: kColorScheme.surfaceDim,
                    backgroundColor: isSelected
                        ? Colors.blueGrey.shade400
                        : Theme.of(context).colorScheme.onInverseSurface,
                    foregroundColor: Theme.of(context).colorScheme.outline,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(screenWidth * 0.15,
                        34), // Dynamic minimum size based on screen width
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Get.isDarkMode
                              ? Colors.black87
                              : Theme.of(context).colorScheme.onPrimary
                          : null,
                    ),
                  ).marginSymmetric(horizontal: 12),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
