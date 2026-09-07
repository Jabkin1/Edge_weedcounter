import 'package:flutter/material.dart';
import '../utils/aggregator.dart';
import '../utils/plant_data.dart';

class SummaryPage extends StatelessWidget {
  final DetectionAggregator aggregator;
  const SummaryPage({super.key, required this.aggregator});

  (IconData, Color) _styleFor(Recommendation r) => switch (r) {
        Recommendation.noAction => (Icons.check_circle, Colors.green),
        Recommendation.borderline =>
          (Icons.warning_amber_rounded, Colors.orange),
        Recommendation.intervention => (Icons.error, Colors.red),
      };

  String _densityText(double v) => v.toStringAsFixed(2);

  Widget _buildHeader(
    BuildContext context,
    List<SpeciesAssessment> triggers,
    int pictures,
    double area,
  ) {
    final bool any = triggers.isNotEmpty;
    final bool borderlineOnly =
        any && triggers.every((t) => t.recommendation == Recommendation.borderline);

    final String title;
    final String message;
    final IconData icon;
    final Color color;

    if (!any) {
      title = 'No intervention required';
      message =
          'All species are below their economic thresholds in the sampled area.';
      icon = Icons.check_circle_outline;
      color = Colors.green;
    } else if (borderlineOnly) {
      title = 'Manual verification advised';
      message =
          'Coverage is within ±10% of the economic threshold for the species below.';
      icon = Icons.warning_amber_rounded;
      color = Colors.orange;
    } else {
      title = 'Intervention recommended';
      message =
          'One or more weed species exceed their economic threshold in this sample.';
      icon = Icons.error_outline;
      color = Colors.red;
    }

    final actionList = triggers
        .map((t) =>
            '${plant_data.getScientificName(t.label)} (${_densityText(t.densityPerM2)} / ${_densityText(t.economicThreshold)} plants·m⁻²)')
        .join('\n');

    return Card(
      key: const Key('coverage-header'),
      color: color.withValues(alpha: 0.10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Sample: $pictures of ${DetectionAggregator.pictureSampleSize} '
              'pictures · ${area.toStringAsFixed(1)} m²',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 14),
            ),
            if (actionList.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                actionList,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentTile(BuildContext context, SpeciesAssessment a) {
    final (icon, color) = _styleFor(a.recommendation);
    final common = plant_data.getName(a.label);
    // Spraying (pulverisation) notification when intervention is recommended.
    final showSpray = a.recommendation == Recommendation.intervention &&
        plant_data.getRow(a.label) != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant_data.getScientificName(a.label),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (common.isNotEmpty)
                    Text(
                      common,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    'Density: ${_densityText(a.densityPerM2)} plants·m⁻²   '
                    '|   ET: ${_densityText(a.economicThreshold)} plants·m⁻²',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    'Detected: ${(a.densityPerM2 * aggregator.sampledAreaM2).round()} '
                    'plants in ${aggregator.samplePictureCount} pictures',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Chip(
                  label: Text(
                    a.recommendation.label,
                    style: TextStyle(color: color, fontSize: 11),
                  ),
                  backgroundColor: color.withValues(alpha: 0.12),
                  side: BorderSide(color: color.withValues(alpha: 0.4)),
                ),
                if (showSpray) ...[
                  const SizedBox(height: 8),
                  const SizedBox(
                    width: 64,
                    height: 64,
                    child: Image(
                      image: AssetImage('assets/pulverise.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final assessments = aggregator.assessCoverage();
    final triggers = aggregator.triggeredAssessments;
    final pictures = aggregator.samplePictureCount;
    final area = aggregator.sampledAreaM2;

    return Scaffold(
      appBar: AppBar(title: const Text('Detection Summary')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildHeader(context, triggers, pictures, area),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Weed coverage per species (5 pictures = 2.5 m²)',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          for (final a in assessments) _buildAssessmentTile(context, a),
        ],
      ),
    );
  }
}