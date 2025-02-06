import 'package:flutter/material.dart';
import '../widgets/feature_card.dart';
import '../../../core/constants/app_strings.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          AppStrings.welcomeTo,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                        ),
                      ),
                      Text(
                        AppStrings.appName,
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: const Color(0xFF1B5E20),
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                  letterSpacing: 0.5,
                                ),
                      ),
                    ],
                  ),
                ),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    FeatureCard(
                      title: AppStrings.landMeasurement,
                      icon: Icons.landscape,
                      description: AppStrings.landMeasurementDesc,
                      onTap: () {},
                    ),
                    FeatureCard(
                      title: AppStrings.weatherAnalysis,
                      icon: Icons.cloud,
                      description: AppStrings.weatherAnalysisDesc,
                      onTap: () {},
                    ),
                    FeatureCard(
                      title: AppStrings.aiAssistant,
                      icon: Icons.smart_toy,
                      description: AppStrings.aiAssistantDesc,
                      onTap: () {},
                    ),
                    FeatureCard(
                      title: AppStrings.qaForum,
                      icon: Icons.forum,
                      description: AppStrings.qaForumDesc,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
        ),
      ),
    );
  }
}
