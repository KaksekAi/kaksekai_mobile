import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_text_field.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('កែប្រែព័ត៌មានផ្ទាល់ខ្លួន',
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
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF2E7D32),
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Add image picker functionality
              },
              child: const Text('ប្តូររូបភាព'),
            ),
            const SizedBox(height: 32),
            const CustomTextField(
              label: 'ឈ្មោះពេញ',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'អ៊ីមែល',
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'លេខទូរស័ព្ទ',
              icon: Icons.phone_outlined,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Save profile changes
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
