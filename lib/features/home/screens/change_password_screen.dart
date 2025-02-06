import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ប្តូរលេខសម្ងាត់',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const CustomTextField(
              label: 'លេខសម្ងាត់បច្ចុប្បន្ន',
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'លេខសម្ងាត់ថ្មី',
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'បញ្ជាក់លេខសម្ងាត់ថ្មី',
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Save password changes
                Navigator.pop(context);
              },
              child: const Text('រក្សាទុក'),
            ),
          ],
        ),
      ),
    );
  }
}
