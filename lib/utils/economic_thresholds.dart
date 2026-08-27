/// Economic thresholds for weed species in plants per square metre.
///
/// Each value represents the maximum tolerated density of that species
/// (plants/m²). The app calculates: area = images_taken × 0.5 m²,
/// density = count / area, and compares against these values.
///
/// Three outcome zones:
///   - Below threshold        → no action needed
///   - At or above threshold  → borderline, manual check recommended
///   - ≥1.5× threshold        → action required, manage weeds
///
/// To adjust a threshold, change the double value below. Add or remove
/// entries as new weed classes are added to labels.txt and the model.
class EconomicThresholds {
  /// Area covered by a single phone camera image in m².
  static const double areaPerImage = 0.5;

  /// Density thresholds in plants per m².
  static const Map<String, double> thresholds = {
    // ── Weed species ──────────────────────────────────────────
    'STEME': 2.0,   // Common chickweed (Stellaria media)
    'ECHCG': 1.0,   // Barnyard grass (Echinochloa crus-galli)
    'SOLNI': 3.0,   // Black nightshade (Solanum nigrum)
    'CHEAL': 1.5,   // Common lambsquarters (Chenopodium album)
    'AMARE': 2.0,   // Redroot pigweed (Amaranthus retroflexus)
    'VERPE': 4.0,   // Ivy-leaved speedwell (Veronica persica)
    'POLLA': 2.5,   // Pale persicaria (Persicaria lapathifolia)
    'GALAP': 1.5,   // Cleavers (Galium aparine)
    'PAPRH': 2.0,   // Common poppy (Papaver rhoeas)
    'MERAN': 3.0,   // Annual mercury (Mercurialis annua)
    'SONAS': 2.0,   // Sow thistle (Sonchus asper)
    // ── Crop ──────────────────────────────────────────────────
    'MAIZE': 0.0,   // Maize — crop, never triggers action
  };

  static double forLabel(String label) => thresholds[label] ?? -1.0;
}

/// Result of evaluating one weed species against its economic threshold.
class ThresholdEvaluation {
  final String label;
  final int count;
  final double density;
  final double thresholdDensity;
  final ThresholdStatus status;

  ThresholdEvaluation({
    required this.label,
    required this.count,
    required this.density,
    required this.thresholdDensity,
  }) : status = thresholdDensity <= 0
           ? ThresholdStatus.below
           : density >= thresholdDensity * 1.5
               ? ThresholdStatus.above
               : density >= thresholdDensity
                   ? ThresholdStatus.borderline
                   : ThresholdStatus.below;
}

enum ThresholdStatus { below, borderline, above }
