import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/farm_info.dart';
import 'farm_text_field.dart';

class AddFarmDialog extends StatefulWidget {
  final Function(FarmInfo) onSave;

  const AddFarmDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<AddFarmDialog> createState() => _AddFarmDialogState();
}

class _AddFarmDialogState extends State<AddFarmDialog> {
  final cropTypeController = TextEditingController();
  final landSizeController = TextEditingController();
  final cropAgeController = TextEditingController();
  final locationController = TextEditingController();
  final situationController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void dispose() {
    cropTypeController.dispose();
    landSizeController.dispose();
    cropAgeController.dispose();
    locationController.dispose();
    situationController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (cropTypeController.text.isEmpty ||
        landSizeController.text.isEmpty ||
        cropAgeController.text.isEmpty ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('សូមបំពេញព័ត៌មានសំខាន់ៗទាំងអស់'),
          backgroundColor: Color(0xFF1B5E20),
        ),
      );
      return;
    }

    final newFarm = FarmInfo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cropType: cropTypeController.text,
      landSize: double.parse(landSizeController.text),
      cropAge: int.parse(cropAgeController.text),
      location: locationController.text,
      situation: situationController.text,
      notes: notesController.text,
    );

    widget.onSave(newFarm);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.agriculture,
                  color: Color(0xFF1B5E20),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'បន្ថែមដំណាំថ្មី',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF1B5E20),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FarmTextField(
                      controller: cropTypeController,
                      label: 'ប្រភេទដំណាំ',
                      icon: Icons.eco,
                      required: true,
                    ),
                    const SizedBox(height: 16),
                    FarmTextField(
                      controller: landSizeController,
                      label: 'ទំហំដី (ហិកតា)',
                      icon: Icons.landscape,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$')),
                      ],
                      required: true,
                    ),
                    const SizedBox(height: 16),
                    FarmTextField(
                      controller: cropAgeController,
                      label: 'អាយុដំណាំ (ថ្ងៃ)',
                      icon: Icons.timer,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      required: true,
                    ),
                    const SizedBox(height: 16),
                    FarmTextField(
                      controller: locationController,
                      label: 'ទីតាំង',
                      icon: Icons.location_on,
                      required: true,
                    ),
                    const SizedBox(height: 16),
                    FarmTextField(
                      controller: situationController,
                      label: 'ស្ថានភាព',
                      icon: Icons.info_outline,
                    ),
                    const SizedBox(height: 16),
                    FarmTextField(
                      controller: notesController,
                      label: 'ចំណាំ',
                      icon: Icons.note,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'បោះបង់',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('រក្សាទុក'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
