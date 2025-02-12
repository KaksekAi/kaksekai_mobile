import 'package:flutter/material.dart';

class PlantingInstructionsDialog extends StatelessWidget {
  final Color primaryColor;

  const PlantingInstructionsDialog({
    super.key,
    required this.primaryColor,
  });

  Widget _buildInstructionStep(int step, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Icon(
            Icons.tips_and_updates,
            color: primaryColor,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            'ការណែនាំ',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInstructionStep(1, 'បញ្ចូលព័ត៌មានដំណាំ និងដីរបស់អ្នក'),
            _buildInstructionStep(2, 'ថតរូប ឬជ្រើសរើសរូបភាពដីរបស់អ្នក'),
            _buildInstructionStep(3, 'ផ្ទៀងផ្ទាត់ទីតាំងរបស់អ្នក'),
            _buildInstructionStep(4, 'ជ្រើសរើសកាលបរិច្ឆេទដាំដុះ'),
            _buildInstructionStep(5, 'ចុចប៊ូតុង "វិភាគលក្ខខណ្ឌដាំដុះ"'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
            'យល់ព្រម',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
