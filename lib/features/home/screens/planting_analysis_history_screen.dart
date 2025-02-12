import 'package:flutter/material.dart';
import '../models/planting_analysis.dart';
import '../services/planting_analysis_storage_service.dart';
import '../../../utils/khmer_date_formatter.dart';
import 'planting_analysis_result_screen.dart';

class PlantingAnalysisHistoryScreen extends StatelessWidget {
  final Color _primaryColor = const Color(0xFF1B5E20);
  final Color _secondaryColor = const Color(0xFF2E7D32);
  final PlantingAnalysisStorageService _storageService =
      PlantingAnalysisStorageService();

  PlantingAnalysisHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'ប្រវត្តិនៃការវិភាគ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _primaryColor,
                _secondaryColor,
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: FutureBuilder<List<PlantingAnalysis>>(
          future: _storageService.getAllAnalyses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'មានបញ្ហាក្នុងការទាញយកទិន្នន័យ',
                  style: TextStyle(color: Colors.red.shade700),
                ),
              );
            }

            final analyses = snapshot.data ?? [];

            if (analyses.isEmpty) {
              return const Center(
                child: Text(
                  'មិនមានប្រវត្តិនៃការវិភាគនៅឡើយទេ',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
              itemCount: analyses.length,
              itemBuilder: (context, index) {
                final analysis = analyses[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlantingAnalysisResultScreen(
                            analysisResult: analysis.result,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.grass, color: _primaryColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  analysis.cropType,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ប្រភេទពូជ: ${analysis.seedType}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ទំហំដី: ${analysis.landSize} ហិកតា',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'កាលបរិច្ឆេទដាំដុះ: ${KhmerDateFormatter.formatDateRange(
                              analysis.plantingDateRange.start,
                              analysis.plantingDateRange.end,
                            )}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'កាលបរិច្ឆេទវិភាគ: ${KhmerDateFormatter.formatDate(analysis.analysisDate)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
