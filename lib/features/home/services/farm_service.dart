import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/farm_info.dart';

class FarmService {
  static const String _key = 'farm_info_list';

  Future<List<FarmInfo>> getFarmList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? farmListJson = prefs.getString(_key);
    if (farmListJson == null) return [];

    final List<dynamic> decoded = jsonDecode(farmListJson);
    return decoded.map((item) => FarmInfo.fromJson(item)).toList();
  }

  Future<void> addFarm(FarmInfo farm) async {
    final prefs = await SharedPreferences.getInstance();
    final List<FarmInfo> currentList = await getFarmList();
    currentList.add(farm);

    final String encoded =
        jsonEncode(currentList.map((f) => f.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  Future<void> updateFarm(FarmInfo updatedFarm) async {
    final prefs = await SharedPreferences.getInstance();
    final List<FarmInfo> currentList = await getFarmList();

    final index = currentList.indexWhere((farm) => farm.id == updatedFarm.id);
    if (index != -1) {
      currentList[index] = updatedFarm;
      final String encoded =
          jsonEncode(currentList.map((f) => f.toJson()).toList());
      await prefs.setString(_key, encoded);
    }
  }

  Future<void> deleteFarm(String farmId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<FarmInfo> currentList = await getFarmList();

    currentList.removeWhere((farm) => farm.id == farmId);
    final String encoded =
        jsonEncode(currentList.map((f) => f.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}
