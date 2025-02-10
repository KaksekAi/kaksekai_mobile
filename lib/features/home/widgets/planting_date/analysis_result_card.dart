import 'package:flutter/material.dart';

class AnalysisResultCard extends StatelessWidget {
  final String result;
  final Color _primaryColor = const Color(0xFF1B5E20);
  final Color _backgroundColor = const Color(0xFFF5F5F5);

  const AnalysisResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final sections = _parseAnalysisSections(result);
    final bool isPositive = result.toLowerCase().contains('អាចដាំបាន');

    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isPositive ? _primaryColor : Colors.red[700],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isPositive ? Icons.check_circle_outline : Icons.error_outline,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'លទ្ធផលនៃការវិភាគ',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (sections['summary'] != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          sections['summary']!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    height: 1.5,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: _backgroundColor,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (sections['details'] != null) ...[
                  _buildDetailsSection(context, sections['details']!),
                  const Divider(height: 40, thickness: 1),
                ],
                if (sections['recommendations'] != null)
                  _buildRecommendationsSection(
                      context, sections['recommendations']!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context, String details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                color: _primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'ព័ត៌មានលម្អិត',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            details,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  letterSpacing: 0.3,
                  color: Colors.black87,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection(
      BuildContext context, String recommendations) {
    final recommendationPoints = _parseRecommendationPoints(recommendations);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: _primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'អនុសាសន៍',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...recommendationPoints.map((category) {
          return _buildRecommendationCategory(context, category);
        }).toList(),
      ],
    );
  }

  Widget _buildRecommendationCategory(
      BuildContext context, Map<String, dynamic> category) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.08),
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
                    color: _primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    category['title'].substring(0, 1),
                    style: TextStyle(
                      color: _primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category['title'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...category['points'].map<Widget>((point) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8, right: 12),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            point,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  height: 1.6,
                                  letterSpacing: 0.3,
                                  color: Colors.black87,
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> _parseAnalysisSections(String analysis) {
    final sections = <String, String>{};

    // Split by double newlines to separate major sections
    final parts = analysis.split('\n\n');
    if (parts.isEmpty) return sections;

    // First part is always summary
    sections['summary'] = parts[0].trim();

    // Find recommendations section (starts with numbered list)
    int recommendationsStart = -1;
    for (int i = 1; i < parts.length; i++) {
      if (parts[i].trim().startsWith('១.') ||
          parts[i].trim().startsWith('២.') ||
          parts[i].trim().startsWith('៣.') ||
          parts[i].trim().startsWith('៤.')) {
        recommendationsStart = i;
        break;
      }
    }

    // If we found recommendations, everything between summary and recommendations is details
    if (recommendationsStart > 1) {
      sections['details'] =
          parts.sublist(1, recommendationsStart).join('\n\n').trim();
      sections['recommendations'] =
          parts.sublist(recommendationsStart).join('\n\n').trim();
    } else if (recommendationsStart == 1) {
      sections['recommendations'] = parts.sublist(1).join('\n\n').trim();
    } else if (parts.length > 1) {
      // If no recommendations found, everything after summary is details
      sections['details'] = parts.sublist(1).join('\n\n').trim();
    }

    return sections;
  }

  List<Map<String, dynamic>> _parseRecommendationPoints(
      String recommendations) {
    final categories = <Map<String, dynamic>>[];
    var currentCategory = <String, dynamic>{};
    var currentPoints = <String>[];

    final lines = recommendations.split('\n');
    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      if (trimmedLine.startsWith('១.') ||
          trimmedLine.startsWith('២.') ||
          trimmedLine.startsWith('៣.') ||
          trimmedLine.startsWith('៤.')) {
        if (currentCategory.isNotEmpty) {
          currentCategory['points'] = List<String>.from(currentPoints);
          categories.add(Map<String, dynamic>.from(currentCategory));
          currentPoints = [];
        }
        currentCategory = {'title': trimmedLine};
      } else if (trimmedLine.startsWith('-') ||
          trimmedLine.startsWith('•') ||
          trimmedLine.startsWith('*')) {
        currentPoints.add(trimmedLine.substring(1).trim());
      } else if (currentPoints.isNotEmpty) {
        // If line doesn't start with a bullet but we're in a category,
        // append it to the last point (for wrapped text)
        currentPoints[currentPoints.length - 1] += ' $trimmedLine';
      } else if (currentCategory.isNotEmpty) {
        // If we're in a category but haven't started points yet,
        // this might be category description
        currentPoints.add(trimmedLine);
      }
    }

    if (currentCategory.isNotEmpty && currentPoints.isNotEmpty) {
      currentCategory['points'] = List<String>.from(currentPoints);
      categories.add(currentCategory);
    }

    return categories;
  }
}
