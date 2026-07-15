import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_icons.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/widgets/icons/app_fa_icon.dart';
import 'package:saurav_portfolio/widgets/layout/portfolio_nav_section.dart';

class PortfolioNavbar extends StatefulWidget {
  const PortfolioNavbar({
    super.key,
    required this.activeSection,
    required this.onLogoTap,
    required this.onAboutTap,
    required this.onProjectsTap,
    required this.onContactTap,
  });

  final PortfolioNavSection activeSection;
  final VoidCallback onLogoTap;
  final VoidCallback onAboutTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onContactTap;

  @override
  State<PortfolioNavbar> createState() => _PortfolioNavbarState();
}

class _PortfolioNavbarState extends State<PortfolioNavbar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _borderPulse;

  static final _navItems = [
    _NavItem(PortfolioNavSection.about, 'About', AppIcons.about),
    _NavItem(PortfolioNavSection.projects, 'Projects', AppIcons.projects),
    _NavItem(PortfolioNavSection.contact, 'Contact', AppIcons.contact),
  ];

  @override
  void initState() {
    super.initState();
    // Breathing animation for the entire glass panel shadow and border
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _borderPulse = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _resolveTap(PortfolioNavSection section) {
    switch (section) {
      case PortfolioNavSection.home:
        widget.onLogoTap();
      case PortfolioNavSection.about:
        widget.onAboutTap();
      case PortfolioNavSection.projects:
        widget.onProjectsTap();
      case PortfolioNavSection.contact:
        widget.onContactTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = !AppScale.isDesktop;

    return AnimatedBuilder(
      animation: _borderPulse,
      builder: (context, child) {
        final pulseVal = _borderPulse.value;

        return ClipRRect(
          borderRadius: BorderRadius.circular(AppScale.r(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? AppScale.w(14) : AppScale.w(18),
                vertical: AppScale.h(12),
              ),
              decoration: BoxDecoration(
                color: AppColors.glassFill,
                borderRadius: BorderRadius.circular(AppScale.r(20)),
                border: Border.all(
                  color: Colors.white.withValues(
                    alpha: 0.08 + (pulseVal * 0.08),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.glowPrimary.withValues(
                      alpha: 0.15 + (pulseVal * 0.15),
                    ),
                    blurRadius: 20 + (pulseVal * 12),
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _BrandLockup(showSubtitle: !isCompact),
                  const Spacer(),
                  if (!isCompact) ...[
                    _DesktopNavRail(
                      activeSection: widget.activeSection,
                      items: _navItems,
                      onTap: _resolveTap,
                    ),
                    // Spacing.s12.gapW,
                    // _ContactPill(
                    //   isActive:
                    //       widget.activeSection == PortfolioNavSection.contact,
                    //   onTap: widget.onContactTap,
                    // ),
                  ] else
                    _MobileNavMenu(
                      activeSection: widget.activeSection,
                      items: _navItems,
                      onTap: _resolveTap,
                      onContactTap: widget.onContactTap,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem {
  const _NavItem(this.section, this.label, this.icon);

  final PortfolioNavSection section;
  final String label;
  final IconData icon;
}

class _BrandLockup extends StatefulWidget {
  const _BrandLockup({this.showSubtitle = true});

  final bool showSubtitle;

  @override
  State<_BrandLockup> createState() => _BrandLockupState();
}

class _BrandLockupState extends State<_BrandLockup>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _hoverController;
  late final Animation<double> _logoRotation;
  late final Animation<double> _logoScale;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    // Continuous breathing pulse for the online indicator dot
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Hover response for logo rotation/scaling
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _logoRotation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutBack),
    );
    _logoScale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppScale.w(6),
          vertical: AppScale.h(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rotating & glowing logo on hover
            AnimatedBuilder(
              animation: _logoScale,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoScale.value,
                  child: Transform.rotate(
                    angle: _logoRotation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          if (_isHovered)
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.35),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                        ],
                      ),
                      width: AppScale.icon(38),
                      height: AppScale.icon(38),
                      child: SvgPicture.asset(
                        'assets/images/logo.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
            Spacing.s10.gapW,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Metallic futuristic gradient text
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.textPrimary, AppColors.primaryLight],
                  ).createShader(bounds),
                  child: Text(
                    'Saurav Rana',
                    style: AppTextStyles.sb18.copyWith(color: Colors.white),
                  ),
                ),
                if (widget.showSubtitle) ...[
                  2.0.gapH,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Active/Online status indicator
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: 0.4 + (_pulseController.value * 0.6),
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.success,
                                    blurRadius: 6,
                                    spreadRadius: 1.5,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      6.0.gapW,
                      Text(
                        'Flutter Engineer',
                        style: AppTextStyles.r12.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopNavRail extends StatelessWidget {
  const _DesktopNavRail({
    required this.activeSection,
    required this.items,
    required this.onTap,
  });

  final PortfolioNavSection activeSection;
  final List<_NavItem> items;
  final ValueChanged<PortfolioNavSection> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppScale.r(4)),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          return _NavPillLink(
            label: item.label,
            icon: item.icon,
            isActive: activeSection == item.section,
            onTap: () => onTap(item.section),
          );
        }).toList(),
      ),
    );
  }
}

class _NavPillLink extends StatefulWidget {
  const _NavPillLink({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_NavPillLink> createState() => _NavPillLinkState();
}

class _NavPillLinkState extends State<_NavPillLink>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    if (widget.isActive) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered || widget.isActive) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(covariant _NavPillLink oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive || _isHovered) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final highlight = widget.isActive || _isHovered;

    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.symmetric(horizontal: AppScale.w(2)),
        decoration: BoxDecoration(
          gradient: widget.isActive
              ? LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.accent.withValues(alpha: 0.15),
                  ],
                )
              : _isHovered
              ? LinearGradient(
                  colors: [
                    AppColors.surfaceDark.withValues(alpha: 0.9),
                    AppColors.cardDark.withValues(alpha: 0.8),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: widget.isActive
                ? AppColors.primary.withValues(alpha: 0.4)
                : _isHovered
                ? AppColors.accent.withValues(alpha: 0.25)
                : Colors.transparent,
            width: 1.0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(999),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppScale.w(14),
                vertical: AppScale.h(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: AppFaIcon(
                      widget.icon,
                      size: AppScale.icon(16),
                      color: highlight
                          ? AppColors.accent
                          : AppColors.textSecondary,
                    ),
                  ),
                  Spacing.s8.gapW,
                  Text(
                    widget.label,
                    style: AppTextStyles.r14.copyWith(
                      color: highlight
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactPill extends StatefulWidget {
  const _ContactPill({required this.isActive, required this.onTap});

  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_ContactPill> createState() => _ContactPillState();
}

class _ContactPillState extends State<_ContactPill>
    with TickerProviderStateMixin {
  late final AnimationController _hoverController;
  late final AnimationController _iconController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _glowAnimation;
  late final Animation<double> _sweepAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOutCubic),
    );

    _sweepAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    if (isHovered) {
      _hoverController.forward();
      _iconController.forward(from: 0.0);
    } else {
      _hoverController.reverse();
    }
  }

  double get _iconOpacity {
    final t = _iconController.value;
    if (t < 0.4) {
      return 1.0 - (t / 0.4);
    } else if (t < 0.5) {
      return 0.0;
    } else {
      return (t - 0.5) / 0.5;
    }
  }

  Offset get _iconOffset {
    final t = _iconController.value;
    if (t < 0.4) {
      final progress = t / 0.4;
      return Offset(progress * 15.0, progress * -15.0);
    } else if (t < 0.5) {
      return const Offset(-15.0, 15.0);
    } else {
      final progress = (t - 0.5) / 0.5;
      return Offset((1.0 - progress) * -15.0, (1.0 - progress) * 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedBuilder(
        animation: Listenable.merge([_hoverController, _iconController]),
        builder: (context, child) {
          final hoverVal = widget.isActive ? 1.0 : _glowAnimation.value;
          final scaleVal = widget.isActive ? 1.04 : _scaleAnimation.value;

          return Transform.scale(
            scale: scaleVal,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(
                      alpha: 0.2 + (hoverVal * 0.25),
                    ),
                    blurRadius: 10 + (hoverVal * 15),
                    offset: const Offset(0, 4),
                  ),
                  if (hoverVal > 0)
                    BoxShadow(
                      color: AppColors.accent.withValues(
                        alpha: hoverVal * 0.25,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: CustomPaint(
                  painter: _ButtonGlowPainter(
                    sweepProgress: _sweepAnimation.value,
                    hoverProgress: hoverVal,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onTap,
                      borderRadius: BorderRadius.circular(999),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppScale.w(18),
                          vertical: AppScale.h(13),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Transform.translate(
                              offset: _iconOffset,
                              child: Opacity(
                                opacity: _iconOpacity,
                                child: AppFaIcon(
                                  AppIcons.send,
                                  color: Colors.white,
                                  size: AppScale.icon(16),
                                ),
                              ),
                            ),
                            Spacing.s8.gapW,
                            Text(
                              'Let\'s talk',
                              style: AppTextStyles.r14.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ButtonGlowPainter extends CustomPainter {
  _ButtonGlowPainter({
    required this.sweepProgress,
    required this.hoverProgress,
  });

  final double sweepProgress;
  final double hoverProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(size.height / 2),
    );

    final paintBg = Paint();

    // Base background: translucent dark gray
    paintBg.color = AppColors.glassFill.withValues(
      alpha: AppColors.glassFill.a * (1.0 - hoverProgress),
    );
    canvas.drawRRect(rrect, paintBg);

    // Hover background: colored gradient
    if (hoverProgress > 0) {
      final paintHoverBg = Paint()
        ..shader = const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(rect)
        ..color = Colors.white.withValues(alpha: hoverProgress);
      canvas.drawRRect(rrect, paintHoverBg);
    }

    // Shimmer sweep highlight
    if (hoverProgress > 0) {
      final sweepPaint = Paint()
        ..shader =
            LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.0),
                Colors.white.withValues(alpha: 0.25 * hoverProgress),
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

    // Elegant gradient border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = LinearGradient(
        colors: [
          AppColors.primary.withValues(alpha: 0.35 + (hoverProgress * 0.65)),
          AppColors.accent.withValues(alpha: 0.35 + (hoverProgress * 0.65)),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    final borderRRect = RRect.fromRectAndRadius(
      rect.deflate(0.75),
      Radius.circular(size.height / 2),
    );
    canvas.drawRRect(borderRRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _ButtonGlowPainter oldDelegate) {
    return oldDelegate.sweepProgress != sweepProgress ||
        oldDelegate.hoverProgress != hoverProgress;
  }
}

class _MobileNavMenu extends StatelessWidget {
  const _MobileNavMenu({
    required this.activeSection,
    required this.items,
    required this.onTap,
    required this.onContactTap,
  });

  final PortfolioNavSection activeSection;
  final List<_NavItem> items;
  final ValueChanged<PortfolioNavSection> onTap;
  final VoidCallback onContactTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // _ContactPill(
        //   isActive: activeSection == PortfolioNavSection.contact,
        //   onTap: onContactTap,
        // ),
        // Spacing.s8.gapW,
        Material(
          color: AppColors.surfaceDark.withValues(alpha: 0.85),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppScale.r(14)),
            side: const BorderSide(color: AppColors.glassBorder),
          ),
          child: InkWell(
            onTap: () => _openMenu(context),
            borderRadius: BorderRadius.circular(AppScale.r(14)),
            child: Padding(
              padding: EdgeInsets.all(AppScale.r(12)),
              child: AppFaIcon(
                AppIcons.menu,
                color: AppColors.textPrimary,
                size: AppScale.icon(22),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openMenu(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppScale.r(24)),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: EdgeInsets.fromLTRB(
                AppScale.w(20),
                AppScale.h(12),
                AppScale.w(20),
                AppScale.h(28),
              ),
              decoration: BoxDecoration(
                color: AppColors.glassFill,
                border: Border(top: BorderSide(color: AppColors.glassBorder)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppScale.w(42),
                    height: AppScale.h(4),
                    margin: EdgeInsets.only(bottom: AppScale.h(12)),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: AppScale.h(16),
                      top: AppScale.h(8),
                    ),
                    child: Text(
                      'NAVIGATION',
                      style: AppTextStyles.mono12.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  ...items.map((item) {
                    final isActive = activeSection == item.section;
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppScale.h(8)),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          onTap(item.section);
                        },
                        borderRadius: BorderRadius.circular(AppScale.r(14)),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppScale.w(16),
                            vertical: AppScale.h(14),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppScale.r(14)),
                            gradient: isActive
                                ? LinearGradient(
                                    colors: [
                                      AppColors.primary.withValues(alpha: 0.15),
                                      AppColors.accent.withValues(alpha: 0.15),
                                    ],
                                  )
                                : null,
                            color: isActive
                                ? null
                                : AppColors.surfaceDark.withValues(alpha: 0.5),
                            border: Border.all(
                              color: isActive
                                  ? AppColors.accent.withValues(alpha: 0.35)
                                  : AppColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              AppFaIcon(
                                item.icon,
                                size: AppScale.icon(18),
                                color: isActive
                                    ? AppColors.accent
                                    : AppColors.textSecondary,
                              ),
                              Spacing.s12.gapW,
                              Text(
                                item.label,
                                style: AppTextStyles.m16.copyWith(
                                  color: isActive
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                  fontWeight: isActive
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              if (isActive)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.accent,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.accent,
                                        blurRadius: 6,
                                        spreadRadius: 1.5,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
