import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _weatherAlerts = true;
  bool _newsUpdates = true;
  bool _tips = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ការជូនដំណឹង', style: TextStyle(color: Colors.white)),
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
          children: [
            SwitchListTile(
              title: const Text('ការព្យាករណ៍អាកាសធាតុ'),
              subtitle: const Text('ទទួលបានការជូនដំណឹងអំពីអាកាសធាតុប្រចាំថ្ងៃ'),
              value: _weatherAlerts,
              onChanged: (bool value) {
                setState(() {
                  _weatherAlerts = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('ព័ត៌មានថ្មីៗ'),
              subtitle: const Text('ទទួលបានព័ត៌មានថ្មីៗអំពីកសិកម្ម'),
              value: _newsUpdates,
              onChanged: (bool value) {
                setState(() {
                  _newsUpdates = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('គន្លឹះកសិកម្ម'),
              subtitle: const Text('ទទួលបានគន្លឹះសំខាន់ៗសម្រាប់កសិកម្ម'),
              value: _tips,
              onChanged: (bool value) {
                setState(() {
                  _tips = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
