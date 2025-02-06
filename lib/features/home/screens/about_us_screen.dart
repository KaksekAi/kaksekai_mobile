import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('អំពីកម្មវិធី', style: TextStyle(color: Colors.white)),
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
            const Icon(
              Icons.eco,
              size: 80,
              color: Color(0xFF2E7D32),
            ),
            const SizedBox(height: 24),
            const Text(
              'កសិកម្ម',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'កំណែ ១.០.០',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildSection(
              'អំពីកម្មវិធី',
              'កម្មវិធីកសិកម្មគឺជាកម្មវិធីដែលជួយសម្រួលដល់ការងាររបស់កសិករ។ '
                  'កម្មវិធីនេះមានមុខងារជាច្រើនដូចជា៖',
            ),
            const SizedBox(height: 16),
            _buildFeatureList([
              'វាស់វែងផ្ទៃដី',
              'ពិនិត្យស្ថានភាពអាកាសធាតុ',
              'ជំនួយការ AI សម្រាប់កសិកម្ម',
              'វេទិកាសួរ-ឆ្លើយ',
            ]),
            const SizedBox(height: 32),
            _buildSection(
              'គោលបំណង',
              'យើងមានគោលបំណងជួយកសិករក្នុងការ៖\n'
                  '• បង្កើនផលិតភាពកសិកម្ម\n'
                  '• កាត់បន្ថយការចំណាយ\n'
                  '• ធ្វើឱ្យប្រសើរឡើងនូវគុណភាពផលិតផល\n'
                  '• ជួយក្នុងការសម្រេចចិត្ត',
            ),
            const SizedBox(height: 32),
            _buildSection(
              'ទំនាក់ទំនង',
              'អ៊ីមែល៖ support@kaksekai.com\n'
                  'ទូរស័ព្ទ៖ 023 XXX XXX\n'
                  'អាសយដ្ឋាន៖ ភ្នំពេញ, កម្ពុជា',
            ),
            const SizedBox(height: 32),
            const Text(
              '© ២០២៤ កសិកម្ម។ រក្សាសិទ្ធិគ្រប់យ៉ាង។',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureList(List<String> features) {
    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF2E7D32),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                feature,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
  
}
