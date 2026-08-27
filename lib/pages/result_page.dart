import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import '../services/yolo_service.dart';
import '../utils/aggregator.dart';
import '../utils/detection_painter.dart';
import '../gen_l10n/app_localizations.dart';
import 'summary_page.dart';

class ResultPage extends StatefulWidget {
  final List<String> imagePaths;
  final Map<String, List<Map<String, dynamic>>>? initialDetections;

  const ResultPage({
    Key? key,
    required this.imagePaths,
    this.initialDetections,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final List<Map<String, dynamic>> _results = [];
  DetectionAggregator? _aggregator;
  bool _loading = false;
  bool _detectionComplete = false;

  List<String> _labels = [];
  final Map<String, Size> _origDimensions = {};

  @override
  void initState() {
    super.initState();
    _loadLabels();
    _loadAllOrigDimensions();

    if (widget.initialDetections != null &&
        widget.initialDetections!.isNotEmpty) {
      for (final path in widget.imagePaths) {
        final dets = widget.initialDetections![path] ?? [];
        _results.add({'imagePath': path, 'detections': dets});
      }

      final aggregator = DetectionAggregator();
      for (final r in _results) {
        final List filtered = (r['detections'] as List).where((d) {
          final conf = (d['confidence'] ?? 0.0) as num;
          return conf >= 0.3;
        }).toList();
        aggregator.addDetection(filtered.cast<Map<String, dynamic>>());
      }

      _aggregator = aggregator;
      _detectionComplete = true;
      _loading = false;
    }
  }

  Future<void> _loadLabels() async {
    try {
      final raw = await rootBundle.loadString('assets/labels.txt');
      setState(() {
        _labels = raw.split('\n').where((l) => l.trim().isNotEmpty).toList();
      });
      debugPrint('✅ Loaded ${_labels.length} labels.');
    } catch (e) {
      debugPrint('⚠️ Failed to load labels.txt: $e');
    }
  }

  void _loadAllOrigDimensions() {
    for (final path in widget.imagePaths) {
      _loadOrigDimension(path);
    }
  }

  Future<void> _loadOrigDimension(String path) async {
    if (_origDimensions.containsKey(path)) return;
    try {
      final bytes = await File(path).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final dims = Size(frame.image.width.toDouble(), frame.image.height.toDouble());
      frame.image.dispose();
      if (mounted) {
        setState(() {
          _origDimensions[path] = dims;
        });
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load dimensions for $path: $e');
    }
  }

  Future<void> _runDetection() async {
    setState(() => _loading = true);

    if (_labels.isEmpty) {
      await _loadLabels();
    }

    final yolo = YoloService();
    await yolo.loadModel();

    final aggregator = DetectionAggregator();
    _results.clear();

    for (final path in widget.imagePaths) {
      debugPrint('🖼 Running detection on: $path');
      final bytes = await File(path).readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) {
        debugPrint('⚠️ Failed to decode $path');
        _results.add({'imagePath': path, 'detections': []});
        continue;
      }

      final rawDetections = await yolo.runOnImage(decoded);

      final normalized = rawDetections.map((det) {
        final ci = det['classIndex'];
        return {
          'x': (det['x'] ?? det['left'] ?? 0.0).toDouble(),
          'y': (det['y'] ?? det['top'] ?? 0.0).toDouble(),
          'w': (det['w'] ?? det['width'] ?? 0.0).toDouble(),
          'h': (det['h'] ?? det['height'] ?? 0.0).toDouble(),
          'confidence':
              (det['confidence'] ?? det['score'] ?? det['conf'] ?? 0.0)
                  .toDouble(),
          'classIndex': ci,
          'label': ci != null && ci < _labels.length
              ? _labels[ci]
              : det['label'] ?? det['class_name'] ?? 'Unknown',
        };
      }).toList();

      final filtered =
          normalized.where((d) => (d['confidence'] ?? 0.0) >= 0.3).toList();

      aggregator.addDetection(filtered.cast<Map<String, dynamic>>());
      _results.add({'imagePath': path, 'detections': filtered});
      debugPrint('✅ ${filtered.length} detections found for $path');
    }

    if (mounted) {
      setState(() {
        _loading = false;
        _detectionComplete = true;
        _aggregator = aggregator;
      });
    }
  }

  static const List<Color> _labelColors = [
    Color(0xFFE53935), Color(0xFF1E88E5), Color(0xFF43A047),
    Color(0xFFFB8C00), Color(0xFF8E24AA), Color(0xFF00ACC1),
    Color(0xFFD81B60), Color(0xFF3949AB), Color(0xFF00BCD4),
    Color(0xFF6D4C41), Color(0xFFFFB300), Color(0xFF7CB342),
  ];

  Color _colorForLabel(String label) {
    return _labelColors[label.hashCode % _labelColors.length];
  }

  Widget _buildImageWithBoxes(String imagePath, List detections) {
    final imageFile = File(imagePath);
    final origDims = _origDimensions[imagePath];
    if (origDims == null) {
      return Image.file(imageFile);
    }

    final origW = origDims.width;
    final origH = origDims.height;

    final List<Map<String, dynamic>> mappedDetections =
        detections.map<Map<String, dynamic>>((d) {
      if (d is Map<String, dynamic>) return d;
      return Map<String, dynamic>.from(d as Map);
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final displayW = constraints.maxWidth;
        final displayH = displayW * (origH / origW);

        return SizedBox(
          width: displayW,
          height: displayH,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(imageFile, fit: BoxFit.cover),
              CustomPaint(
                size: Size(displayW, displayH),
                painter: DetectionPainter(
                  detections: mappedDetections,
                  labels: _labels,
                  previewSize: Size(origW, origH),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConfidenceBar(double confidence) {
    final pct = (confidence * 100).clamp(0, 100);
    final color = pct >= 70
        ? Colors.green
        : pct >= 40
            ? Colors.orange
            : Colors.red;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: pct / 100,
        backgroundColor: Colors.grey.shade200,
        valueColor: AlwaysStoppedAnimation(color),
        minHeight: 8,
      ),
    );
  }

  Widget _buildDetectionList(List detections) {
    if (detections.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(l10n.noDetections, style: const TextStyle(fontSize: 14)),
      );
    }

    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final d in detections) {
      final label = d['label'] ?? 'Unknown';
      grouped.putIfAbsent(label, () => []).add(d);
    }

    final sortedLabels = grouped.keys.toList()
      ..sort((a, b) => grouped[b]!.length.compareTo(grouped[a]!.length));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedLabels.map((label) {
        final items = grouped[label]!;
        final bestConf =
            items.map((d) => (d['confidence'] ?? 0.0) as double).reduce(
              (a, b) => a > b ? a : b,
            );
        final color = _colorForLabel(label);
        final count = items.length;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              if (count > 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '×$count',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildConfidenceBar(bestConf),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 50,
                child: Text(
                  '${(bestConf * 100).toStringAsFixed(1)}%',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: bestConf >= 0.7 ? Colors.green.shade700 : Colors.orange.shade700,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFD7DAE0),
      appBar: AppBar(
        title: Text(l10n.detections),
        automaticallyImplyLeading: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.camera_alt_outlined),
                const SizedBox(width: 4),
                Text(l10n.retake),
              ],
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount:
                  _results.isEmpty ? widget.imagePaths.length : _results.length,
              itemBuilder: (_, index) {
                final path = widget.imagePaths[index];
                final detections = _results.isNotEmpty
                    ? _results[index]['detections'] as List
                    : [];

                return Card(
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: detections.isEmpty
                              ? Image.file(File(path), fit: BoxFit.cover)
                              : _buildImageWithBoxes(path, detections),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.search, size: 18, color: Colors.grey.shade600),
                            const SizedBox(width: 6),
                            Text(
                              l10n.countLabel(detections.length),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Divider(height: 1, color: Colors.grey.shade300),
                        const SizedBox(height: 4),
                        _buildDetectionList(detections),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: _detectionComplete && _aggregator != null
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.check_circle),
              label: Text(l10n.viewSummary),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SummaryPage(aggregator: _aggregator!),
                  ),
                );
              },
            )
          : FloatingActionButton.extended(
              icon: const Icon(Icons.play_arrow),
              label: Text(l10n.runDetection),
              onPressed: _runDetection,
            ),
    );
  }
}
