import 'package:flutter/material.dart';
import '../utils/aggregator.dart';

class SummaryPage extends StatelessWidget {
  final DetectionAggregator aggregator;
  final Map<String, double> thresholds;
  const SummaryPage({super.key, required this.aggregator, required this.thresholds});

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
          final plantDensity = (total / labels.length) * 2;
          final sprayThreshold = thresholds[label] ?? 0.0;
          final shouldShowImage = plantDensity > sprayThreshold && sprayThreshold > 0;
          final text =  'Count: $total\nAverage Confidence: ${(avg * 100).toStringAsFixed(1)}%\n'+
                        'Average: ${plantDensity.toStringAsFixed(1)} plants per m² \n\n\n\n\nhello';
          final screensize = MediaQuery.of(context).size;
          return ListTile(
            leading: const Icon(Icons.analytics),
            title: Text(label),
            subtitle: Text(text),
            trailing: shouldShowImage ?
            Container(
              width: screensize.width * 0.3, height: screensize.height*0.3,
              decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 2,),
              ),
              child: Image.asset('assets/pulverise.png', fit: BoxFit.cover,),
            )
                : null
          );
        },
      ),
    );
  }
}
