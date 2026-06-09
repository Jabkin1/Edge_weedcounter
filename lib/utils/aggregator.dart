class DetectionAggregator {
  final List<List<Map<String, dynamic>>> history = [];

  void addDetection(List<Map<String, dynamic>> result) {
    history.add(result);
    if (history.length > 10) {
      history.removeAt(0);
    }
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
          // ✅ FIX: was 'score' — detections are stored with key 'confidence'
          total += (item['confidence'] as num).toDouble();
          count++;
        }
      }
    }
    return count == 0 ? 0 : total / count;
  }

  void clear() => history.clear();
}
