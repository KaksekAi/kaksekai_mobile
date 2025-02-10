import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/land_measurement_controller.dart';
import '../../models/land_measurement.dart';

class StartMeasurementCard extends StatelessWidget {
  const StartMeasurementCard({super.key});

  String _getInstructionText(MeasurementMethod method) {
    switch (method) {
      case MeasurementMethod.pointByPoint:
        return 'ចុចប៊ូតុង "គូសផែនទី" ដើម្បីចាប់ផ្តើមកំណត់ចំណុច';
      case MeasurementMethod.walkAround:
        return 'ចុចប៊ូតុង "គូសផែនទី" ដើម្បីចាប់ផ្តើមដើរជុំវិញដី';
      case MeasurementMethod.centerRadius:
        return 'ចុចប៊ូតុង "គូសផែនទី" ដើម្បីចាប់ផ្តើមកំណត់ចំណុចកណ្តាល';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LandMeasurementController>();

    return Center(
      child: Card(
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.touch_app,
                size: 48,
                color: Color(0xFF1B5E20),
              ),
              const SizedBox(height: 16),
              Text(
                _getInstructionText(controller.currentMethod),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  controller.toggleDrawing();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        controller.currentMethod ==
                                MeasurementMethod.centerRadius
                            ? 'ចុចលើផែនទីដើម្បីកំណត់ចំណុចកណ្តាល'
                            : controller.currentMethod ==
                                    MeasurementMethod.walkAround
                                ? 'ចាប់ផ្តើមដើរជុំវិញដី'
                                : 'ចុចលើផែនទីដើម្បីកំណត់ចំណុច',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('គូសផែនទី'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
