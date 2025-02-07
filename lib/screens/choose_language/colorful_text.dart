import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorfulText extends StatelessWidget {
  const ColorfulText({super.key});

  @override
  Widget build(BuildContext context) {
    final logoColor = Get.isDarkMode ? Colors.lightBlueAccent : Colors.blue;
    final normalColor = Get.isDarkMode ? Colors.grey : Colors.blueGrey;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Hi',
            style: TextStyle(
                color: logoColor, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'sob  ',
            style: TextStyle(
                color: normalColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'Ki',
            style: TextStyle(
                color: logoColor, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'tob',
            style: TextStyle(
                color: normalColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
