import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/planting_analysis.dart';

class PlantingAnalysisStorageService {
  static const String _storageKey = 'planting_analyses';

  Future<void> saveAnalysis(PlantingAnalysis analysis) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existingAnalyses =
        prefs.getStringList(_storageKey) ?? [];

    // Add new analysis
    existingAnalyses.add(jsonEncode(analysis.toJson()));

    // Save back to storage
    await prefs.setStringList(_storageKey, existingAnalyses);
  }

  Future<List<PlantingAnalysis>> getAllAnalyses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> analysesJson = prefs.getStringList(_storageKey) ?? [];

    return analysesJson.map((json) {
      final Map<String, dynamic> data = jsonDecode(json);
      return PlantingAnalysis.fromJson(data);
    }).toList();
  }

  Future<void> deleteAnalysis(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existingAnalyses =
        prefs.getStringList(_storageKey) ?? [];

    // Filter out the analysis with the given id
    final updatedAnalyses = existingAnalyses.where((json) {
      final Map<String, dynamic> data = jsonDecode(json);
      return data['id'] != id;
    }).toList();

    // Save back to storage
    await prefs.setStringList(_storageKey, updatedAnalyses);
  }

  Future<PlantingAnalysis?> getAnalysisById(String id) async {
    final analyses = await getAllAnalyses();
    try {
      return analyses.firstWhere((analysis) => analysis.id == id);
    } catch (e) {
      return null;
    }
  }
}
