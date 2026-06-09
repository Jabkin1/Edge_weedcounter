import 'package:flutter/material.dart';

class DetectionPainter extends CustomPainter {
  final List<Map<String, dynamic>> detections;
  final List<String> labels;
  final Size previewSize;

  DetectionPainter({
    required this.detections,
    required this.labels,
    required this.previewSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final textStyle = TextStyle(
      color: Colors.white,
      backgroundColor: Colors.green,
      fontSize: 14,
    );

    // scale from previewSize -> current canvas size
    final scaleX = size.width / previewSize.width;
    final scaleY = size.height / previewSize.height;

    for (final det in detections) {
      final rectLeft = (det['x'] ?? det['left'] ?? 0.0) as double;
      final rectTop = (det['y'] ?? det['top'] ?? 0.0) as double;
      final rectW = (det['w'] ?? det['width'] ?? 0.0) as double;
      final rectH = (det['h'] ?? det['height'] ?? 0.0) as double;
      final classIndex = (det['classIndex'] ??
              det['class'] ??
              det['class_id'] ??
              det['label_index']) ??
          0;
      final int idx = (classIndex is int) ? classIndex : int.tryParse('$classIndex') ?? 0;
      final label = (det['label'] ??
              (idx < labels.length ? labels[idx] : null) ??
              'Unknown') as String;
      final conf = ((det['confidence'] ?? det['score'] ?? 0.0) as num).toDouble();

      final left = rectLeft * scaleX;
      final top = rectTop * scaleY;
      final w = rectW * scaleX;
      final h = rectH * scaleY;

      // choose color by label
      final color = Colors.primaries[label.hashCode % Colors.primaries.length];
      paint.color = color;

      // box
      canvas.drawRect(Rect.fromLTWH(left, top, w, h), paint);

      // label background
      final labelText = '$label ${(conf * 100).toStringAsFixed(1)}%';
      final textSpan = TextSpan(text: labelText, style: textStyle);
      final tp = TextPainter(
          text: textSpan, textDirection: TextDirection.ltr, maxLines: 1)
        ..layout();

      final bgRect = Rect.fromLTWH(left, top - tp.height - 6, tp.width + 8, tp.height + 4);
      final bgPaint = Paint()..color = color.withValues(alpha: 0.8);
      canvas.drawRect(bgRect, bgPaint);

      tp.paint(canvas, Offset(left + 4, top - tp.height - 4));
    }
  }

  @override
  bool shouldRepaint(covariant DetectionPainter oldDelegate) =>
      oldDelegate.detections != detections || oldDelegate.labels != labels;
}
