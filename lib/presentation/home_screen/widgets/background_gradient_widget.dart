import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class BackgroundGradientWidget extends StatefulWidget {
  const BackgroundGradientWidget({super.key});

  @override
  State<BackgroundGradientWidget> createState() =>
      _BackgroundGradientWidgetState();
}

class _BackgroundGradientWidgetState extends State<BackgroundGradientWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  AppTheme.backgroundGradientStart,
                  const Color(0xFF0D0A1E),
                  _animation.value,
                )!,
                Color.lerp(
                  AppTheme.backgroundGradientMid,
                  const Color(0xFF0A1628),
                  _animation.value,
                )!,
                Color.lerp(
                  AppTheme.backgroundGradientEnd,
                  const Color(0xFF1A0808),
                  _animation.value,
                )!,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: CustomPaint(painter: _StarFieldPainter(_animation.value)),
        );
      },
    );
  }
}

class _StarFieldPainter extends CustomPainter {
  final double animationValue;
  static final List<_Star> _stars = List.generate(
    60,
    (i) => _Star(
      x: (i * 137.508) % 1.0,
      y: (i * 73.137) % 1.0,
      size: 0.5 + (i % 4) * 0.4,
      opacity: 0.1 + (i % 5) * 0.08,
      phase: (i * 0.618) % 1.0,
    ),
  );

  _StarFieldPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in _stars) {
      final twinkle =
          0.4 +
          0.6 *
              (0.5 +
                  0.5 * math.sin((animationValue + star.phase) * math.pi * 2));
      final paint = Paint()
        ..color = Colors.white.withOpacity(star.opacity * twinkle)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }

    // Subtle glow at top (divine light effect)
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.8),
        radius: 0.6,
        colors: [
          AppTheme.primary.withOpacity(0.15 + 0.05 * animationValue),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glowPaint);

    // Subtle red glow at bottom
    final redGlowPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.4, 0.9),
        radius: 0.5,
        colors: [
          AppTheme.accent.withOpacity(0.08 + 0.04 * animationValue),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), redGlowPaint);
  }

  @override
  bool shouldRepaint(_StarFieldPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

class _Star {
  final double x, y, size, opacity, phase;
  const _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.phase,
  });
}
