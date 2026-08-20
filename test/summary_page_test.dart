import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yweed_counter_plus/pages/summary_page.dart';
import 'package:yweed_counter_plus/utils/aggregator.dart';

DetectionAggregator _aggregatorWith(List<List<Map<String, dynamic>>> sample) {
  final agg = DetectionAggregator();
  for (final pic in sample) {
    agg.addDetection(pic);
  }
  return agg;
}

Map<String, dynamic> _det(String label) => {'label': label, 'confidence': 0.8};

/// Finds `text` only inside the header message card (the triggered message),
/// ignoring the per-species chips.
Finder _inHeader(String text) => find.descendant(
      of: find.byKey(const Key('coverage-header')),
      matching: find.text(text),
    );

void main() {
  testWidgets('no trigger -> No intervention required', (tester) async {
    final agg = _aggregatorWith(
      List.generate(5, (_) => <Map<String, dynamic>>[]),
    );

    await tester.pumpWidget(
      MaterialApp(home: SummaryPage(aggregator: agg)),
    );

    expect(_inHeader('No intervention required'), findsOneWidget);
    expect(_inHeader('Intervention recommended'), findsNothing);
    expect(_inHeader('Manual verification advised'), findsNothing);
  });

  testWidgets('species above ET -> Intervention recommended', (tester) async {
    // echcg: 3 detections per picture x 5 = 15 / 2.5 m² = 6 plants/m² vs ET 0.1.
    final sample = List.generate(
      5,
      (_) => [_det('echcg'), _det('echcg'), _det('echcg')],
    );
    final agg = _aggregatorWith(sample);

    await tester.pumpWidget(
      MaterialApp(home: SummaryPage(aggregator: agg)),
    );

    expect(_inHeader('Intervention recommended'), findsOneWidget);
    expect(_inHeader('No intervention required'), findsNothing);
    // The offending species must be named in the message.
    expect(find.textContaining('Echinochloa crus-galli'), findsWidgets);
  });

  testWidgets('density within +-10% of ET -> Manual verification advised',
      (tester) async {
    // galap ET = 2.0, exactly on target: 1 detection per picture x 5 = 5 / 2.5 = 2.0.
    final sample = List.generate(5, (_) => [_det('galap')]);
    final agg = _aggregatorWith(sample);

    await tester.pumpWidget(
      MaterialApp(home: SummaryPage(aggregator: agg)),
    );

    expect(_inHeader('Manual verification advised'), findsOneWidget);
    expect(_inHeader('Intervention recommended'), findsNothing);
  });
}