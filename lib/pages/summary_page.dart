import 'package:flutter/material.dart';
import '../utils/aggregator.dart';

class SummaryPage extends StatelessWidget {
  final DetectionAggregator aggregator;
  const SummaryPage({super.key, required this.aggregator});

  @override
  Widget build(BuildContext context) {
    final Map<String, int> count = aggregator.countPerLabel();
    final List<String> labels = count.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Detection Summary')),
      body: ListView.builder(
        itemCount: labels.length,
        itemBuilder: (context, index) {
          final label = labels[index];
          final total = count[label] ?? 0;
          final avg = aggregator.averageConfidence(label);

          return ListTile(
            leading: const Icon(Icons.analytics),
            title: Text(label),
            subtitle: Text('Count: $total\nAverage Confidence: ${(avg * 100).toStringAsFixed(1)}%'),
          );
        },
      ),
    );
  }
}
