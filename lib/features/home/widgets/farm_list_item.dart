import 'package:flutter/material.dart';
import '../models/farm_info.dart';

class FarmListItem extends StatelessWidget {
  final FarmInfo farm;
  final Function(String) onDelete;
  final Function(FarmInfo) onEdit;

  const FarmListItem({
    super.key,
    required this.farm,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF1B5E20),
          child: Icon(Icons.eco, color: Colors.white),
        ),
        title: Text(
          farm.cropType,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.landscape, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('ទំហំដី: ${farm.landSize} ហិកតា'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.timer, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('អាយុដំណាំ: ${farm.cropAge} ថ្ងៃ'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(child: Text('ទីតាំង: ${farm.location}')),
              ],
            ),
            if (farm.situation != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(child: Text('ស្ថានភាព: ${farm.situation}')),
                ],
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF1B5E20)),
              onPressed: () => onEdit(farm),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDelete(farm.id),
            ),
          ],
        ),
      ),
    );
  }
}
