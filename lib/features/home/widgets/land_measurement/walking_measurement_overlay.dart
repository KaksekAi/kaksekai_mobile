import 'package:flutter/material.dart';
import '../../controllers/land_measurement_controller.dart';

class WalkingMeasurementOverlay extends StatelessWidget {
  final LandMeasurementController controller;

  const WalkingMeasurementOverlay({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildCalibrationStatus(),
            _buildStats(),
            if (controller.isNearStart && controller.points.length >= 8)
              _buildNearStartWarning(),
            _buildSpeedGuidance(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF1B5E20),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.directions_walk,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'កំពុងដើរវាស់វែង',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ដើរជុំវិញព្រំដីដើម្បីកំណត់ផ្ទៃក្រឡា',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalibrationStatus() {
    final accuracy = controller.gpsAccuracy;
    final hasGoodSignal = controller.hasGoodGpsSignal;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Icon(
            hasGoodSignal ? Icons.gps_fixed : Icons.gps_not_fixed,
            size: 20,
            color: hasGoodSignal ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      hasGoodSignal ? 'GPS ល្អ' : 'កំពុងរង់ចាំ GPS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: hasGoodSignal ? Colors.green : Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (accuracy > 0)
                      Text(
                        '(±${accuracy.toStringAsFixed(1)}m)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value:
                      accuracy > 0 ? (1 - accuracy / 20).clamp(0.0, 1.0) : 0.0,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(
                    hasGoodSignal ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              _buildStatItem(
                icon: Icons.timer,
                value:
                    '${controller.elapsedTime.inMinutes}:${(controller.elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
                label: 'រយៈពេល',
                isHighlighted: controller.isNearStart,
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.grey[200],
              ),
              _buildStatItem(
                icon: Icons.straighten,
                value: '${controller.totalDistance.toStringAsFixed(1)}m',
                label: 'ចម្ងាយសរុប',
                isHighlighted: controller.isNearStart,
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.grey[200],
              ),
              _buildStatItem(
                icon: Icons.location_on,
                value:
                    '${controller.distanceToStart?.toStringAsFixed(1) ?? '-'}m',
                label: 'ទៅចំណុចចាប់ផ្តើម',
                isHighlighted: controller.isNearStart,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E20).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.place,
                      size: 16,
                      color: Color(0xFF1B5E20),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'ចំណុចសរុប: ${controller.points.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1B5E20),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required bool isHighlighted,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isHighlighted
                  ? Colors.orange.withOpacity(0.1)
                  : const Color(0xFF1B5E20).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isHighlighted ? Colors.orange : const Color(0xFF1B5E20),
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? Colors.orange : const Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNearStartWarning() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline,
              color: Colors.orange.shade900,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'អ្នកជិតដល់ចំណុចចាប់ផ្តើមហើយ!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ចុច "បញ្ចប់" ដើម្បីបញ្ចប់ការវាស់វែង',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedGuidance() {
    // Calculate walking speed in m/s
    final speed = controller.points.length >= 2
        ? controller.totalDistance / controller.elapsedTime.inSeconds
        : 0.0;

    String speedStatus;
    Color statusColor;
    String guidance;

    if (speed == 0) {
      speedStatus = 'រង់ចាំការចាប់ផ្តើម';
      statusColor = Colors.grey;
      guidance = 'ចាប់ផ្តើមដើរដោយល្បឿនមធ្យម';
    } else if (speed < 0.5) {
      speedStatus = 'ល្បឿនយឺត';
      statusColor = Colors.orange;
      guidance = 'សូមដើរលឿនបន្តិច';
    } else if (speed > 2.0) {
      speedStatus = 'ល្បឿនលឿន';
      statusColor = Colors.orange;
      guidance = 'សូមដើរយឺតបន្តិច';
    } else {
      speedStatus = 'ល្បឿនល្អ';
      statusColor = Colors.green;
      guidance = 'បន្តដើរល្បឿននេះ';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.speed,
            color: statusColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  speedStatus,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  guidance,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
