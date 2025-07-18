import 'dart:developer';

import 'package:hiki/controller/data_ctrl.dart';

import 'package:hiki/screens/add_cashflow/add_screen.dart';
import 'package:hiki/screens/home/upgrader.dart';
import 'package:hiki/screens/report/report_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiki/screens/settings/settings_screen.dart';

class HomeNavigation extends StatelessWidget {
  HomeNavigation({super.key});

  final DataCtrl c = Get.put(DataCtrl());

  final _navigationBarIndex = 0.obs;

  // List of pages for the BottomNavigationBar
  final List<Widget> pages = [
    UpgraderWidget(), //MainScreen is located in Upgrader
    ReportScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    log('===> Home Navigation build');
    return Obx(
      () => Scaffold(
        body: SafeArea(child: pages[_navigationBarIndex.value]),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: _navigationBarIndex.value != 0
            ? null
            : FloatingActionButton(
                onPressed: () async {
                  await Get.to(() => AddCashflowScreen());
                  c.clearSelections();
                  _navigationBarIndex.value = 0;
                  c.filterPeriod.value =
                      'Overall'; // Reset to home when returning
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      transform: GradientRotation(6.5),
                      colors: [
                        Colors.orange,
                        Color.fromARGB(255, 175, 125, 245),
                        Color.fromARGB(255, 22, 226, 248),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                  ),
                ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          currentIndex: _navigationBarIndex.value,
          onTap: (int index) {
            _navigationBarIndex.value = index;
            if (index != 0) {
              //when going to another page setting back to overall filter
              c.filterPeriod.value = 'Overall';
              c.clearSelections();
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.home,
                  size: 28,
                ),
              ),
              label: 'home'.tr, // Translation key for "Asosiy"
            ),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.bar_chart,
                  size: 28,
                ),
              ),
              label: 'report'.tr, // Translation key for "Hisobot"
            ),
            BottomNavigationBarItem(
              icon: const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.settings,
                  size: 28,
                ),
              ),
              label: 'settings'.tr, // Translation key for "Sozlash"
            ),
          ],
        ),
      ),
    );
  }
}
