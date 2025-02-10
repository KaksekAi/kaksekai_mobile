import 'package:flutter/material.dart';

class LocationInfoCard extends StatelessWidget {
  final String? currentAddress;
  final Color primaryColor;
  final VoidCallback onRefreshLocation;

  const LocationInfoCard({
    super.key,
    required this.currentAddress,
    required this.primaryColor,
    required this.onRefreshLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ទីតាំង',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(currentAddress ?? 'កំពុងស្វែងរកទីតាំង...'),
            TextButton(
              onPressed: onRefreshLocation,
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
              child: const Text('រកទីតាំងម្តងទៀត'),
            ),
          ],
        ),
      ),
    );
  }
}
