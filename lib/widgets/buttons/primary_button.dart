import 'package:flutter/material.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_icons.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/widgets/icons/app_fa_icon.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool expand;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late final AnimationController _hoverController;
  late final AnimationController _iconController;
  
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _glowAnimation;
  late final Animation<double> _sweepAnimation;
  late final Animation<double> _iconTranslateAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutBack),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOutCubic),
    );

    _sweepAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOutCubic),
    );

    _iconTranslateAnimation = Tween<double>(begin: 0.0, end: 4.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
      _iconController.forward();
    } else {
      _hoverController.reverse();
      _iconController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = _isPressed ? 0.96 : _scaleAnimation.value;

    final buttonContent = MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedBuilder(
          animation: Listenable.merge([_hoverController, _iconController]),
          builder: (context, child) {
            final hoverVal = _glowAnimation.value;

            return Transform.scale(
              scale: scaleFactor,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(
                        alpha: 0.25 + (hoverVal * 0.25),
                      ),
                      blurRadius: 12 + (hoverVal * 16),
                      offset: const Offset(0, 4),
                    ),
                    if (hoverVal > 0)
                      BoxShadow(
                        color: AppColors.accent.withValues(
                          alpha: hoverVal * 0.25,
                        ),
                        blurRadius: 24,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomPaint(
                    painter: _PrimaryButtonGlowPainter(
                      sweepProgress: _sweepAnimation.value,
                      hoverProgress: hoverVal,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 11,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.label,
                            style: AppTextStyles.r14.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Transform.translate(
                            offset: Offset(_iconTranslateAnimation.value, 0),
                            child: AppFaIcon(
                              widget.icon ?? AppIcons.arrowForward,
                              color: Colors.white,
                              size: AppScale.icon(14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    if (widget.expand) {
      return SizedBox(width: double.infinity, child: buttonContent);
    }
    return buttonContent;
  }
}

class _PrimaryButtonGlowPainter extends CustomPainter {
  _PrimaryButtonGlowPainter({
    required this.sweepProgress,
    required this.hoverProgress,
  });

  final double sweepProgress;
  final double hoverProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));

    final paintBg = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.primary, AppColors.accent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);
    canvas.drawRRect(rrect, paintBg);

    // Shimmer sweep highlight on hover
    if (hoverProgress > 0) {
      final sweepPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.0),
            Colors.white.withValues(alpha: 0.2 * hoverProgress),
            Colors.white.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(
          Rect.fromLTWH(
            rect.left + (rect.width * sweepProgress) - (rect.width / 2),
            rect.top,
            rect.width,
            rect.height,
          ),
        );

      canvas.save();
      canvas.clipRRect(rrect);
      canvas.drawRect(rect, sweepPaint);
      canvas.restore();
    }

    // Border highlights
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.15 + (hoverProgress * 0.35)),
          AppColors.accent.withValues(alpha: 0.15 + (hoverProgress * 0.35)),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    final borderRRect = RRect.fromRectAndRadius(
      rect.deflate(0.6),
      const Radius.circular(12),
    );
    canvas.drawRRect(borderRRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _PrimaryButtonGlowPainter oldDelegate) {
    return oldDelegate.sweepProgress != sweepProgress ||
        oldDelegate.hoverProgress != hoverProgress;
  }
}
