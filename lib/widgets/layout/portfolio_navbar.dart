import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
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

  static const _navItems = [
    _NavItem(PortfolioNavSection.about, 'About', Icons.person_outline_rounded),
    _NavItem(PortfolioNavSection.projects, 'Projects', Icons.auto_awesome_motion_rounded),
    _NavItem(PortfolioNavSection.contact, 'Contact', Icons.chat_bubble_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 960;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: isCompact ? 14.w : 18.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.glassFill,
            borderRadius: BorderRadius.circular(20.r),
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
              _BrandLockup(onTap: onLogoTap, showSubtitle: !isCompact),
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
  const _BrandLockup({required this.onTap, this.showSubtitle = true});

  final VoidCallback onTap;
  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34.r,
                height: 34.r,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(11.r),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.glowPrimary,
                      blurRadius: 14,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.bolt_rounded, color: Colors.white, size: 18.r),
              ),
              Spacing.s10.gapW,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Saurav',
                    style: AppTextStyles.sb18.copyWith(fontSize: 17.sp),
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
      padding: EdgeInsets.all(4.r),
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
        margin: EdgeInsets.symmetric(horizontal: 2.w),
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
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.icon,
                    size: 16.r,
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

class _ContactPillState extends State<_ContactPill> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.03 : 1,
        duration: const Duration(milliseconds: 180),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.isActive || _isHovered
                  ? [AppColors.primary, AppColors.accent]
                  : [AppColors.primary.withValues(alpha: 0.85), AppColors.accent.withValues(alpha: 0.85)],
            ),
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: _isHovered ? 0.45 : 0.28),
                blurRadius: _isHovered ? 20 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(999),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.send_rounded, color: Colors.white, size: 15.r),
                    Spacing.s8.gapW,
                    Text(
                      'Let\'s talk',
                      style: AppTextStyles.r14.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
            borderRadius: BorderRadius.circular(14.r),
            side: const BorderSide(color: AppColors.glassBorder),
          ),
          child: InkWell(
            onTap: () => _openMenu(context),
            borderRadius: BorderRadius.circular(14.r),
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 20.r),
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
              decoration: BoxDecoration(
                color: AppColors.glassFill,
                border: Border(top: BorderSide(color: AppColors.glassBorder)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42.w,
                    height: 4.h,
                    margin: EdgeInsets.only(bottom: 18.h),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  ...items.map((item) {
                    final isActive = activeSection == item.section;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          onTap(item.section);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          side: BorderSide(
                            color: isActive ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border,
                          ),
                        ),
                        tileColor: isActive
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : AppColors.surfaceDark.withValues(alpha: 0.5),
                        leading: Icon(
                          item.icon,
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
