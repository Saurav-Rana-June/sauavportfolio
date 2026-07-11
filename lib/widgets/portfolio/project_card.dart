import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/data/models/portfolio/project.model.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_icons.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/presentation/home/controllers/home.controller.dart';
import 'package:saurav_portfolio/widgets/icons/app_fa_icon.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
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
    final project = widget.project;
    final homeController = Get.find<HomeController>();
    final Color themeColor = AppColors.accent;

    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedBuilder(
        animation: _hoverAnimation,
        builder: (context, child) {
          final hoverVal = _hoverAnimation.value;
          final double cardScale = 1.0 + (hoverVal * 0.02);

          return Transform.scale(
            scale: cardScale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomPaint(
                  painter: _ProjectCardPainter(
                    hoverProgress: hoverVal,
                    color: themeColor,
                  ),
                  child: InkWell(
                    onTap: widget.onTap,
                    borderRadius: BorderRadius.circular(16),
                    hoverColor: Colors.transparent,
                    splashColor: themeColor.withValues(alpha: 0.05),
                    highlightColor: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.all(AppScale.w(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: AppScale.icon(42),
                                height: AppScale.icon(42),
                                decoration: BoxDecoration(
                                  color: _isHovered
                                      ? themeColor.withValues(alpha: 0.15)
                                      : AppColors.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _isHovered
                                        ? themeColor.withValues(alpha: 0.3)
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Center(
                                  child: AppFaIcon(
                                    AppIcons.folder,
                                    color: _isHovered ? themeColor : AppColors.textSecondary,
                                    size: AppScale.icon(18),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (project.githubUrl != null && project.githubUrl != '#')
                                    _ActionIconButton(
                                      icon: AppIcons.github,
                                      onTap: () => homeController.openExternalLink(project.githubUrl),
                                      accentColor: themeColor,
                                    ),
                                  if (project.liveUrl != null && project.liveUrl != '#') ...[
                                    Spacing.s8.gapW,
                                    _ActionIconButton(
                                      icon: AppIcons.arrowExternal,
                                      onTap: () => homeController.openExternalLink(project.liveUrl),
                                      accentColor: themeColor,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          20.0.gapH,
                          Text(
                            project.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.sb18.copyWith(
                              color: _isHovered ? themeColor : AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: AppScale.font(16),
                            ),
                          ),
                          Spacing.s8.gapH,
                          Expanded(
                            child: Text(
                              project.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.r14.copyWith(
                                color: AppColors.textSecondary.withValues(alpha: 0.9),
                                height: 1.5,
                                fontSize: AppScale.font(13),
                              ),
                            ),
                          ),
                          Spacing.s16.gapH,
                          if (project.tags.isNotEmpty)
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: project.tags.take(3).map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: themeColor.withValues(alpha: 0.03),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: themeColor.withValues(alpha: 0.15),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Text(
                                    tag,
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
                            )
                          else
                            Text(
                              project.techStack,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.mono12.copyWith(
                                color: themeColor.withValues(alpha: 0.8),
                                fontSize: AppScale.font(10),
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
        },
      ),
    );
  }
}

class _ActionIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color accentColor;

  const _ActionIconButton({
    required this.icon,
    required this.onTap,
    required this.accentColor,
  });

  @override
  State<_ActionIconButton> createState() => _ActionIconButtonState();
}

class _ActionIconButtonState extends State<_ActionIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: AppScale.icon(32),
          height: AppScale.icon(32),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: 0.1)
                : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
          ),
          child: Center(
            child: AppFaIcon(
              widget.icon,
              color: _isHovered ? widget.accentColor : AppColors.textSecondary,
              size: AppScale.icon(14),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectCardPainter extends CustomPainter {
  final double hoverProgress;
  final Color color;

  _ProjectCardPainter({
    required this.hoverProgress,
    required this.color,
  });

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

    // Top-Left
    canvas.drawLine(
      const Offset(offset, offset + lineLength),
      const Offset(offset, offset),
      paint,
    );
    canvas.drawLine(
      const Offset(offset, offset),
      const Offset(offset + lineLength, offset),
      paint,
    );

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

    // Bottom-Left
    canvas.drawLine(
      Offset(offset, size.height - offset - lineLength),
      Offset(offset, size.height - offset),
      paint,
    );
    canvas.drawLine(
      Offset(offset, size.height - offset),
      Offset(offset + lineLength, size.height - offset),
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
  bool shouldRepaint(covariant _ProjectCardPainter oldDelegate) {
    return oldDelegate.hoverProgress != hoverProgress || oldDelegate.color != color;
  }
}
