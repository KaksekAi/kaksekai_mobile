import 'package:flutter/material.dart';
import '../../../../utils/khmer_date_formatter.dart';

class CropInfoForm extends StatelessWidget {
  final TextEditingController plantController;
  final TextEditingController seedTypeController;
  final TextEditingController landSizeController;
  final TextEditingController landTypeController;
  final FocusNode plantFocus;
  final FocusNode seedTypeFocus;
  final FocusNode landSizeFocus;
  final FocusNode landTypeFocus;
  final Color primaryColor;
  final DateTimeRange? selectedDateRange;
  final Function(DateTimeRange) onDateRangeSelected;

  const CropInfoForm({
    super.key,
    required this.plantController,
    required this.seedTypeController,
    required this.landSizeController,
    required this.landTypeController,
    required this.plantFocus,
    required this.seedTypeFocus,
    required this.landSizeFocus,
    required this.landTypeFocus,
    required this.primaryColor,
    required this.selectedDateRange,
    required this.onDateRangeSelected,
  });

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
      helpText: 'ជ្រើសរើសកាលបរិច្ឆេទដាំដុះ',
      cancelText: 'បោះបង់',
      confirmText: 'យល់ព្រម',
      saveText: 'យល់ព្រម',
      errorFormatText: 'ទម្រង់កាលបរិច្ឆេទមិនត្រឹមត្រូវ',
      errorInvalidText: 'កាលបរិច្ឆេទមិនត្រឹមត្រូវ',
      errorInvalidRangeText: 'ចន្លោះកាលបរិច្ឆេទមិនត្រឹមត្រូវ',
      fieldStartHintText: 'កាលបរិច្ឆេទចាប់ផ្តើម',
      fieldEndHintText: 'កាលបរិច្ឆេទបញ្ចប់',
      fieldStartLabelText: 'កាលបរិច្ឆេទចាប់ផ្តើម',
      fieldEndLabelText: 'កាលបរិច្ឆេទបញ្ចប់',
    );

    if (picked != null) {
      onDateRangeSelected(picked);
    }
  }

  String _formatDateRange() {
    if (selectedDateRange == null) {
      return 'ជ្រើសរើសកាលបរិច្ឆេទដាំដុះ';
    }

    return KhmerDateFormatter.formatDateRange(
      selectedDateRange!.start,
      selectedDateRange!.end,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.green.shade50,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.grass,
                  color: primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'ព័ត៌មានដំណាំ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: plantController,
              focusNode: plantFocus,
              label: 'ដំណាំ',
              icon: Icons.local_florist,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: seedTypeController,
              focusNode: seedTypeFocus,
              label: 'ប្រភេទពូជ',
              icon: Icons.spa,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: landSizeController,
              focusNode: landSizeFocus,
              label: 'ទំហំដី (ហិកតា)',
              icon: Icons.straighten,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: landTypeController,
              focusNode: landTypeFocus,
              label: 'ប្រភេទដី',
              icon: Icons.landscape,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDateRange(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.date_range, color: primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _formatDateRange(),
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedDateRange == null
                              ? Colors.black54
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: primaryColor),
        prefixIcon: Icon(icon, color: primaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'សូមបញ្ចូល$label';
        }
        if (keyboardType == TextInputType.number &&
            double.tryParse(value) == null) {
          return 'សូមបញ្ចូលលេខត្រឹមត្រូវ';
        }
        return null;
      },
    );
  }
}
