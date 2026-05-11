import 'package:flutter/material.dart';

class DiagonalSplitCell extends StatelessWidget {
  final Color primary;
  final Color secondary;
  final Widget child;

  const DiagonalSplitCell({
    super.key,
    required this.primary,
    required this.secondary,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DiagonalPainter(primary: primary, secondary: secondary),
      child: child,
    );
  }
}

class _DiagonalPainter extends CustomPainter {
  final Color primary;
  final Color secondary;

  const _DiagonalPainter({required this.primary, required this.secondary});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(0, size.height)
        ..close(),
      Paint()..color = primary,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close(),
      Paint()..color = secondary,
    );
  }

  @override
  bool shouldRepaint(_DiagonalPainter old) =>
      old.primary != primary || old.secondary != secondary;
}
