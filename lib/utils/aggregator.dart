/// Recommendation issued for a weed species relative to its economic threshold (ET).
enum Recommendation {
  noAction,
  borderline,
  intervention;

  String get label => switch (this) {
        Recommendation.noAction => 'No intervention required',
        Recommendation.borderline => 'Borderline - manual verification advised',
        Recommendation.intervention => 'Intervention recommended',
      };
}

/// Reference data used to interpret weed coverage (economic thresholds and species names).
class CropProtectionThresholds {
  CropProtectionThresholds._();

  /// Economic thresholds in [plants m⁻²] per species, keyed by EPPO/BAYER code.
  static const Map<String, double> economicThresholds = {
    'amare': 0.7, //  Amaranthus retroflexus L.
    'cheal': 3.5, //  Chenopodium album L.
    'echcg': 0.1, //  Echinochloa crus-galli (L.) P. Beauv.
    'galap': 2.0, //  Galium aparine L.
    'meran': 4.0, //  Mercurialis annua L.
    'paprh': 8.0, //  Papaver rhoeas L.
    'polla': 1.0, //  Persicaria lapathifolia (L.) Delarbre
    'solni': 1.0, //  Solanum nigrum L.
    'sonas': 1.0, //  Sonchus asper (L.) Hill
    'steme': 11.0, // Stellaria media (L.) Vill.
    'verpe': 20.0, // Veronica persica Poir.
  };

  /// Scientific species names (BAYER code -> name). Only weed species that carry
  /// an economic threshold are listed; the crop ('maize') is excluded on purpose.
  static const Map<String, String> speciesNames = {
    'amare': 'Amaranthus retroflexus L.',
    'cheal': 'Chenopodium album L.',
    'echcg': 'Echinochloa crus-galli (L.) P. Beauv.',
    'galap': 'Galium aparine L.',
    'meran': 'Mercurialis annua L.',
    'paprh': 'Papaver rhoeas L.',
    'polla': 'Persicaria lapathifolia (L.) Delarbre',
    'solni': 'Solanum nigrum L.',
    'sonas': 'Sonchus asper (L.) Hill',
    'steme': 'Stellaria media (L.) Vill.',
    'verpe': 'Veronica persica Poir.',
  };

  /// YOLO class order as declared in assets/labels.txt. Used as a fallback to
  /// resolve a detection that only carries a numeric class index.
  static const List<String> labelOrder = [
    'steme',
    'echcg',
    'solni',
    'cheal',
    'maize',
    'amare',
    'verpe',
    'polla',
    'galap',
    'paprh',
    'meran',
    'sonas',
  ];
}

/// Coverage assessment of a single weed species against its economic threshold (ET).
class SpeciesAssessment {
  final String label;
  final String speciesName;
  final double densityPerM2;
  final double economicThreshold;
  final Recommendation recommendation;

  const SpeciesAssessment({
    required this.label,
    required this.speciesName,
    required this.densityPerM2,
    required this.economicThreshold,
    required this.recommendation,
  });
}

/// Aggregates detections per captured picture and computes weed coverage
/// (in plants m⁻²) over a sample of 5 pictures covering 2.5 m², comparing each
/// species density against its economic threshold (ET).
class DetectionAggregator {
  /// A full sample consists of 5 captured pictures covering 2.5 m².
  static const int pictureSampleSize = 5;
  static const double sampleAreaM2 = 2.5;

  /// Each picture therefore covers 0.5 m².
  static const double areaPerPictureM2 = sampleAreaM2 / pictureSampleSize;

