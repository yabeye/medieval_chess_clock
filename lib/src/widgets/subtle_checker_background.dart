import 'package:flutter/material.dart';
import 'package:medieval_chess_clock/src/theme.dart';

class SubtleCheckerBackground extends StatelessWidget {
  final Widget? child;
  final double opacity;
  final double squareSize;
  final Color? gridColor;
  final Color? backgroundColor;

  const SubtleCheckerBackground({
    super.key,
    this.child,
    this.opacity = 0.04,
    this.squareSize = 48.0,
    this.gridColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGridColor = gridColor ?? MedievalTheme.tertiary;
    final effectiveBgColor = backgroundColor ?? MedievalTheme.neutral;

    return Container(
      color: effectiveBgColor,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: opacity,
              child: CustomPaint(
                painter: _SubtleCheckerPainter(
                  squareSize: squareSize,
                  color: effectiveGridColor,
                ),
              ),
            ),
          ),
          if (child != null) Positioned.fill(child: child!),
        ],
      ),
    );
  }
}

class _SubtleCheckerPainter extends CustomPainter {
  final double squareSize;
  final Color color;

  _SubtleCheckerPainter({required this.squareSize, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (double y = 0; y < size.height; y += squareSize) {
      for (double x = 0; x < size.width; x += squareSize) {
        final int col = (x / squareSize).floor();
        final int row = (y / squareSize).floor();
        if ((row + col) % 2 == 0) {
          canvas.drawRect(Rect.fromLTWH(x, y, squareSize, squareSize), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SubtleCheckerPainter oldDelegate) {
    return oldDelegate.squareSize != squareSize || oldDelegate.color != color;
  }
}
