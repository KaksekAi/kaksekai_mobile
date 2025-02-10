import 'package:flutter/material.dart';

class AnalysisCard extends StatelessWidget {
  final String analysis;

  const AnalysisCard({
    super.key,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    final sections = _parseAnalysisSections(analysis);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.analytics,
                  color: Color(0xFF2E7D32),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  "ការវិភាគ និងអនុសាសន៍",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Analysis Section
                if (sections['basic'] != null) ...[
                  _buildBasicAnalysis(context, sections['basic']!),
                  const Divider(height: 32),
                ],
                // AI Recommendations Sections
                if (sections['recommendations'] != null)
                  _buildAIRecommendations(
                      context, sections['recommendations']!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicAnalysis(BuildContext context, String basicAnalysis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.wb_sunny,
              color: Color(0xFF2E7D32),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'ការវិភាគបឋម',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          basicAnalysis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
                letterSpacing: 0.3,
              ),
        ),
      ],
    );
  }

  Widget _buildAIRecommendations(BuildContext context, String recommendations) {
    final sections = _parseRecommendationSections(recommendations);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.psychology,
              color: Color(0xFF2E7D32),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'អនុសាសន៍លម្អិត',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...sections.entries.map((entry) {
          return _buildSection(
            context,
            entry.key,
            entry.value,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    Map<String, List<String>> subsections,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 12),
        ...subsections.entries.map((subsection) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subsection.key,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                ),
                const SizedBox(height: 8),
                ...subsection.value.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '•',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  height: 1.5,
                                  letterSpacing: 0.3,
                                  color: Colors.grey[800],
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 16),
      ],
    );
  }

  Map<String, String> _parseAnalysisSections(String analysis) {
    final parts = analysis.split('\n\n');
    if (parts.length == 1) {
      return {'basic': parts[0]};
    }

    return {
      'basic': parts[0],
      'recommendations': parts.sublist(1).join('\n\n'),
    };
  }

  Map<String, Map<String, List<String>>> _parseRecommendationSections(
    String recommendations,
  ) {
    final result = <String, Map<String, List<String>>>{};
    var currentMainSection = '';
    var currentSubSection = '';
    var currentItems = <String>[];

    for (final line in recommendations.split('\n')) {
      if (line.trim().isEmpty) continue;

      if (line.startsWith('១.') ||
          line.startsWith('២.') ||
          line.startsWith('៣.') ||
          line.startsWith('៤.')) {
        if (currentMainSection.isNotEmpty && currentSubSection.isNotEmpty) {
          result[currentMainSection]![currentSubSection] =
              List.from(currentItems);
        }
        currentMainSection = line.split('៖')[0].trim();
        result[currentMainSection] = {};
        currentSubSection = '';
        currentItems = [];
      } else if (line.contains('ក.') ||
          line.contains('ខ.') ||
          line.contains('គ.')) {
        if (currentSubSection.isNotEmpty) {
          result[currentMainSection]![currentSubSection] =
              List.from(currentItems);
        }
        currentSubSection = line.split('៖')[0].trim();
        currentItems = [];
      } else if (line.trim().startsWith('-')) {
        currentItems.add(line.trim().substring(1).trim());
      }
    }

    if (currentMainSection.isNotEmpty && currentSubSection.isNotEmpty) {
      result[currentMainSection]![currentSubSection] = currentItems;
    }

    return result;
  }
}
