import 'economic_thresholds.dart';

class DetectionAggregator {
  final List<List<Map<String, dynamic>>> history = [];

  int get imageCount => history.length;
  double get totalArea => imageCount * EconomicThresholds.areaPerImage;

  void addDetection(List<Map<String, dynamic>> result) {
    history.add(result);
  }

  Map<String, int> countPerLabel() {
    final Map<String, int> count = {};
    for (final detectionList in history) {
      for (final item in detectionList) {
        final label = item['label'] as String;
        count[label] = (count[label] ?? 0) + 1;
      }
    }
    return count;
  }

  double averageConfidence(String label) {
    double total = 0;
    int count = 0;
    for (final detectionList in history) {
      for (final item in detectionList) {
        if (item['label'] == label) {
          total += item['confidence'] as double;
          count++;
        }
      }
    }
    return count == 0 ? 0 : total / count;
  }

  /// Evaluate all detected labels against their density-based economic thresholds.
  /// Sorted by severity: above → borderline → below, then by count descending.
  List<ThresholdEvaluation> evaluateThresholds() {
    final counts = countPerLabel();
    final area = totalArea;
    if (area <= 0) return [];

    final evals = counts.entries
        .where((e) => EconomicThresholds.forLabel(e.key) >= 0)
        .map((e) => ThresholdEvaluation(
              label: e.key,
              count: e.value,
              density: e.value / area,
              thresholdDensity: EconomicThresholds.forLabel(e.key),
            ))
        .toList();

    evals.sort((a, b) {
      if (a.status.index != b.status.index) {
        return b.status.index.compareTo(a.status.index);
      }
      return b.count.compareTo(a.count);
    });
    return evals;
  }

  void clear() => history.clear();
}
