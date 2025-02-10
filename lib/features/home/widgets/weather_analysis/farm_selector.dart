import 'package:flutter/material.dart';
import '../../models/farm_info.dart';

class FarmSelector extends StatelessWidget {
  final List<FarmInfo> farms;
  final FarmInfo? selectedFarm;
  final Function(FarmInfo?) onFarmSelected;
  final bool isAnalyzing;
  final VoidCallback onAnalyze;
  final bool isMonthly;

  const FarmSelector({
    super.key,
    required this.farms,
    required this.selectedFarm,
    required this.onFarmSelected,
    required this.isAnalyzing,
    required this.onAnalyze,
    required this.isMonthly,
  });

  @override
  Widget build(BuildContext context) {
    if (farms.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(
                Icons.agriculture,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'មិនទាន់មានដំណាំនៅឡើយទេ',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'សូមបន្ថែមដំណាំរបស់អ្នកដើម្បីទទួលបានការវិភាគ',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/farm-management'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('បន្ថែមដំណាំ'),
              ),
            ],
          ),
        ),
      );
    }

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
                  Icons.eco,
                  color: Color(0xFF2E7D32),
                ),
                const SizedBox(width: 8),
                Text(
                  "ជ្រើសរើសដំណាំដើម្បីវិភាគ",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<FarmInfo>(
              value: selectedFarm,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                prefixIcon: const Icon(
                  Icons.agriculture,
                  color: Color(0xFF2E7D32),
                ),
              ),
              hint: const Text('ជ្រើសរើសដំណាំ'),
              items: farms.map((farm) {
                return DropdownMenuItem<FarmInfo>(
                  value: farm,
                  child: Text(farm.cropType),
                );
              }).toList(),
              onChanged: onFarmSelected,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    selectedFarm != null && !isAnalyzing ? onAnalyze : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: isAnalyzing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.analytics),
                label: Text(
                  isAnalyzing
                      ? 'កំពុងវិភាគ...'
                      : isMonthly
                          ? 'វិភាគអាកាសធាតុប្រចាំខែ'
                          : 'វិភាគអាកាសធាតុប្រចាំថ្ងៃ',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
