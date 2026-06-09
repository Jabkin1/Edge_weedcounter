import 'package:flutter/material.dart';

class BBoxPainter extends CustomPainter {
  final List<Map<String, dynamic>> results;
  BBoxPainter(this.results);

  final List<Color> classColors = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.tealAccent,
    Colors.pinkAccent,
    Colors.cyanAccent,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: Colors.yellowAccent,
      fontSize: 14.0,
      backgroundColor: Colors.black54,
    );

    for (var result in results) {
      final rect = result['rect'] as Rect;
      final label = result['label'] as String;
      final score = result['score'] as double;
      final classIndex = result['class'] as int;
      final displayText = '$label ${(score * 100).toStringAsFixed(1)}%';

      final boxPaint = Paint()
        ..color = classColors[classIndex % classColors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawRect(rect, boxPaint);

      final textSpan = TextSpan(text: displayText, style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout(maxWidth: size.width);

      final offset = Offset(rect.left, rect.top - textPainter.height);
      canvas.drawRect(
        Rect.fromLTWH(offset.dx, offset.dy, textPainter.width, textPainter.height),
        Paint()..color = Colors.black54,
      );
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
