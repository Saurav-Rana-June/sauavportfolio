import 'package:flutter/material.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_icons.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/widgets/icons/app_fa_icon.dart';

class SecondaryButton extends StatefulWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late final AnimationController _hoverController;
  late final AnimationController _iconController;
  
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _glowAnimation;
  late final Animation<double> _iconTranslateXAnimation;
  late final Animation<double> _iconTranslateYAnimation;

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

    final isExternal = widget.icon == AppIcons.arrowExternal;
    _iconTranslateXAnimation = Tween<double>(begin: 0.0, end: 3.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeOutBack),
    );
    _iconTranslateYAnimation = Tween<double>(
      begin: 0.0,
      end: isExternal ? -3.0 : 0.0,
    ).animate(
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

    return MouseRegion(
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
                    if (hoverVal > 0)
                      BoxShadow(
                        color: AppColors.accent.withValues(
                          alpha: hoverVal * 0.12,
                        ),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomPaint(
                    painter: _SecondaryButtonPainter(
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
                              color: Color.lerp(
                                AppColors.textPrimary,
                                Colors.white,
                                hoverVal,
                              ),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Transform.translate(
                            offset: Offset(
                              _iconTranslateXAnimation.value,
                              _iconTranslateYAnimation.value,
                            ),
                            child: AppFaIcon(
                              widget.icon ?? AppIcons.arrowExternal,
                              color: Color.lerp(
                                AppColors.textPrimary,
                                AppColors.accent,
                                hoverVal,
                              ),
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
  }
}

class _SecondaryButtonPainter extends CustomPainter {
  _SecondaryButtonPainter({
    required this.hoverProgress,
  });

  final double hoverProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));

    final paintBg = Paint()
      ..color = AppColors.surfaceDark.withValues(
        alpha: 0.6 + (hoverProgress * 0.3),
      );
    canvas.drawRRect(rrect, paintBg);

    // Gradient border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = LinearGradient(
        colors: [
          AppColors.border.withValues(alpha: 1.0 - hoverProgress),
          AppColors.accent.withValues(alpha: hoverProgress),
          AppColors.primaryLight.withValues(alpha: hoverProgress),
          AppColors.border.withValues(alpha: 1.0 - hoverProgress),
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
  bool shouldRepaint(covariant _SecondaryButtonPainter oldDelegate) {
    return oldDelegate.hoverProgress != hoverProgress;
  }
}
