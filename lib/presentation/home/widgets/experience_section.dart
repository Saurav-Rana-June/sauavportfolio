import 'package:flutter/material.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/data/models/portfolio/experience.model.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_icons.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/widgets/icons/app_fa_icon.dart';

/// Renders the professional career journey timeline.
/// Cache-optimized with AutomaticKeepAliveClientMixin.
class ExperienceSection extends StatefulWidget {
  final List<ExperienceModel> experiences;

  const ExperienceSection({super.key, required this.experiences});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                'EXPERIENCE',
                style: AppTextStyles.mono12.copyWith(
                  color: AppColors.accent,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                  fontSize: AppScale.font(10),
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'Career Journey',
                style: AppTextStyles.b32.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'My professional path in mobile development',
                style: AppTextStyles.r14.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: AppScale.font(14),
                ),
              ),
              AppScale.h(48).gapH,
              _buildTimeline(widget.experiences),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline(List<ExperienceModel> experiences) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: experiences.length,
      itemBuilder: (context, index) {
        final exp = experiences[index];
        final isLast = index == experiences.length - 1;
        final isActive = index == 0;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TimelineNodeIndicator(isLast: isLast, isActive: isActive),
              AppScale.w(Spacing.s24).gapW,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: AppScale.h(24)),
                  child: _ExperienceCard(experience: exp),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A node indicator in the timeline. If active, it renders a pulsing ripple.
/// Performance-optimized to pause tickers when off-screen.
class _TimelineNodeIndicator extends StatelessWidget {
  final bool isLast;
  final bool isActive;

  const _TimelineNodeIndicator({required this.isLast, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (!isLast)
            Positioned(
              top: 8,
              bottom: 0,
              child: Container(
                width: 2.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      isActive
                          ? AppColors.accent
                          : AppColors.primary.withValues(alpha: 0.3),
                      AppColors.primary.withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            top: 4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.scaffoldDark,
                    border: Border.all(
                      color: isActive
                          ? AppColors.accent
                          : AppColors.primary.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isActive ? AppColors.accent : AppColors.primary)
                            .withValues(alpha: isActive ? 0.3 : 0.1),
                        blurRadius: isActive ? 8 : 4,
                        spreadRadius: isActive ? 1 : 0,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? AppColors.accent
                        : AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final ExperienceModel experience;

  const _ExperienceCard({required this.experience});

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverController;
  late final Animation<double> _hoverAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _hoverAnimation = CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final exp = widget.experience;
    final Color themeColor = exp.isRemote
        ? AppColors.accent
        : AppColors.primaryLight;

    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedBuilder(
        animation: _hoverAnimation,
        builder: (context, child) {
          final hoverVal = _hoverAnimation.value;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(AppScale.w(24)),
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.surfaceDark.withValues(alpha: 0.6)
                  : AppColors.surfaceDark.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Color.lerp(
                  AppColors.border.withValues(alpha: 0.5),
                  themeColor.withValues(alpha: 0.4),
                  hoverVal,
                )!,
                width: 1.5,
              ),
              boxShadow: [
                if (hoverVal > 0)
                  BoxShadow(
                    color: themeColor.withValues(alpha: hoverVal * 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: CustomPaint(
              painter: _CardTechBorderPainter(
                hoverProgress: hoverVal,
                color: themeColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppFaIcon(
                        AppIcons.calendar,
                        color: themeColor,
                        size: AppScale.icon(12),
                      ),
                      AppScale.w(Spacing.s8).gapW,
                      Text(
                        exp.period.toUpperCase(),
                        style: AppTextStyles.mono12.copyWith(
                          color: themeColor,
                          fontWeight: FontWeight.w700,
                          fontSize: AppScale.font(10),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  AppScale.h(Spacing.s12).gapH,
                  Text(
                    exp.role,
                    style: AppTextStyles.sb18.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: AppScale.font(18),
                    ),
                  ),
                  AppScale.h(Spacing.s8).gapH,
                  Wrap(
                    spacing: AppScale.w(12),
                    runSpacing: AppScale.h(8),
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        exp.company,
                        style: AppTextStyles.m16.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: AppScale.font(14),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppScale.w(10),
                          vertical: AppScale.h(4),
                        ),
                        decoration: BoxDecoration(
                          color: exp.isRemote
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.border.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(AppScale.r(20)),
                          border: Border.all(
                            color: exp.isRemote
                                ? AppColors.primary.withValues(alpha: 0.2)
                                : AppColors.border.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppFaIcon(
                              exp.isRemote
                                  ? AppIcons.remote
                                  : AppIcons.location,
                              color: exp.isRemote
                                  ? AppColors.primaryLight
                                  : AppColors.textSecondary,
                              size: AppScale.icon(10),
                            ),
                            AppScale.w(6).gapW,
                            Text(
                              exp.location.toUpperCase(),
                              style: AppTextStyles.mono12.copyWith(
                                color: exp.isRemote
                                    ? AppColors.primaryLight
                                    : AppColors.textSecondary,
                                fontSize: AppScale.font(8),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppScale.h(Spacing.s16).gapH,
                  Text(
                    exp.description,
                    style: AppTextStyles.r14.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.9),
                      height: 1.6,
                      fontSize: AppScale.font(13.5),
                    ),
                  ),
                  if (exp.skills.isNotEmpty) ...[
                    AppScale.h(Spacing.s24).gapH,
                    Wrap(
                      spacing: AppScale.w(8),
                      runSpacing: AppScale.h(8),
                      children: exp.skills.map((skill) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppScale.w(10),
                            vertical: AppScale.h(4),
                          ),
                          decoration: BoxDecoration(
                            color: themeColor.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: themeColor.withValues(alpha: 0.15),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            skill,
                            style: AppTextStyles.mono12.copyWith(
                              color: Color.lerp(
                                AppColors.textSecondary,
                                themeColor,
                                0.7,
                              ),
                              fontSize: AppScale.font(9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CardTechBorderPainter extends CustomPainter {
  final double hoverProgress;
  final Color color;

  _CardTechBorderPainter({required this.hoverProgress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (hoverProgress == 0) return;

    final paint = Paint()
      ..color = color.withValues(alpha: hoverProgress * 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const double offset = 1.0;
    const double lineLength = 12.0;

    // Top-Right
    canvas.drawLine(
      Offset(size.width - offset - lineLength, offset),
      Offset(size.width - offset, offset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - offset, offset),
      Offset(size.width - offset, offset + lineLength),
      paint,
    );

    // Bottom-Right
    canvas.drawLine(
      Offset(size.width - offset - lineLength, size.height - offset),
      Offset(size.width - offset, size.height - offset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - offset, size.height - offset - lineLength),
      Offset(size.width - offset, size.height - offset),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CardTechBorderPainter oldDelegate) {
    return oldDelegate.hoverProgress != hoverProgress ||
        oldDelegate.color != color;
  }
}
