import 'package:flutter/material.dart';

class AnalysisTypeSelector extends StatelessWidget {
  final bool isMonthly;
  final Function(bool) onTypeChanged;

  const AnalysisTypeSelector({
    super.key,
    required this.isMonthly,
    required this.onTypeChanged,
  });

  Widget _buildAnalysisTypeButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF2E7D32),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF2E7D32),
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF2E7D32),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.analytics,
                  color: Color(0xFF2E7D32),
                ),
                const SizedBox(width: 8),
                Text(
                  "ជ្រើសរើសប្រភេទនៃការវិភាគ",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildAnalysisTypeButton(
                    icon: Icons.today,
                    label: 'ប្រចាំថ្ងៃ',
                    isSelected: !isMonthly,
                    onTap: () {
                      if (isMonthly) {
                        onTypeChanged(false);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAnalysisTypeButton(
                    icon: Icons.calendar_month,
                    label: 'ប្រចាំខែ',
                    isSelected: isMonthly,
                    onTap: () {
                      if (!isMonthly) {
                        onTypeChanged(true);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
