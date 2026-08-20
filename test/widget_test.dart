import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yweed_counter_plus/pages/summary_page.dart';
import 'package:yweed_counter_plus/utils/aggregator.dart';

void main() {
  testWidgets('summary page builds with an empty aggregator',
      (tester) async {
    final aggregator = DetectionAggregator();

    await tester.pumpWidget(
      MaterialApp(home: SummaryPage(aggregator: aggregator)),
    );

    expect(find.byType(SummaryPage), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
  });
}