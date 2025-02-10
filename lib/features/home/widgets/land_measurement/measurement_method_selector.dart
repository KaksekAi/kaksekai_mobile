import 'package:flutter/material.dart';
import '../../models/land_measurement.dart';

class MeasurementMethodSelector extends StatelessWidget {
  final MeasurementMethod currentMethod;
  final Function(MeasurementMethod) onMethodChanged;

  const MeasurementMethodSelector({
    super.key,
    required this.currentMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B5E20).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.straighten,
                      color: Color(0xFF1B5E20),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'ជ្រើសរើសវិធីសាស្ត្រវាស់វែង',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 12,
                    children: [
                      _buildMethodOption(
                        context,
                        MeasurementMethod.pointByPoint,
                        'ចុចចំណុច',
                        Icons.touch_app,
                        'ចុចចំណុចម្តងមួយៗដើម្បីកំណត់ព្រំដី',
                        'ល្អសម្រាប់ដីមានរាងមិនទៀងទាត់',
                      ),
                      _buildMethodOption(
                        context,
                        MeasurementMethod.walkAround,
                        'ដើរជុំវិញ',
                        Icons.directions_walk,
                        'ដើរជុំវិញដីដោយកាន់ទូរស័ព្ទ',
                        'ល្អសម្រាប់ដីធំៗ',
                      ),
                      _buildMethodOption(
                        context,
                        MeasurementMethod.centerRadius,
                        'រង្វង់មូល',
                        Icons.radio_button_unchecked,
                        'វាស់ដីរាងមូលដោយប្រើចំណុចកណ្តាល',
                        'ល្អសម្រាប់ដីរាងមូល',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildMethodInstructions(currentMethod),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodOption(
    BuildContext context,
    MeasurementMethod method,
    String title,
    IconData icon,
    String description,
    String recommendation,
  ) {
    final isSelected = currentMethod == method;

    return GestureDetector(
      onTap: () => onMethodChanged(method),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B5E20) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1B5E20) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF1B5E20).withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFF1B5E20).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? Colors.white : const Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white70 : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFF1B5E20).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                recommendation,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.white : const Color(0xFF1B5E20),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodInstructions(MeasurementMethod method) {
    String title;
    List<String> steps;

    switch (method) {
      case MeasurementMethod.pointByPoint:
        title = 'របៀបវាស់តាមចំណុច';
        steps = [
          'ចុចប៊ូតុង "ចាប់ផ្តើម" ដើម្បីចាប់ផ្តើមវាស់',
          'ចុចលើផែនទីដើម្បីកំណត់ចំណុចនីមួយៗនៃព្រំដី',
          'ចុចប៊ូតុង "ត្រឡប់ក្រោយ" ដើម្បីលុបចំណុចចុងក្រោយ',
          'ចុចប៊ូតុង "បញ្ចប់" នៅពេលកំណត់ចំណុចគ្រប់គ្រាន់',
        ];
        break;
      case MeasurementMethod.walkAround:
        title = 'របៀបវាស់តាមការដើរ';
        steps = [
          'ឈរនៅចំណុចចាប់ផ្តើមនៃព្រំដី',
          'ចុចប៊ូតុង "ចាប់ផ្តើម" ដើម្បីចាប់ផ្តើមវាស់',
          'ដើរតាមព្រំដីដោយកាន់ទូរស័ព្ទ',
          'ចុចប៊ូតុង "បញ្ចប់" នៅពេលដើរមកដល់ចំណុចចាប់ផ្តើមវិញ',
        ];
        break;
      case MeasurementMethod.centerRadius:
        title = 'របៀបវាស់តាមរង្វង់';
        steps = [
          'ចុចប៊ូតុង "ចាប់ផ្តើម" ដើម្បីចាប់ផ្តើមវាស់',
          'ចុចលើផែនទីដើម្បីកំណត់ចំណុចកណ្តាល',
          'ចុចម្តងទៀតដើម្បីកំណត់កាំ',
          'ចុចប៊ូតុង "បញ្ចប់" ដើម្បីបញ្ចប់ការវាស់',
        ];
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1B5E20).withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.help_outline,
                size: 16,
                color: Color(0xFF1B5E20),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...steps.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B5E20),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
