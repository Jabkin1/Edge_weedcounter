import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import '../services/yolo_service.dart';
import '../utils/aggregator.dart';
import '../utils/detection_painter.dart';
import 'summary_page.dart';
import 'package:csv/csv.dart';
import '../utils/plant_data.dart';

/// Main widget class
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

  @override
  void initState() {
    super.initState();
    _loadLabels();
    _runDetection();
    // Use provided detections if available (e.g. from a previous session)
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
      setState(() {
        _labels = plant_data.getLabels();
      });
      debugPrint('✅ Loaded ${_labels.length} labels.');
    } catch (e) {
      debugPrint('⚠️ Failed to load labels.txt: $e');
    }
  }

  Future<void> _runDetection() async {
    if (_labels.isEmpty) {
      await _loadLabels();
      if (_labels.isEmpty) {
        debugPrint('⚠️ No labels loaded! Using placeholders.');
      }
    }// ✅ Ensure labels are loaded first

    setState(() => _loading = true);

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

      // ✅ FIX 4 & 5: Normalize keys and resolve label names from labels.txt.
      // YoloService now always emits 'classIndex' alongside the placeholder 'label'.
      // We prioritise classIndex → labels[idx] over the raw 'class_N' placeholder.
      final normalized = rawDetections.map((detection) {
        // Resolve the numeric class index (prefer explicit classIndex key)
        final dynamic rawClassIndex = detection['classIndex'] ??
            detection['class'] ??
            detection['class_id'] ??
            detection['label_index'];
        final int? classIndex = rawClassIndex != null ? (rawClassIndex as num).toInt() : null;

        // Map to a human-readable label
        final String label = (classIndex != null && classIndex < _labels.length)
            ? _labels[classIndex]
            : (detection['label'] as String? ??
               detection['class_name'] as String? ??
               'Unknown');

        return {
          'x':          (detection['x'] ?? detection['left'] ?? 0.0).toDouble(),
          'y':          (detection['y'] ?? detection['top']  ?? 0.0).toDouble(),
          'w':          (detection['w'] ?? detection['width'] ?? 0.0).toDouble(),
          'h':          (detection['h'] ?? detection['height'] ?? 0.0).toDouble(),
          'confidence': (detection['confidence'] ?? detection['score'] ?? detection['conf'] ?? 0.0)
                            .toDouble(),
          'classIndex': classIndex,
          'label':      label,
        };
      }).toList();

      final filtered =
          normalized.where((d) => (d['confidence'] as double) >= 0.3).toList();

      aggregator.addDetection(filtered);
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

  // ✅ FIX 6: _buildImageWithBoxes is now async-safe via FutureBuilder so we
  // never block the UI thread with readAsBytesSync / decodeImage.
  Widget _buildImageWithBoxes(String imagePath, List<Map<String, dynamic>> detections) {
    return FutureBuilder<img.Image?>(
      future: _decodeImageAsync(imagePath),
      builder: (context, snapshot) {
        final imageFile = File(imagePath);

        if (!snapshot.hasData || snapshot.data == null) {
          // Show the plain image while decoding (or on failure)
          return Image.file(imageFile);
        }

        final decoded = snapshot.data!;
        final origW = decoded.width.toDouble();
        final origH = decoded.height.toDouble();

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
                      detections: detections,
                      labels: _labels,
                      previewSize: Size(origW, origH),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<img.Image?> _decodeImageAsync(String path) async {
    try {
      final bytes = await File(path).readAsBytes();
      return img.decodeImage(bytes);
    } catch (e) {
      debugPrint('⚠️ Failed to decode image for overlay: $e');
      return null;
    }
  }

  Widget _buildDetectionList(List detections) {
    if (detections.isEmpty) {
      return const Text("No detections found.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: detections.map((det) {
        final label = det['label'] ?? 'Unknown';
        final conf = ((det['confidence'] ?? 0.0) as num) * 100;
        return Text(
          '- $label (${conf.toStringAsFixed(1)}%)',
          style: const TextStyle(fontSize: 14),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7DAE0),
      appBar: AppBar(
        title: const Text("Detections"),
        automaticallyImplyLeading: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount:
                  _results.isEmpty ? widget.imagePaths.length : _results.length,
              itemBuilder: (_, index) {
                final path = widget.imagePaths[index];
                final detections = _results.isNotEmpty
                    ? (_results[index]['detections'] as List)
                        .cast<Map<String, dynamic>>()
                    : <Map<String, dynamic>>[];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        detections.isEmpty
                            ? Image.file(File(path))
                            : _buildImageWithBoxes(path, detections),
                        const SizedBox(height: 8),
                        Text(
                          "Detections: ${detections.length}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
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
              label: const Text('View Summary'),
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
              label: const Text('Run Detection'),
              onPressed: _runDetection,
            ),
    );
  }
}
