import 'package:flutter/material.dart';
import '../../../features/home/screens/edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'notification_settings_screen.dart';
import 'about_us_screen.dart';
import 'about_me_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('គណនី', style: TextStyle(color: Colors.white)),
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
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Header
            const SizedBox(height: 20),
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
            const Text(
              'ឈ្មោះ​អ្នកប្រើប្រាស់',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'user@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Profile Options
            const _ProfileSection(
              title: 'ព័ត៌មានផ្ទាល់ខ្លួន',
              children: [
                _ProfileOption(
                  icon: Icons.person_outline,
                  title: 'កែប្រែព័ត៌មានផ្ទាល់ខ្លួន',
                ),
                _ProfileOption(
                  icon: Icons.lock_outline,
                  title: 'ប្តូរលេខសម្ងាត់',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _ProfileSection(
              title: 'ការកំណត់',
              children: [
                _ProfileOption(
                  icon: Icons.notifications_outlined,
                  title: 'ការជូនដំណឹង',
                ),
                _ProfileOption(
                  icon: Icons.language,
                  title: 'ភាសា',
                ),
                _ProfileOption(
                  icon: Icons.dark_mode_outlined,
                  title: 'ពណ៌ផ្ទៃខាងក្រោយ',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _ProfileSection(
              title: 'ផ្សេងៗ',
              children: [
                _ProfileOption(
                  icon: Icons.help_outline,
                  title: 'ជំនួយ',
                ),
                _ProfileOption(
                  icon: Icons.info_outline,
                  title: 'អំពីកម្មវិធី',
                ),
                _ProfileOption(
                  icon: Icons.person_outline,
                  title: 'អំពីអ្នកបង្កើតកម្មវិធី',
                ),

              ],
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.all(16),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('ចាកចេញ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ProfileSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ProfileOption({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2E7D32)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        switch (title) {
          case 'កែប្រែព័ត៌មានផ្ទាល់ខ្លួន':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditProfileScreen(),
              ),
            );
            break;
          case 'ប្តូរលេខសម្ងាត់':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen(),
              ),
            );
            break;
          case 'ការជូនដំណឹង':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationSettingsScreen(),
              ),
            );
            break;
          case 'ភាសា':
            // TODO: Add language settings screen
            break;
          case 'ពណ៌ផ្ទៃខាងក្រោយ':
            // TODO: Add theme settings screen
            break;
          case 'ជំនួយ':
            // TODO: Add help screen
            break;
          case 'អំពីកម្មវិធី':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AboutUsScreen(),
              ),
            );
          case 'អំពីអ្នកបង្កើតកម្មវិធី':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AboutMeScreen(),
              ),
            );
            break;
        }
      },
    );
  }
}
