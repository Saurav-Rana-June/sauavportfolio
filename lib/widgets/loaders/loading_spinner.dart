import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';

/// A futuristic, cyber-themed animated loading spinner featuring
/// the portfolio's central logo, counter-rotating HUD rings, orbital
/// particles, and an animated laser scanner.
class LoadingSpinner extends StatefulWidget {
  final double? size;
  final String? text;
  final bool showText;
  final bool compact;

  const LoadingSpinner({
    super.key,
    this.size,
    this.text,
    this.showText = true,
    this.compact = false,
  });

  @override
  State<LoadingSpinner> createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = widget.compact;
    final double defaultSize = isCompact
        ? 52.0
        : (AppScale.isMobile ? 124.0 : 148.0);
    final double effectiveSize = widget.size ?? defaultSize;
    final double logoSize = effectiveSize * 0.44;

    return Center(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final double value = _controller.value;
            // Smooth pulse between 0.0 and 1.0
            final double pulse = (math.sin(value * 2 * math.pi) + 1.0) / 2.0;
            final double logoScale = 0.94 + (pulse * 0.08);

            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: effectiveSize,
                  height: effectiveSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. Concentric Cyber HUD Rings & Particles
                      CustomPaint(
                        size: Size(effectiveSize, effectiveSize),
                        painter: _FuturisticCyberPainter(
                          progress: value,
                          pulseProgress: pulse,
                          primaryColor: AppColors.primary,
                          accentColor: AppColors.accent,
                        ),
                      ),

                      // 2. Center Glassmorphic Pod with Portfolio Logo
                      Transform.scale(
                        scale: logoScale,
                        child: Container(
                          width: logoSize,
                          height: logoSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surfaceDark.withValues(
                              alpha: 0.82,
                            ),
                            border: Border.all(
                              color: Color.lerp(
                                AppColors.primary,
                                AppColors.accent,
                                pulse,
                              )!.withValues(alpha: 0.5 + (pulse * 0.3)),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.lerp(
                                  AppColors.primary,
                                  AppColors.accent,
                                  pulse,
                                )!.withValues(alpha: 0.25 + (pulse * 0.2)),
                                blurRadius: 18 + (pulse * 6),
                                spreadRadius: 1 + (pulse * 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Padding(
                              padding: EdgeInsets.all(logoSize * 0.22),
                              child: SvgPicture.asset(
                                'assets/images/logo.svg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. Status Text & Laser Shimmer (Only in non-compact mode)
                if (!isCompact && widget.showText) ...[
                  SizedBox(height: AppScale.h(22)),
                  _FuturisticStatusText(
                    text: widget.text ?? 'INITIALIZING PORTFOLIO',
                    pulse: pulse,
                    progress: value,
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Custom painter for futuristic HUD circular tracks, counter-rotating sweeps,
/// and orbital particle sparks.
class _FuturisticCyberPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final double pulseProgress; // 0.0 to 1.0
  final Color primaryColor;
  final Color accentColor;

  _FuturisticCyberPainter({
    required this.progress,
    required this.pulseProgress,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;

    // 1. Ambient Background Halo Glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          accentColor.withValues(alpha: 0.16 + (pulseProgress * 0.08)),
          primaryColor.withValues(alpha: 0.08 + (pulseProgress * 0.05)),
          Colors.transparent,
        ],
        stops: const [0.0, 0.58, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius));
    canvas.drawCircle(center, maxRadius, glowPaint);

    // 2. Outer Static Guide Track
    final outerRadius = maxRadius * 0.94;
    final outerTrackPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, outerRadius, outerTrackPaint);

    // 3. Outer Rotating Cyber Arc (Clockwise)
    final outerAngle = progress * 2 * math.pi;
    final outerArcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: math.pi * 1.4,
        transform: GradientRotation(outerAngle),
        colors: [
          Colors.transparent,
          accentColor.withValues(alpha: 0.2),
          accentColor,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: outerRadius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      outerAngle,
      math.pi * 1.15,
      false,
      outerArcPaint,
    );

    // Outer Orbit Particle Spark
    final particleAngle = outerAngle + (math.pi * 1.15);
    final px = center.dx + outerRadius * math.cos(particleAngle);
    final py = center.dy + outerRadius * math.sin(particleAngle);
    final particleGlow = Paint()
      ..color = accentColor.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(Offset(px, py), 4.5, particleGlow);
    final particleCore = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(px, py), 2.2, particleCore);

    // 4. Middle Counter-Rotating Track (Counter-Clockwise)
    final middleRadius = maxRadius * 0.77;
    final middleAngle = -progress * 2 * math.pi * 1.4;
    final middleArcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: math.pi,
        transform: GradientRotation(middleAngle),
        colors: [
          Colors.transparent,
          primaryColor.withValues(alpha: 0.3),
          primaryColor,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: middleRadius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: middleRadius),
      middleAngle,
      math.pi * 0.8,
      false,
      middleArcPaint,
    );

    // Opposite minor arc in middle track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: middleRadius),
      middleAngle + math.pi,
      math.pi * 0.35,
      false,
      middleArcPaint,
    );

    // 5. Crosshair Ticks (N, S, E, W HUD Markers)
    final tickPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.45)
      ..strokeWidth = 1.2;
    for (int i = 0; i < 4; i++) {
      final angle = i * (math.pi / 2);
      final p1 = Offset(
        center.dx + (outerRadius - 3.5) * math.cos(angle),
        center.dy + (outerRadius - 3.5) * math.sin(angle),
      );
      final p2 = Offset(
        center.dx + (outerRadius + 3.5) * math.cos(angle),
        center.dy + (outerRadius + 3.5) * math.sin(angle),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }
  }

  @override
  bool shouldRepaint(_FuturisticCyberPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.pulseProgress != pulseProgress;
}

/// Cyber status bar with pulsing typography, blinking cursor,
/// and laser scanning bar.
class _FuturisticStatusText extends StatelessWidget {
  final String text;
  final double pulse;
  final double progress;

  const _FuturisticStatusText({
    required this.text,
    required this.pulse,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final bool cursorVisible = (progress * 8).floor() % 2 == 0;
    const double barWidth = 130.0;
    const double barHeight = 2.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Status Row with blinking cyber cursor
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: AppTextStyles.mono12.copyWith(
                color: AppColors.accent,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w700,
                fontSize: AppScale.font(11),
              ),
            ),
            const SizedBox(width: 4),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: cursorVisible ? 1.0 : 0.15,
              child: Container(
                width: 6,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.6),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppScale.h(10)),

        // High-tech scanning bar
        Container(
          width: barWidth,
          height: barHeight,
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(barHeight / 2),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.6),
              width: 0.5,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Laser sweep back and forth across track
              final sweep = (math.sin(progress * 2 * math.pi) + 1.0) / 2.0;
              final double laserWidth = constraints.maxWidth * 0.35;
              final double leftOffset =
                  (constraints.maxWidth - laserWidth) * sweep;

              return Stack(
                children: [
                  Positioned(
                    left: leftOffset,
                    top: 0,
                    bottom: 0,
                    width: laserWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppColors.accent,
                            AppColors.primary,
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(barHeight / 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.7),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: AppScale.h(6)),

        // Micro-HUD caption
        Text(
          'SAURAV.DEV // PORTFOLIO',
          style: AppTextStyles.mono12.copyWith(
            color: AppColors.textSecondary.withValues(alpha: 0.5),
            fontSize: AppScale.font(9),
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}
