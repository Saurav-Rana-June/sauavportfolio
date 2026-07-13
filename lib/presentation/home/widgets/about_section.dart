import 'package:flutter/material.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/data/models/portfolio/profile.model.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_icons.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/widgets/icons/app_fa_icon.dart';

/// Renders the About section containing stats cards and area-of-focus detail cards.
/// Cache-optimized with AutomaticKeepAliveClientMixin.
class AboutSection extends StatefulWidget {
  final ProfileModel? profile;

  const AboutSection({super.key, required this.profile});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bio = widget.profile?.bio ?? '';
    final location = widget.profile?.location ?? '';
    final bool showRow = !AppScale.isMobile && !AppScale.isTablet;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: AppScale.sectionPaddingVertical(),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppScale.contentMaxWidth()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'ABOUT ME',
                style: AppTextStyles.mono12.copyWith(
                  color: AppColors.accent,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                  fontSize: AppScale.font(10),
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'Who I Am',
                style: AppTextStyles.b32.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'A brief introduction about my journey as a developer',
                style: AppTextStyles.r14.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: AppScale.font(14),
                ),
              ),
              48.0.gapH,
              showRow
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 11,
                          child: _buildAboutLeftContent(bio, location),
                        ),
                        48.0.gapW,
                        Expanded(flex: 9, child: _buildAboutRightContent()),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAboutLeftContent(bio, location),
                        48.0.gapH,
                        _buildAboutRightContent(),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutLeftContent(String bio, String location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bio,
          style: AppTextStyles.r16.copyWith(
            height: 1.8,
            color: AppColors.textSecondary,
            fontSize: AppScale.font(15),
          ),
        ),
        Spacing.s16.gapH,
        Row(
          children: [
            AppFaIcon(
              AppIcons.location,
              color: AppColors.accent,
              size: AppScale.icon(16),
            ),
            Spacing.s8.gapW,
            Text(
              location,
              style: AppTextStyles.r14.copyWith(
                color: AppColors.textSecondary,
                fontSize: AppScale.font(13),
              ),
            ),
          ],
        ),
        Spacing.s32.gapH,
        LayoutBuilder(
          builder: (context, constraints) {
            final double cardWidth = (constraints.maxWidth - 32) / 3;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: cardWidth.clamp(140.0, double.infinity),
                  child: const _AboutStatCard(value: '2+', label: 'YEARS EXP'),
                ),
                SizedBox(
                  width: cardWidth.clamp(140.0, double.infinity),
                  child: const _AboutStatCard(
                    value: '15+',
                    label: 'PROJECTS BUILT',
                  ),
                ),
                SizedBox(
                  width: cardWidth.clamp(140.0, double.infinity),
                  child: const _AboutStatCard(
                    value: '25K+',
                    label: 'USERS IMPACTED',
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAboutRightContent() {
    return Column(
      children: [
        _AboutFocusCard(
          icon: AppIcons.mobile,
          title: 'Cross-Platform Development',
          description:
              'Building beautiful, native-quality mobile apps for both iOS and Android using Flutter and Dart.',
          highlightColor: AppColors.accent,
        ),
        _AboutFocusCard(
          icon: AppIcons.projects,
          title: 'Clean Architecture',
          description:
              'Applying SOLID principles and clean architecture patterns for scalable, maintainable codebases.',
          highlightColor: AppColors.primaryLight,
        ),
        _AboutFocusCard(
          icon: AppIcons.bolt,
          title: 'Performance Focused',
          description:
              'Optimizing app performance with efficient state management and responsive adaptive UI design.',
          highlightColor: AppColors.success,
        ),
      ],
    );
  }
}

class _AboutStatCard extends StatefulWidget {
  final String value;
  final String label;

  const _AboutStatCard({required this.value, required this.label});

  @override
  State<_AboutStatCard> createState() => _AboutStatCardState();
}

class _AboutStatCardState extends State<_AboutStatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.surfaceDark.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.border.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.value,
              style: AppTextStyles.b32.copyWith(
                color: AppColors.primaryLight,
                fontWeight: FontWeight.w800,
              ),
            ),
            Spacing.s8.gapH,
            Text(
              widget.label,
              style: AppTextStyles.mono12.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.8),
                fontSize: AppScale.font(10),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutFocusCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color highlightColor;

  const _AboutFocusCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.highlightColor,
  });

  @override
  State<_AboutFocusCard> createState() => _AboutFocusCardState();
}

class _AboutFocusCardState extends State<_AboutFocusCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.surfaceDark.withValues(alpha: 0.7)
              : AppColors.surfaceDark.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? widget.highlightColor.withValues(alpha: 0.4)
                : AppColors.border.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: widget.highlightColor.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isHovered
                    ? widget.highlightColor.withValues(alpha: 0.15)
                    : AppColors.scaffoldDark.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isHovered
                      ? widget.highlightColor.withValues(alpha: 0.3)
                      : AppColors.border,
                ),
              ),
              child: AppFaIcon(
                widget.icon,
                color: _isHovered
                    ? widget.highlightColor
                    : AppColors.textSecondary,
                size: AppScale.icon(18),
              ),
            ),
            Spacing.s16.gapW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: AppTextStyles.sb18.copyWith(
                      color: _isHovered
                          ? widget.highlightColor
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: AppScale.font(16),
                    ),
                  ),
                  6.0.gapH,
                  Text(
                    widget.description,
                    style: AppTextStyles.r14.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
