import 'package:flutter/material.dart';
import '../models/farm_info.dart';
import '../services/farm_service.dart';
import '../widgets/add_farm_dialog.dart';
import '../widgets/edit_farm_dialog.dart';
import '../widgets/farm_list_item.dart';

class FarmManagementScreen extends StatefulWidget {
  const FarmManagementScreen({super.key});

  @override
  State<FarmManagementScreen> createState() => _FarmManagementScreenState();
}

class _FarmManagementScreenState extends State<FarmManagementScreen> {
  final FarmService _farmService = FarmService();
  List<FarmInfo> _farms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFarms();
  }

  Future<void> _loadFarms() async {
    final farms = await _farmService.getFarmList();
    if (mounted) {
      setState(() {
        _farms = farms;
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddFarmDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AddFarmDialog(
        onSave: (farm) async {
          await _farmService.addFarm(farm);
          _loadFarms();
        },
      ),
    );
  }

  Future<void> _showEditFarmDialog(FarmInfo farm) async {
    await showDialog(
      context: context,
      builder: (context) => EditFarmDialog(
        farm: farm,
        onSave: (updatedFarm) async {
          await _farmService.updateFarm(updatedFarm);
          _loadFarms();
        },
      ),
    );
  }

  Future<void> _deleteFarm(String farmId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('បញ្ជាក់ការលុប'),
        content: const Text('តើអ្នកពិតជាចង់លុបដំណាំនេះមែនទេ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'បោះបង់',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('លុប'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _farmService.deleteFarm(farmId);
      _loadFarms();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('គ្រប់គ្រងដំណាំ'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_farms.isEmpty)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.agriculture,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'មិនទាន់មានដំណាំនៅឡើយទេ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _farms.length,
                        itemBuilder: (context, index) {
                          return FarmListItem(
                            farm: _farms[index],
                            onDelete: _deleteFarm,
                            onEdit: _showEditFarmDialog,
                          );
                        },
                      ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFarmDialog,
        backgroundColor: const Color(0xFF1B5E20),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
