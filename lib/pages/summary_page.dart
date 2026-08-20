import 'package:flutter/material.dart';
import 'package:yweed_counter_plus/utils/plant_data.dart';
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
          final plantDensity = (total / labels.length) * 2;
          final sprayThreshold = plant_data.getThreshold(label);
          final common_name = plant_data.getName(label);
          final shouldShowImage = plantDensity > sprayThreshold && sprayThreshold > 0;
          final text =  '${plant_data.getScientificName(label)}\n'+'Count: $total\nAverage Confidence: ${(avg * 100).toStringAsFixed(1)}%\n'+
                        'Average: ${plantDensity.toStringAsFixed(1)} plants per m²';
          final screenSize = MediaQuery.of(context).size;
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.analytics),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(common_name, style: const TextStyle(fontSize: 20),), Text(text),],
                  ),
                ),
                if (shouldShowImage)
                  Container(
                    width: screenSize.width * 0.3,
                    height: screenSize.width * 0.3,
                    decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 3,),
                    ),
                    child: Image.asset('assets/pulverise.png', fit: BoxFit.cover),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
