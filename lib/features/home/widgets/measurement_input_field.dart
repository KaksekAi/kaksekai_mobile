import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MeasurementInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String unit;
  final ValueChanged<String>? onChanged;

  const MeasurementInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.unit,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        suffixText: unit,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
