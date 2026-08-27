import 'package:flutter/material.dart';
import '../utils/aggregator.dart';
import '../utils/economic_thresholds.dart';
import '../gen_l10n/app_localizations.dart';

class SummaryPage extends StatelessWidget {
  final DetectionAggregator aggregator;
  const SummaryPage({super.key, required this.aggregator});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final evals = aggregator.evaluateThresholds();

    final above = evals.where((e) => e.status == ThresholdStatus.above).length;
    final borderline = evals.where((e) => e.status == ThresholdStatus.borderline).length;
    final area = aggregator.totalArea;

    ThresholdStatus worst = ThresholdStatus.below;
    if (above > 0) {
      worst = ThresholdStatus.above;
    } else if (borderline > 0) {
      worst = ThresholdStatus.borderline;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.detectionSummary)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () =>
                Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.home),
                const SizedBox(width: 8),
                Text(l10n.backToHome),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (evals.isNotEmpty)
            _StatusBanner(worst: worst, l10n: l10n, area: area),
          Expanded(
            child: evals.isEmpty
                ? _EmptyState(l10n: l10n)
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: evals.length,
                    separatorBuilder: (_, _) =>
                        Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (_, index) => _ThresholdTile(
                      evaluation: evals[index],
                      l10n: l10n,
                      area: area,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final ThresholdStatus worst;
  final AppLocalizations l10n;
  final double area;
  const _StatusBanner({required this.worst, required this.l10n, required this.area});

  @override
  Widget build(BuildContext context) {
    final (bg, border, iconColor, icon, title, subtitle, baseColor) =
      switch (worst) {
        ThresholdStatus.above => (
          Colors.red.shade50,
          Colors.red.shade200,
          Colors.red,
          Icons.error_outline,
          l10n.manageWeeds,
          l10n.manageWeedsDesc,
          Colors.red,
        ),
        ThresholdStatus.borderline => (
          Colors.amber.shade50,
          Colors.amber.shade200,
          Colors.orange,
          Icons.warning_amber_rounded,
          l10n.manualCheckRecommended,
          l10n.manualCheckDesc,
          Colors.orange,
        ),
        ThresholdStatus.below => (
          Colors.green.shade50,
          Colors.green.shade200,
          Colors.green,
          Icons.check_circle_outline,
          l10n.noActionNeeded,
          null,
          Colors.green,
        ),
      };

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
           Icon(icon, color: iconColor, size: 28),
           const SizedBox(width: 12),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: (baseColor as MaterialColor).shade800,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: (baseColor as MaterialColor).shade600),
                    ),
                const SizedBox(height: 2),
                Text(
                  '${l10n.areaLabel}: ${area.toStringAsFixed(1)} m²',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;
  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            l10n.noDetectionsRecorded,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _ThresholdTile extends StatelessWidget {
  final ThresholdEvaluation evaluation;
  final AppLocalizations l10n;
  final double area;
  const _ThresholdTile({required this.evaluation, required this.l10n, required this.area});

  static const List<Color> _labelColors = [
    Color(0xFFE53935), Color(0xFF1E88E5), Color(0xFF43A047),
    Color(0xFFFB8C00), Color(0xFF8E24AA), Color(0xFF00ACC1),
    Color(0xFFD81B60), Color(0xFF3949AB), Color(0xFF00BCD4),
    Color(0xFF6D4C41), Color(0xFFFFB300), Color(0xFF7CB342),
  ];

  Color _labelColor(String label) {
    return _labelColors[label.hashCode % _labelColors.length];
  }

  (Color, IconData, String) _statusProps(ThresholdStatus s) => switch (s) {
    ThresholdStatus.above => (Colors.red, Icons.error_outline, l10n.manageWeeds),
    ThresholdStatus.borderline => (Colors.orange, Icons.warning_amber_rounded, l10n.manualCheckRecommended),
    ThresholdStatus.below => (Colors.green, Icons.check_circle_outline, l10n.noActionNeeded),
  };

  @override
  Widget build(BuildContext context) {
    final eval = evaluation;
    final dotColor = _labelColor(eval.label);
    final ratio = eval.thresholdDensity > 0
        ? eval.density / eval.thresholdDensity
        : 0.0;
    final (statusColor, statusIcon, statusText) = _statusProps(eval.status);

    // Ensure the bar never shows zero when density > 0
    final barValue = ratio.clamp(0.0, 1.5);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 14,
            height: 14,
            margin: const EdgeInsets.only(top: 3),
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eval.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _StatChip(label: l10n.chipCount, value: '${eval.count}'),
                    _StatChip(
                      label: l10n.chipDensity,
                      value: '${eval.density.toStringAsFixed(1)}',
                    ),
                    _StatChip(
                      label: l10n.chipThreshold,
                      value: eval.thresholdDensity > 0
                          ? '${eval.thresholdDensity.toStringAsFixed(1)}/m²'
                          : '—',
                    ),
                  ],
                ),
                if (eval.thresholdDensity > 0) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: barValue == 0 && eval.count > 0 ? 0.01 : barValue,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(statusColor),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.percentOfThreshold(ratio * 100),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: (statusColor as MaterialColor).shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
