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
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: const Color(0xFF1B5E20).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1B5E20),
                  const Color(0xFF2E7D32),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.analytics_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "ការវិភាគ និងអនុសាសន៍",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
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
                if (sections['basic'] != null) ...[
                  _buildBasicAnalysis(context, sections['basic']!),
                  const Divider(height: 32, thickness: 1),
                ],
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1B5E20).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wb_sunny_outlined,
                color: const Color(0xFF1B5E20),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'ការវិភាគបឋម',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: const Color(0xFF1B5E20),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          basicAnalysis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.6,
                letterSpacing: 0.3,
                color: Colors.grey[800],
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1B5E20).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.psychology_outlined,
                color: const Color(0xFF1B5E20),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'អនុសាសន៍លម្អិត',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: const Color(0xFF1B5E20),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...sections.entries.map((entry) {
          return _buildSection(context, entry.key, entry.value);
        }).toList(),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    Map<String, List<String>> subsections,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1B5E20).withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20).withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B5E20),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: subsections.entries.map((subsection) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B5E20).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          subsection.key,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1B5E20),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...subsection.value.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            bottom: 8,
                            right: 8,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1B5E20),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 12),
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
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> _parseAnalysisSections(String analysis) {
    if (analysis.trim().isEmpty) {
      return {'basic': 'មិនមានការវិភាគ'};
    }

    final parts = analysis.split('\n\n');
    if (parts.isEmpty) {
      return {'basic': analysis};
    }

    // Find where the recommendations start (usually after basic analysis)
    int recommendationsStart = -1;
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].trim().contains('១.')) {
        recommendationsStart = i;
        break;
      }
    }

    if (recommendationsStart == -1) {
      return {'basic': analysis};
    }

    return {
      'basic': parts.sublist(0, recommendationsStart).join('\n\n'),
      'recommendations': parts.sublist(recommendationsStart).join('\n\n'),
    };
  }

  Map<String, Map<String, List<String>>> _parseRecommendationSections(
    String recommendations,
  ) {
    final result = <String, Map<String, List<String>>>{};
    var currentMainSection = '';
    var currentSubSection = '';
    var currentItems = <String>[];

    // If recommendations is empty, return empty result
    if (recommendations.trim().isEmpty) {
      return result;
    }

    for (final line in recommendations.split('\n')) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      // Check for main section (១., ២., ៣., ៤.)
      if (trimmedLine.contains('១.') ||
          trimmedLine.contains('២.') ||
          trimmedLine.contains('៣.') ||
          trimmedLine.contains('៤.')) {
        // Save previous subsection if exists
        if (currentMainSection.isNotEmpty && currentSubSection.isNotEmpty) {
          if (!result.containsKey(currentMainSection)) {
            result[currentMainSection] = {};
          }
          result[currentMainSection]![currentSubSection] =
              List.from(currentItems);
        }

        // Start new main section
        currentMainSection = trimmedLine;
        result[currentMainSection] = {};
        currentSubSection = '';
        currentItems = [];
      }
      // Check for subsection (ក., ខ., គ.)
      else if (trimmedLine.contains('ក.') ||
          trimmedLine.contains('ខ.') ||
          trimmedLine.contains('គ.')) {
        // Save previous subsection if exists
        if (currentMainSection.isNotEmpty && currentSubSection.isNotEmpty) {
          result[currentMainSection]![currentSubSection] =
              List.from(currentItems);
        }

        // Start new subsection
        currentSubSection = trimmedLine;
        currentItems = [];
      }
      // Add item to current subsection
      else if (trimmedLine.startsWith('-')) {
        if (currentMainSection.isNotEmpty && currentSubSection.isNotEmpty) {
          currentItems.add(trimmedLine.substring(1).trim());
        }
      }
    }

    // Save the last subsection if exists
    if (currentMainSection.isNotEmpty &&
        currentSubSection.isNotEmpty &&
        currentItems.isNotEmpty) {
      if (!result.containsKey(currentMainSection)) {
        result[currentMainSection] = {};
      }
      result[currentMainSection]![currentSubSection] = List.from(currentItems);
    }

    return result;
  }
}
