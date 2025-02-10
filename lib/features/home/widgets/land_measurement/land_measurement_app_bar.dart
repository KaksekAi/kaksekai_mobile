import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/land_measurement_controller.dart';

class LandMeasurementAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final LandMeasurementController controller;
  final VoidCallback onBackPressed;

  const LandMeasurementAppBar({
    super.key,
    required this.controller,
    required this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'វាស់វែងដី',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 24,
          letterSpacing: 0.5,
        ),
      ),
      backgroundColor: const Color(0xFF1B5E20).withOpacity(0.95),
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onBackPressed,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              controller.isSatelliteView ? Icons.map : Icons.satellite_alt,
              color: Colors.white,
            ),
            onPressed: controller.toggleMapType,
            tooltip: controller.isSatelliteView
                ? 'បង្ហាញផែនទីធម្មតា'
                : 'បង្ហាញរូបភាពផ្កាយរណប',
          ),
        ),
        if (controller.points.isNotEmpty)
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                controller.reset();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('បានជម្រះទិន្នន័យ'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Color(0xFF1B5E20),
                  ),
                );
              },
              tooltip: 'ចាប់ផ្តើមម្តងទៀត',
            ),
          ),
      ],
    );
  }
}
