import 'package:flutter/material.dart';
import '../../controllers/land_measurement_controller.dart';

class MapControls extends StatelessWidget {
  final LandMeasurementController controller;

  const MapControls({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!controller.isLoading && controller.points.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: FloatingActionButton.small(
              heroTag: 'undo',
              backgroundColor: Colors.orange.shade800,
              onPressed: () {
                controller.undoLastPoint();
                if (controller.points.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('បានលុបចំណុចទាំងអស់'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Color(0xFF1B5E20),
                    ),
                  );
                }
              },
              tooltip: 'ត្រឡប់ក្រោយ',
              elevation: 4,
              child: const Icon(Icons.undo, color: Colors.white),
            ),
          ),
        if (!controller.isLoading)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              heroTag: 'draw',
              backgroundColor: const Color(0xFF1B5E20),
              onPressed: () {
                controller.toggleDrawing();
                if (controller.isDrawing) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ចុចលើផែនទីដើម្បីកំណត់ចំណុច'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Color(0xFF1B5E20),
                    ),
                  );
                }
              },
              elevation: 4,
              highlightElevation: 8,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  controller.isDrawing ? Icons.check : Icons.touch_app,
                  key: ValueKey(controller.isDrawing),
                  color: Colors.white,
                ),
              ),
              label: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  controller.isDrawing ? 'បញ្ចប់' : 'ចាប់ផ្តើម',
                  key: ValueKey(controller.isDrawing),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
