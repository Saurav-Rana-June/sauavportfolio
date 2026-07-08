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

class PortfolioNavbar extends StatelessWidget {
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

  static final _navItems = [
    _NavItem(PortfolioNavSection.about, 'About', AppIcons.about),
    _NavItem(PortfolioNavSection.projects, 'Projects', AppIcons.projects),
    _NavItem(PortfolioNavSection.contact, 'Contact', AppIcons.contact),
  ];

  @override
  Widget build(BuildContext context) {
    final isCompact = !AppScale.isDesktop;

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
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: const [
              BoxShadow(
                color: AppColors.glowPrimary,
                blurRadius: 32,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              _BrandLockup(showSubtitle: !isCompact),
              const Spacer(),
              if (!isCompact) ...[
                _DesktopNavRail(
                  activeSection: activeSection,
                  items: _navItems,
                  onTap: _resolveTap,
                ),
                Spacing.s12.gapW,
                _ContactPill(
                  isActive: activeSection == PortfolioNavSection.contact,
                  onTap: onContactTap,
                ),
              ] else
                _MobileNavMenu(
                  activeSection: activeSection,
                  items: _navItems,
                  onTap: _resolveTap,
                  onContactTap: onContactTap,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _resolveTap(PortfolioNavSection section) {
    switch (section) {
      case PortfolioNavSection.home:
        onLogoTap();
      case PortfolioNavSection.about:
        onAboutTap();
      case PortfolioNavSection.projects:
        onProjectsTap();
      case PortfolioNavSection.contact:
        onContactTap();
    }
  }
}

class _NavItem {
  const _NavItem(this.section, this.label, this.icon);

  final PortfolioNavSection section;
  final String label;
  final IconData icon;
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup({this.showSubtitle = true});

  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppScale.w(6), vertical: AppScale.h(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: AppScale.icon(38),
            height: AppScale.icon(38),
            child: SvgPicture.asset(
              'assets/images/logo.svg',
              fit: BoxFit.contain,
            ),
          ),
          Spacing.s10.gapW,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Saurav',
                style: AppTextStyles.sb18,
              ),
              if (showSubtitle)
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

class _NavPillLinkState extends State<_NavPillLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final highlight = widget.isActive || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.symmetric(horizontal: AppScale.w(2)),
        decoration: BoxDecoration(
          gradient: widget.isActive
              ? const LinearGradient(
                  colors: [Color(0x338B5CF6), Color(0x3306B6D4)],
                )
              : null,
          color: widget.isActive
              ? null
              : _isHovered
                  ? AppColors.cardDark.withValues(alpha: 0.8)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: widget.isActive ? Border.all(color: AppColors.primary.withValues(alpha: 0.35)) : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(999),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppScale.w(14), vertical: AppScale.h(10)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppFaIcon(
                    widget.icon,
                    size: AppScale.icon(16),
                    color: highlight ? AppColors.primaryLight : AppColors.textSecondary,
                  ),
                  Spacing.s8.gapW,
                  Text(
                    widget.label,
                    style: AppTextStyles.r14.copyWith(
                      color: highlight ? AppColors.textPrimary : AppColors.textSecondary,
                      fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
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

class _ContactPillState extends State<_ContactPill> with TickerProviderStateMixin {
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
                    color: AppColors.primary.withValues(alpha: 0.2 + (hoverVal * 0.25)),
                    blurRadius: 10 + (hoverVal * 15),
                    offset: const Offset(0, 4),
                  ),
                  if (hoverVal > 0)
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: hoverVal * 0.25),
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
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.height / 2));

    final paintBg = Paint();

    // Base background: translucent dark gray
    paintBg.color = AppColors.glassFill.withValues(alpha: AppColors.glassFill.a * (1.0 - hoverProgress));
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
        ..shader = LinearGradient(
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
        _ContactPill(
          isActive: activeSection == PortfolioNavSection.contact,
          onTap: onContactTap,
        ),
        Spacing.s8.gapW,
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
              child: AppFaIcon(AppIcons.menu, color: AppColors.textPrimary, size: AppScale.icon(22)),
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppScale.r(24))),
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
                    margin: EdgeInsets.only(bottom: AppScale.h(18)),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  ...items.map((item) {
                    final isActive = activeSection == item.section;
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppScale.h(8)),
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          onTap(item.section);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppScale.r(14)),
                          side: BorderSide(
                            color: isActive ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border,
                          ),
                        ),
                        tileColor: isActive
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : AppColors.surfaceDark.withValues(alpha: 0.5),
                        leading: AppFaIcon(
                          item.icon,
                          size: AppScale.icon(18),
                          color: isActive ? AppColors.primaryLight : AppColors.textSecondary,
                        ),
                        title: Text(
                          item.label,
                          style: AppTextStyles.m16.copyWith(
                            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                          ),
                        ),
                        trailing: isActive
                            ? Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : null,
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
