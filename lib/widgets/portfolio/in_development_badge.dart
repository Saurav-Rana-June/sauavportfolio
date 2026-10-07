import 'package:flutter/material.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';

/// A sleek, subtle, and futuristic status pill indicating that a project
/// is currently under active development.
class InDevelopmentBadge extends StatefulWidget {
  final bool compact;
  final String? label;

  const InDevelopmentBadge({
    super.key,
    this.compact = false,
    this.label,
  });

  @override
  State<InDevelopmentBadge> createState() => _InDevelopmentBadgeState();
}

class _InDevelopmentBadgeState extends State<InDevelopmentBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = widget.compact;
    final text = widget.label ?? (isCompact ? 'In Development' : 'Currently in Development');
    final double dotSize = isCompact ? AppScale.w(5.0) : AppScale.w(6.5);
    final double fontSize = isCompact ? AppScale.font(9.5) : AppScale.font(11.0);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final pulse = _pulseAnimation.value;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? AppScale.w(8) : AppScale.w(10),
            vertical: isCompact ? AppScale.h(3.5) : AppScale.h(4.5),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFF59E0B).withValues(alpha: 0.12),
                const Color(0xFFD97706).withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.22 + (0.08 * pulse)),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.08 * pulse),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Subtle pulsing status indicator dot
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: dotSize + (4.0 * pulse),
                    height: dotSize + (4.0 * pulse),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.25 * (1.1 - pulse)),
                    ),
                  ),
                  Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.5 * pulse),
                          blurRadius: 4,
                          spreadRadius: 0.5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: isCompact ? AppScale.w(5) : AppScale.w(7)),
              Text(
                text,
                style: AppTextStyles.mono12.copyWith(
                  color: const Color(0xFFFCD34D),
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
