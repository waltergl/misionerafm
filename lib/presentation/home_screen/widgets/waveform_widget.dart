import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class WaveformWidget extends StatefulWidget {
  final bool isPlaying;

  const WaveformWidget({super.key, required this.isPlaying});

  @override
  State<WaveformWidget> createState() => _WaveformWidgetState();
}

class _WaveformWidgetState extends State<WaveformWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  static const int _barCount = 28;

  // Pre-computed phase offsets for natural-looking wave
  final List<double> _phases = List.generate(
    _barCount,
    (i) => (i * 0.618) % (2 * math.pi),
  );
  final List<double> _frequencies = List.generate(
    _barCount,
    (i) => 0.8 + (i % 5) * 0.35,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(WaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 7.h,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _WaveformPainter(
              animationValue: _controller.value,
              isPlaying: widget.isPlaying,
              phases: _phases,
              frequencies: _frequencies,
              barCount: _barCount,
              primaryColor: AppTheme.primary,
              accentColor: AppTheme.accent,
              goldColor: AppTheme.gold,
            ),
          );
        },
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double animationValue;
  final bool isPlaying;
  final List<double> phases;
  final List<double> frequencies;
  final int barCount;
  final Color primaryColor;
  final Color accentColor;
  final Color goldColor;

  _WaveformPainter({
    required this.animationValue,
    required this.isPlaying,
    required this.phases,
    required this.frequencies,
    required this.barCount,
    required this.primaryColor,
    required this.accentColor,
    required this.goldColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double barWidth = (size.width - (barCount - 1) * 3) / barCount;
    final double centerY = size.height / 2;
    final double maxHeight = size.height * 0.9;
    final double minHeight = size.height * 0.08;

    for (int i = 0; i < barCount; i++) {
      double normalizedPos = i / (barCount - 1);
      double barHeight;

      if (isPlaying) {
        final t = animationValue * 2 * math.pi * frequencies[i] + phases[i];
        final wave1 = math.sin(t);
        final wave2 = math.sin(t * 1.7 + 0.5);
        final combined = (wave1 * 0.6 + wave2 * 0.4);
        final envelope = math.sin(normalizedPos * math.pi);
        barHeight =
            minHeight +
            (maxHeight - minHeight) *
                0.5 *
                (1 + combined) *
                (0.3 + 0.7 * envelope);
      } else {
        // Static idle state — gentle sine
        final idleHeight = 0.15 + 0.25 * math.sin(normalizedPos * math.pi);
        barHeight = minHeight + (maxHeight - minHeight) * idleHeight;
      }

      // Color gradient across bars
      final Color barColor;
      if (normalizedPos < 0.33) {
        barColor = Color.lerp(primaryColor, accentColor, normalizedPos * 3)!;
      } else if (normalizedPos < 0.66) {
        barColor = Color.lerp(
          accentColor,
          goldColor,
          (normalizedPos - 0.33) * 3,
        )!;
      } else {
        barColor = Color.lerp(
          goldColor,
          primaryColor,
          (normalizedPos - 0.66) * 3,
        )!;
      }

      final double opacity = isPlaying
          ? (0.5 + 0.5 * (barHeight / maxHeight))
          : 0.3;
      final paint = Paint()
        ..color = barColor.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      final double x = i * (barWidth + 3);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, centerY - barHeight / 2, barWidth, barHeight),
        const Radius.circular(3),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.isPlaying != isPlaying;
}
