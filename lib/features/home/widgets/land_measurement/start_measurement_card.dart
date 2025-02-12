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

  String _getMethodTitle(MeasurementMethod method) {
    switch (method) {
      case MeasurementMethod.pointByPoint:
        return 'វាស់វែងតាមចំណុច';
      case MeasurementMethod.walkAround:
        return 'វាស់វែងតាមការដើរជុំវិញ';
      case MeasurementMethod.centerRadius:
        return 'វាស់វែងតាមកាំ';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LandMeasurementController>();

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Card(
            elevation: 8,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width > 600
                  ? 500
                  : double.infinity,
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
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B5E20).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.touch_app,
                        size: 48,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _getMethodTitle(controller.currentMethod),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getInstructionText(controller.currentMethod),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
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
                        icon: const Icon(Icons.edit, color: Colors.white,),
                        label: const Text(
                          'គូសផែនទី',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B5E20),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
