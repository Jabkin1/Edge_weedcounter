import 'package:flutter_test/flutter_test.dart';
import 'package:yweed_counter_plus/utils/aggregator.dart';

Map<String, dynamic> _det(String label) => {'label': label, 'confidence': 0.9};

void main() {
  test('density is computed over the last 5 pictures (2.5 m2)', () {
    final agg = DetectionAggregator();

    // 7 pictures captured; sample must use only the last 5.
    for (int i = 0; i < 2; i++) {
      agg.addDetection([_det('solni')]);
    }
    // 3 echcg per picture for 5 pictures => 15 plants / 2.5 m2 = 6 plants/m2.
    final sample = List.generate(
      5,
      (_) => [_det('echcg'), _det('echcg'), _det('echcg')],
    );
    for (final pic in sample) {
      agg.addDetection(pic);
    }

    expect(agg.samplePictureCount, 5);
    expect(agg.sampledAreaM2, closeTo(2.5, 1e-9));

    final densities = agg.densityPerLabel();
    expect(densities, isNot(contains('solni'))); // dropped by the last-5 window.
    expect(densities['echcg'], closeTo(6.0, 1e-9));
  });

  test('species above ET -> intervention recommended', () {
    final agg = DetectionAggregator();
    for (int i = 0; i < 5; i++) {
      agg.addDetection([_det('echcg'), _det('echcg')]);
    }

    final echcg = agg.assessCoverage().firstWhere((a) => a.label == 'echcg');
    expect(echcg.densityPerM2, closeTo(4.0, 1e-9));
    expect(echcg.economicThreshold, 0.1);
    expect(echcg.recommendation, Recommendation.intervention);
    expect(agg.hasTrigger, isTrue);
    expect(agg.triggeredAssessments.map((a) => a.label), contains('echcg'));
  });

  test('density exactly at ET -> borderline (manual verification)', () {
    final agg = DetectionAggregator();
    // galap ET = 2.0; 1 per picture x 5 = 5 / 2.5 = 2.0 exactly on ET.
    for (int i = 0; i < 5; i++) {
      agg.addDetection([_det('galap')]);
    }

    final galap = agg.assessCoverage().firstWhere((a) => a.label == 'galap');
    expect(galap.densityPerM2, closeTo(2.0, 1e-9));
    expect(galap.recommendation, Recommendation.borderline);
  });

  test('species below ET -> no intervention', () {
    final agg = DetectionAggregator();
    // meran ET = 4.0; 1 per picture x 5 = 5 / 2.5 = 2.0 below ET.
    for (int i = 0; i < 5; i++) {
      agg.addDetection([_det('meran')]);
    }

    final meran = agg.assessCoverage().firstWhere((a) => a.label == 'meran');
    expect(meran.densityPerM2, closeTo(2.0, 1e-9));
    expect(meran.recommendation, Recommendation.noAction);

    final unless = agg.assessCoverage().firstWhere((a) => a.label == 'steme');
    expect(unless.recommendation, Recommendation.noAction);
  });

  test('classifyDensity respects the +-10% band around ET', () {
    // ET = 0.1 -> lower band 0.09, upper band 0.11.
    expect(DetectionAggregator.classifyDensity(0.089, 0.1),
        Recommendation.noAction);
    expect(DetectionAggregator.classifyDensity(0.09, 0.1),
        Recommendation.borderline);
    expect(DetectionAggregator.classifyDensity(0.10, 0.1),
        Recommendation.borderline);
    expect(DetectionAggregator.classifyDensity(0.11, 0.1),
        Recommendation.borderline);
    expect(DetectionAggregator.classifyDensity(0.1101, 0.1),
        Recommendation.intervention);
  });

  test('resolveSpeciesCode handles BAYER codes and raw class_N labels', () {
    expect(DetectionAggregator.resolveSpeciesCode('amare', null), 'amare');
    expect(DetectionAggregator.resolveSpeciesCode('class_5', 5), 'amare');
    expect(DetectionAggregator.resolveSpeciesCode(null, 3), 'cheal');
    expect(DetectionAggregator.resolveSpeciesCode('class_4', 4), 'maize');
    expect(DetectionAggregator.resolveSpeciesCode('weird', null), 'weird');
  });
}