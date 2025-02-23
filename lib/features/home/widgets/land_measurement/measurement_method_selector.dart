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
    return Column(
      children: [
        _buildMethodCard(
          context,
          method: MeasurementMethod.walkAround,
          icon: Icons.directions_walk,
          title: 'ដើរវាស់វែង',
          subtitle: 'ដើរជុំវិញព្រំដីដើម្បីវាស់វែង',
          description: 'ដើរជុំវិញព្រំដីដោយប្រើប្រាស់ GPS ដើម្បីកំណត់ព្រំដី',
        ),
        const SizedBox(height: 12),
        _buildMethodCard(
          context,
          method: MeasurementMethod.pointByPoint,
          icon: Icons.touch_app,
          title: 'ចុចវាស់វែង',
          subtitle: 'ចុចលើផែនទីដើម្បីកំណត់ព្រំដី',
          description: 'ចុចលើផែនទីដើម្បីកំណត់ចំណុចនីមួយៗនៃព្រំដី',
        ),
        const SizedBox(height: 12),
        _buildMethodCard(
          context,
          method: MeasurementMethod.centerRadius,
          icon: Icons.radio_button_checked,
          title: 'រង្វង់វាស់វែង',
          subtitle: 'កំណត់ចំណុចកណ្តាលនិងកាំ',
          description: 'ប្រើប្រាស់សម្រាប់ដីរាងរង្វង់ឬរាងស្រដៀងរង្វង់',
        ),
      ],
    );
  }

  Widget _buildMethodCard(
    BuildContext context, {
    required MeasurementMethod method,
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
  }) {
    final isSelected = currentMethod == method;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onMethodChanged(method),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF1B5E20).withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  isSelected ? const Color(0xFF1B5E20) : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1B5E20)
                      : const Color(0xFF1B5E20).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : const Color(0xFF1B5E20),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? const Color(0xFF1B5E20)
                                : Colors.black87,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B5E20),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'បានជ្រើសរើស',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected
                            ? const Color(0xFF1B5E20)
                            : Colors.grey.shade600,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1B5E20)
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Center(
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: Color(0xFF1B5E20),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
