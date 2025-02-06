import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../core/constants/app_strings.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.register, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Icon(
                  Icons.eco,
                  size: 60,
                  color: Color(0xFF2E7D32),
                ),
                const SizedBox(height: 32),
                const CustomTextField(
                  label: 'ឈ្មោះពេញ',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  label: 'អ៊ីមែល',
                  icon: Icons.email,
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  label: 'លេខសម្ងាត់',
                  icon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add registration logic here
                    },
                    child: const Text('ចុះឈ្មោះ'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(  
                    'មានគណនីរួចហើយមែនទេ? ចូល',
                    style: TextStyle(color: Color(0xFF2E7D32)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
