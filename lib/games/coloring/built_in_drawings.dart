import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Dibuja contornos simples para colorear cuando aún no hay imágenes en assets.
class BuiltInDrawingPainter extends CustomPainter {
  final String drawingId;
  final Color strokeColor;
  final double strokeWidth;

  BuiltInDrawingPainter({
    required this.drawingId,
    this.strokeColor = const Color(0xFF222222),
    this.strokeWidth = 4,
  });

  Paint get _stroke => Paint()
    ..color = strokeColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    final s = math.min(size.width, size.height);
    final ox = (size.width - s) / 2;
    final oy = (size.height - s) / 2;
    canvas.save();
    canvas.translate(ox, oy);
    canvas.scale(s / 100, s / 100);

    switch (drawingId) {
      case 'house':
        _house(canvas);
      case 'sun':
        _sun(canvas);
      case 'fish':
        _fish(canvas);
      case 'flower':
        _flower(canvas);
      case 'car':
        _car(canvas);
      case 'star':
        _star(canvas);
      default:
        _star(canvas);
    }

    canvas.restore();
  }

  void _house(Canvas canvas) {
    final p = _stroke;
    // walls
    canvas.drawRect(const Rect.fromLTWH(20, 45, 60, 40), p);
    // roof
    final roof = Path()
      ..moveTo(15, 45)
      ..lineTo(50, 18)
      ..lineTo(85, 45)
      ..close();
    canvas.drawPath(roof, p);
    // door
    canvas.drawRect(const Rect.fromLTWH(40, 58, 20, 27), p);
    // window
    canvas.drawRect(const Rect.fromLTWH(28, 52, 12, 12), p);
    canvas.drawLine(const Offset(34, 52), const Offset(34, 64), p);
    canvas.drawLine(const Offset(28, 58), const Offset(40, 58), p);
    // chimney
    canvas.drawRect(const Rect.fromLTWH(62, 25, 10, 18), p);
  }

  void _sun(Canvas canvas) {
    final p = _stroke;
    canvas.drawCircle(const Offset(50, 50), 22, p);
    // smile
    canvas.drawArc(
      const Rect.fromLTWH(38, 48, 24, 18),
      0.15,
      math.pi - 0.3,
      false,
      p,
    );
    // eyes
    canvas.drawCircle(const Offset(42, 45), 2.5, p..style = PaintingStyle.fill);
    canvas.drawCircle(const Offset(58, 45), 2.5, p);
    p.style = PaintingStyle.stroke;
    // rays
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final i1 = Offset(50 + math.cos(a) * 30, 50 + math.sin(a) * 30);
      final i2 = Offset(50 + math.cos(a) * 42, 50 + math.sin(a) * 42);
      canvas.drawLine(i1, i2, p);
    }
  }

  void _fish(Canvas canvas) {
    final p = _stroke;
    // body
    canvas.drawOval(const Rect.fromLTWH(18, 32, 52, 36), p);
    // tail
    final tail = Path()
      ..moveTo(70, 50)
      ..lineTo(90, 32)
      ..lineTo(90, 68)
      ..close();
    canvas.drawPath(tail, p);
    // eye
    canvas.drawCircle(const Offset(32, 46), 3.5, p);
    canvas.drawCircle(
      const Offset(32, 46),
      1.5,
      Paint()..color = strokeColor,
    );
    // fin
    final fin = Path()
      ..moveTo(42, 38)
      ..lineTo(52, 22)
      ..lineTo(58, 38);
    canvas.drawPath(fin, p);
    // smile
    canvas.drawArc(
      const Rect.fromLTWH(24, 50, 14, 10),
      0.2,
      math.pi - 0.4,
      false,
      p,
    );
  }

  void _flower(Canvas canvas) {
    final p = _stroke;
    // stem
    canvas.drawLine(const Offset(50, 55), const Offset(50, 90), p);
    // leaf
    final leaf = Path()
      ..moveTo(50, 72)
      ..quadraticBezierTo(68, 68, 72, 78)
      ..quadraticBezierTo(58, 82, 50, 72);
    canvas.drawPath(leaf, p);
    // petals
    for (var i = 0; i < 6; i++) {
      final a = i * math.pi / 3;
      final cx = 50 + math.cos(a) * 16;
      final cy = 40 + math.sin(a) * 16;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy), width: 20, height: 14),
        p,
      );
    }
    // center
    canvas.drawCircle(const Offset(50, 40), 10, p);
  }

  void _car(Canvas canvas) {
    final p = _stroke;
    // body
    final body = Path()
      ..moveTo(12, 58)
      ..lineTo(18, 42)
      ..lineTo(38, 36)
      ..lineTo(58, 36)
      ..lineTo(78, 48)
      ..lineTo(88, 58)
      ..lineTo(88, 68)
      ..lineTo(12, 68)
      ..close();
    canvas.drawPath(body, p);
    // windows
    canvas.drawRect(const Rect.fromLTWH(30, 42, 14, 12), p);
    canvas.drawRect(const Rect.fromLTWH(48, 42, 16, 12), p);
    // wheels
    canvas.drawCircle(const Offset(30, 70), 9, p);
    canvas.drawCircle(const Offset(70, 70), 9, p);
    canvas.drawCircle(const Offset(30, 70), 3.5, p);
    canvas.drawCircle(const Offset(70, 70), 3.5, p);
  }

  void _star(Canvas canvas) {
    final p = _stroke;
    final path = Path();
    const cx = 50.0;
    const cy = 50.0;
    const outer = 36.0;
    const inner = 16.0;
    for (var i = 0; i < 10; i++) {
      final r = i.isEven ? outer : inner;
      final a = -math.pi / 2 + i * math.pi / 5;
      final x = cx + math.cos(a) * r;
      final y = cy + math.sin(a) * r;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, p);
    // smile face
    canvas.drawCircle(const Offset(42, 48), 2.5, p..style = PaintingStyle.fill);
    canvas.drawCircle(const Offset(58, 48), 2.5, p);
    p.style = PaintingStyle.stroke;
    canvas.drawArc(
      const Rect.fromLTWH(42, 52, 16, 12),
      0.15,
      math.pi - 0.3,
      false,
      p,
    );
  }

  @override
  bool shouldRepaint(covariant BuiltInDrawingPainter oldDelegate) {
    return oldDelegate.drawingId != drawingId ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
