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
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: const Color(0xFF1B5E20).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(
                Icons.agriculture,
                size: 64,
                color: const Color(0xFF1B5E20).withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'មិនទាន់មានដំណាំនៅឡើយទេ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF1B5E20),
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'សូមបន្ថែមដំណាំរបស់អ្នកដើម្បីទទួលបានការវិភាគ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF1B5E20).withOpacity(0.8),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/farm-management'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'បន្ថែមដំណាំ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: const Color(0xFF1B5E20).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.eco_outlined,
                  color: const Color(0xFF1B5E20),
                ),
                const SizedBox(width: 8),
                Text(
                  "ជ្រើសរើសដំណាំដើម្បីវិភាគ",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF1B5E20),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF1B5E20).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: DropdownButtonFormField<FarmInfo>(
                value: selectedFarm,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.agriculture,
                    color: const Color(0xFF1B5E20),
                  ),
                ),
                hint: Text(
                  'ជ្រើសរើសដំណាំ',
                  style: TextStyle(
                    color: const Color(0xFF1B5E20).withOpacity(0.8),
                  ),
                ),
                items: farms.map((farm) {
                  return DropdownMenuItem<FarmInfo>(
                    value: farm,
                    child: Text(
                      farm.cropType,
                      style: const TextStyle(
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onFarmSelected,
                dropdownColor: Colors.white,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: const Color(0xFF1B5E20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    selectedFarm != null && !isAnalyzing ? onAnalyze : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  disabledBackgroundColor:
                      const Color(0xFF1B5E20).withOpacity(0.3),
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
                    : const Icon(Icons.analytics_outlined, color: Colors.white),
                label: Text(
                  isAnalyzing
                      ? 'កំពុងវិភាគ...'
                      : isMonthly
                          ? 'វិភាគអាកាសធាតុប្រចាំខែ'
                          : 'វិភាគអាកាសធាតុប្រចាំថ្ងៃ',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
