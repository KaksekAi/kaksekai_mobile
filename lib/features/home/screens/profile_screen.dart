import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../features/auth/services/auth_service.dart';
import '../../../features/home/screens/edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'notification_settings_screen.dart';
import 'about_us_screen.dart';
import 'about_me_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await _authService.getUserData();
      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'គណនី',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF2E7D32),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            tooltip: 'ត្រឡប់ក្រោយ',
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/bg.png'),
                    fit: BoxFit.cover,
                    opacity: 0.1,
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  children: [
                    // Profile Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Hero(
                            tag: 'profile_avatar',
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('កំពុងរៀបចំមុខងារនេះ...'),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Color(0xFF2E7D32),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(60),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF2E7D32),
                                      width: 2,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundColor:
                                            const Color(0xFF2E7D32),
                                        backgroundImage:
                                            userData?['photoURL'] != null
                                                ? NetworkImage(
                                                    userData!['photoURL'])
                                                : null,
                                        child: userData?['photoURL'] == null
                                            ? const Icon(
                                                Icons.person,
                                                size: 50,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF2E7D32),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            userData?['fullName'] ?? 'ឈ្មោះ​អ្នកប្រើប្រាស់',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userData?['email'] ?? 'email@example.com',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Profile Options
                    _ProfileSection(
                      title: 'ព័ត៌មានផ្ទាល់ខ្លួន',
                      icon: Icons.person_outline,
                      children: [
                        _ProfileOption(
                          icon: Icons.person_outline,
                          title: 'កែប្រែព័ត៌មានផ្ទាល់ខ្លួន',
                          subtitle: 'កែប្រែឈ្មោះ និងព័ត៌មានផ្សេងៗ',
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfileScreen(userData: userData),
                              ),
                            );
                            if (result == true) {
                              _loadUserData();
                            }
                          },
                        ),
                        _ProfileOption(
                          icon: Icons.lock_outline,
                          title: 'ប្តូរលេខសម្ងាត់',
                          subtitle: 'កែប្រែលេខសម្ងាត់របស់អ្នក',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ChangePasswordScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _ProfileSection(
                      title: 'ការកំណត់',
                      icon: Icons.settings_outlined,
                      children: [
                        _ProfileOption(
                          icon: Icons.notifications_outlined,
                          title: 'ការជូនដំណឹង',
                          subtitle: 'គ្រប់គ្រងការជូនដំណឹង',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationSettingsScreen(),
                            ),
                          ),
                        ),
                        _ProfileOption(
                          icon: Icons.language,
                          title: 'ភាសា',
                          subtitle: 'ជ្រើសរើសភាសា',
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'ខ្មែរ',
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('កំពុងរៀបចំមុខងារនេះ...'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Color(0xFF2E7D32),
                              ),
                            );
                          },
                        ),
                        _ProfileOption(
                          icon: Icons.dark_mode_outlined,
                          title: 'ពណ៌ផ្ទៃខាងក្រោយ',
                          subtitle: 'ជ្រើសរើសពណ៌ផ្ទៃខាងក្រោយ',
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'ភ្លឺ',
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('កំពុងរៀបចំមុខងារនេះ...'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Color(0xFF2E7D32),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _ProfileSection(
                      title: 'ផ្សេងៗ',
                      icon: Icons.info_outline,
                      children: [
                        _ProfileOption(
                          icon: Icons.help_outline,
                          title: 'ជំនួយ',
                          subtitle: 'មើលព័ត៌មានជំនួយ',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('កំពុងរៀបចំមុខងារនេះ...'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Color(0xFF2E7D32),
                              ),
                            );
                          },
                        ),
                        _ProfileOption(
                          icon: Icons.info_outline,
                          title: 'អំពីកម្មវិធី',
                          subtitle: 'ព័ត៌មានលម្អិតអំពីកម្មវិធី',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutUsScreen(),
                            ),
                          ),
                        ),
                        _ProfileOption(
                          icon: Icons.person_outline,
                          title: 'អំពីអ្នកបង្កើតកម្មវិធី',
                          subtitle: 'ព័ត៌មានលម្អិតអំពីអ្នកបង្កើតកម្មវិធី',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutMeScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: Colors.red[700],
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('ចាកចេញ?'),
                                ],
                              ),
                              content: const Text(
                                  'តើអ្នកពិតជាចង់ចាកចេញពីគណនីមែនទេ?'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'ទេ',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _handleSignOut();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('បាទ/ចាស'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.all(16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          'ចាកចេញ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _ProfileSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF2E7D32)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
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
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap?.call();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: Icon(icon, color: const Color(0xFF2E7D32)),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            trailing:
                trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
