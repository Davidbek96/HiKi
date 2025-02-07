import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        title: Text(
          "about_app".tr, // Using key for "Ilova haqida"
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Info Section
              _buildSectionTitle("app_info".tr),
              const SizedBox(height: 10),
              Text(
                'app_description'.tr,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),

              // Developer Info Section
              _buildSectionTitle("developer".tr),
              const SizedBox(height: 10),
              Text(
                "developer_info".tr,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),

              // Features Section
              _buildSectionTitle("features".tr),
              const SizedBox(height: 10),
              _buildFeatureList([
                "feature_1".tr,
                "feature_2".tr,
                "feature_3".tr,
                "feature_4".tr,
                "feature_5".tr,
              ]),
              const SizedBox(height: 20),

              // Contact Info Section
              _buildSectionTitle("contact".tr),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.email,
                    size: 20,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: "dovudbek.developer@gmail.com",
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("email_copied".tr)),
                        );
                      },
                      child: Text(
                        "dovudbek.developer@gmail.com",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section title builder
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Feature list builder
  Widget _buildFeatureList(List<String> features) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features
          .map(
            (feature) => Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 20, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feature,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