  /// Densities within ±10% of the ET are treated as borderline (manual check).
  static const double borderlineTolerance = 0.10;

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
        final label = resolveSpeciesCode(item['label'], item['classIndex']);
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
        if (item['label'] == label || item['classIndex'] == _codeToIndex(label)) {
          total += (item['confidence'] as num).toDouble();
          count++;
        }
      }
    }
    return count == 0 ? 0 : total / count;
  }

  void clear() => history.clear();

  // ---------------------------------------------------------------------------
  // Coverage calculation (per 5 pictures / 2.5 m²)
  // ---------------------------------------------------------------------------

  /// Most recent pictures to evaluate the sample from (up to `pictureSampleSize`).
  List<List<Map<String, dynamic>>> get _sample => history.length >= pictureSampleSize
      ? history.sublist(history.length - pictureSampleSize)
      : history;

  /// Number of pictures in the current sample.
  int get samplePictureCount => _sample.length;

  /// Ground area [m²] covered by the current sample (0.5 m² per picture).
  double get sampledAreaM2 => samplePictureCount * areaPerPictureM2;

  /// Total number of (de-duplicated) plants counted in the sample.
  int get totalPlantsInSample =>
      _sample.fold<int>(0, (sum, list) => sum + list.length);

  /// Per-species plant counts in the current 5-picture (2.5 m²) sample.
  Map<String, int> countPerLabelInSample() {
    final Map<String, int> count = {};
    for (final detectionList in _sample) {
      for (final item in detectionList) {
        final code = resolveSpeciesCode(item['label'], item['classIndex']);
        count[code] = (count[code] ?? 0) + 1;
      }
    }
    return count;
  }

  /// Estimated density [plants m⁻²] per detected species over the sample.
  Map<String, double> densityPerLabel() {
    final counts = countPerLabelInSample();
    final area = sampledAreaM2 > 0 ? sampledAreaM2 : areaPerPictureM2;
    return counts.map((label, c) => MapEntry(label, c / area));
  }

  /// Assessment for every weed species carrying an economic threshold.
  List<SpeciesAssessment> assessCoverage() {
    final densities = densityPerLabel();
    return [
      for (final entry in CropProtectionThresholds.economicThresholds.entries)
        SpeciesAssessment(
          label: entry.key,
          speciesName:
              CropProtectionThresholds.speciesNames[entry.key] ?? entry.key,
          densityPerM2: densities[entry.key] ?? 0.0,
          economicThreshold: entry.value,
          recommendation:
              classifyDensity(densities[entry.key] ?? 0.0, entry.value),
        ),
    ];
  }

  /// Only the species whose density triggered a borderline/intervention message.
  List<SpeciesAssessment> get triggeredAssessments =>
      assessCoverage()
          .where((a) => a.recommendation != Recommendation.noAction)
          .toList();

  /// True when at least one species requires intervention or manual verification.
  bool get hasTrigger => triggeredAssessments.isNotEmpty;

  /// Classifies a measured density against its ET:
  /// - density < 0.9·ET            -> no intervention required
  /// - 0.9·ET ≤ density ≤ 1.1·ET   -> borderline (manual verification)
  /// - density > 1.1·ET            -> intervention recommended
  static Recommendation classifyDensity(double density, double et) {
    const double eps = 1e-6;
    final lower = et * (1 - borderlineTolerance);
    final upper = et * (1 + borderlineTolerance);
    if (density < lower - eps) return Recommendation.noAction;
    if (density > upper + eps) return Recommendation.intervention;
    return Recommendation.borderline;
  }

  /// Resolves the canonical BAYER code from a detection's label / class index.
  /// Handles both the resolved labels ('amare', 'steme', ...) and raw fallbacks
  /// ('class_5') produced by the YOLO post-processor.
  static String resolveSpeciesCode(Object? label, Object? classIndex) {
    if (label is String) {
      if (CropProtectionThresholds.labelOrder.contains(label) ||
          CropProtectionThresholds.economicThresholds.containsKey(label)) {
        return label;
      }
      if (label.startsWith('class_')) {
        final idx = int.tryParse(label.substring('class_'.length));
        if (idx != null && idx >= 0 && idx < CropProtectionThresholds.labelOrder.length) {
          return CropProtectionThresholds.labelOrder[idx];
        }
      }
    }
    if (classIndex is num) {
      final idx = classIndex.toInt();
      if (idx >= 0 && idx < CropProtectionThresholds.labelOrder.length) {
        return CropProtectionThresholds.labelOrder[idx];
      }
    }
    return label is String ? label : 'Unknown';
  }

  static int? _codeToIndex(String code) {
    final idx = CropProtectionThresholds.labelOrder.indexOf(code);
    return idx >= 0 ? idx : null;
  }
}