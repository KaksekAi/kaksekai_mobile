import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import 'land_measurement_instruction_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _navigateToScreen(BuildContext context, String route) {
    if (route == '/land-measurement') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LandMeasurementInstructionScreen(),
        ),
      );
    } else {
      Navigator.pushNamed(
        context,
        route,
        arguments: {'previousRoute': ModalRoute.of(context)?.settings.name},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('ចាកចេញ?'),
            content: const Text('តើអ្នកពិតជាចង់ចាកចេញពីកម្មវិធីមែនទេ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'ទេ',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                ),
                child: const Text('បាទ/ចាស'),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.png'),
              fit: BoxFit.cover,
              opacity: 0.1,
            ),
          ),
          child: SafeArea(
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
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                          ),
                        ),
                        Text(
                          AppStrings.appName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: const Color(0xFF1B5E20),
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: [
                      _buildOptionCard(
                        context,
                        title: 'គ្រប់គ្រងដំណាំ',
                        icon: Icons.agriculture,
                        description: 'បន្ថែម កែប្រែ និងលុបព័ត៌មានដំណាំរបស់អ្នក',
                        onTap: () =>
                            _navigateToScreen(context, '/farm-management'),
                      ),
                      _buildOptionCard(
                        context,
                        title: 'ជ្រើសរើសកាលបរិច្ឆេទដាំដុះ',
                        icon: Icons.calendar_month,
                        description: 'ជ្រើសរើសកាលបរិច្ឆេទដាំដុះដំណាំរបស់អ្នក',
                        onTap: () =>
                            _navigateToScreen(context, '/planting-date'),
                      ),
                      _buildOptionCard(
                        context,
                        title: 'វិភាគអាកាសធាតុ',
                        icon: Icons.cloud,
                        description: 'ពិនិត្យស្ថានភាពអាកាសធាតុសម្រាប់កសិកម្ម',
                        onTap: () =>
                            _navigateToScreen(context, '/weather-analysis'),
                      ),
                      _buildOptionCard(
                        context,
                        title: 'វាស់វែងដី',
                        icon: Icons.landscape,
                        description: 'វាស់វែងផ្ទៃដីរបស់អ្នក',
                        onTap: () =>
                            _navigateToScreen(context, '/land-measurement'),
                      ),
                      _buildOptionCard(
                        context,
                        title: 'ជំនួយការ AI',
                        icon: Icons.smart_toy,
                        description: 'សួរសំណួរទាក់ទងនឹងកសិកម្ម',
                        onTap: () =>
                            _navigateToScreen(context, '/ai-assistant'),
                      ),
                      _buildOptionCard(
                        context,
                        title: 'អំពីអ្នកអភិវឌ្ឍន៍',
                        icon: Icons.person,
                        description: 'ព័ត៌មានលម្អិតអំពីអ្នកអភិវឌ្ឍន៍កម្មវិធី',
                        onTap: () =>
                            _navigateToScreen(context, '/about-developer'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: const Color(0xFF1B5E20),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1B5E20),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
