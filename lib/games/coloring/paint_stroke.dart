import 'package:flutter/material.dart';

class PaintStroke {
  final List<Offset> points;
  final Color color;
  final double width;
  final bool isEraser;

  PaintStroke({
    required this.points,
    required this.color,
    required this.width,
    this.isEraser = false,
  });
}

class StrokesPainter extends CustomPainter {
  final List<PaintStroke> strokes;

  StrokesPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;

      final paint = Paint()
        ..color = stroke.isEraser ? Colors.white : stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..blendMode =
            stroke.isEraser ? BlendMode.srcOver : BlendMode.srcOver;

      if (stroke.points.length == 1) {
        canvas.drawCircle(
          stroke.points.first,
          stroke.width / 2,
          paint..style = PaintingStyle.fill,
        );
        continue;
      }

      final path = Path()..moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (var i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StrokesPainter oldDelegate) => true;
}
