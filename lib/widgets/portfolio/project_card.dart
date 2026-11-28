import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/data/models/portfolio/project.model.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_icons.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/presentation/home/controllers/home.controller.dart';
import 'package:saurav_portfolio/widgets/icons/app_fa_icon.dart';
import 'package:saurav_portfolio/widgets/portfolio/in_development_badge.dart';

/// Renders an individual project card with cyber aesthetics, glowing hover
/// effects, proportional banner scaling, and content-driven vertical layout.
class ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const ProjectCard({super.key, required this.project, required this.onTap});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _hoverController;
  late final AnimationController _borderController;
  late final Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _hoverAnimation = CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _borderController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
      _borderController.repeat();
    } else {
      _hoverController.reverse();
      _borderController.stop();
      _borderController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final homeController = Get.find<HomeController>();
    const Color themeColor = AppColors.accent;

    final hasPlayStore =
        project.playStoreUrl != null && project.playStoreUrl != '#';
    final hasAppStore =
        project.appStoreUrl != null && project.appStoreUrl != '#';
    final isPlayStoreLink =
        hasPlayStore &&
        project.playStoreUrl!.toLowerCase().contains('play.google.com');
    final isAppStoreLink =
        hasAppStore &&
        (project.appStoreUrl!.toLowerCase().contains('apple.com') ||
            project.appStoreUrl!.toLowerCase().contains('apps.apple.com'));

    final isPubDev =
        project.liveUrl != null && project.liveUrl!.contains('pub.dev');
    final isSvgBanner =
        project.bannerAsset != null && project.bannerAsset!.endsWith('.svg');
    final hasRasterBanner =
        project.bannerAsset != null && !project.bannerAsset!.endsWith('.svg');

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: AnimatedBuilder(
          animation: Listenable.merge([_hoverAnimation, _borderController]),
          builder: (context, child) {
            final hoverVal = _hoverAnimation.value;
            final double cardScale = 1.0 + (hoverVal * 0.015);

            return Transform.scale(
              scale: cardScale,
              child: CustomPaint(
                foregroundPainter: _BorderFlowPainter(
                  hoverProgress: hoverVal,
                  flowProgress: _borderController.value,
                  color: themeColor,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color.lerp(
                        AppColors.border.withValues(alpha: 0.6),
                        themeColor.withValues(alpha: 0.5),
                        hoverVal,
                      )!,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                      if (hoverVal > 0)
                        BoxShadow(
                          color:
                              themeColor.withValues(alpha: hoverVal * 0.12),
                          blurRadius: 22,
                          offset: const Offset(0, 6),
                        ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: widget.onTap,
                      borderRadius: BorderRadius.circular(16),
                      hoverColor: Colors.transparent,
                      splashColor: themeColor.withValues(alpha: 0.08),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Feature Graphic / Banner Header (proportional 2.05:1 ratio matching 1024x500 standard)
                          AspectRatio(
                            aspectRatio: 2.05,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Banner media
                                ClipRect(
                                  child: Transform.scale(
                                    scale: 1.0 + (hoverVal * 0.04),
                                    child: hasRasterBanner
                                        ? Image.asset(
                                            project.bannerAsset!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder: (_, __, ___) =>
                                                _buildFallbackBanner(
                                                    themeColor),
                                          )
                                        : (isSvgBanner
                                            ? _buildSvgOrCustomBanner(
                                                project, themeColor)
                                            : _buildFallbackBanner(
                                                themeColor)),
                                  ),
                                ),

                                // Bottom shadow gradient overlay
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.25),
                                          Colors.transparent,
                                          AppColors.cardDark
                                              .withValues(alpha: 0.85),
                                          AppColors.cardDark,
                                        ],
                                        stops: const [0.0, 0.4, 0.85, 1.0],
                                      ),
                                    ),
                                  ),
                                ),

                                // Status / Type Badge (Top-Left)
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child:
                                      _buildStatusBadge(project, isPubDev),
                                ),

                                // Action Buttons (Top-Right)
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.scaffoldDark
                                          .withValues(alpha: 0.75),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white
                                            .withValues(alpha: 0.12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (hasPlayStore) ...[
                                          _ActionIconButton(
                                            icon: isPlayStoreLink
                                                ? AppIcons.googlePlay
                                                : AppIcons.android,
                                            onTap: () => homeController
                                                .openExternalLink(
                                                    project.playStoreUrl),
                                            accentColor: themeColor,
                                            tooltip: 'Get on Play Store',
                                          ),
                                          const SizedBox(width: 4),
                                        ],
                                        if (hasAppStore) ...[
                                          _ActionIconButton(
                                            icon: isAppStoreLink
                                                ? AppIcons.ios
                                                : AppIcons.apple,
                                            onTap: () => homeController
                                                .openExternalLink(
                                                    project.appStoreUrl),
                                            accentColor: themeColor,
                                            tooltip: 'Get on App Store',
                                          ),
                                          const SizedBox(width: 4),
                                        ],
                                        if (isPubDev) ...[
                                          _ActionIconButton(
                                            icon: AppIcons.download,
                                            onTap: () => homeController
                                                .openExternalLink(
                                                    project.liveUrl),
                                            accentColor: themeColor,
                                            tooltip: 'View on Pub.dev',
                                          ),
                                          const SizedBox(width: 4),
                                        ],
                                        if (project.showCode &&
                                            project.githubUrl != null &&
                                            project.githubUrl != '#') ...[
                                          _ActionIconButton(
                                            icon: AppIcons.github,
                                            onTap: () => homeController
                                                .openExternalLink(
                                                    project.githubUrl),
                                            accentColor: themeColor,
                                            tooltip:
                                                'View GitHub Repository',
                                          ),
                                          const SizedBox(width: 4),
                                        ],
                                        if (project.liveUrl != null &&
                                            project.liveUrl != '#' &&
                                            !isPubDev)
                                          _ActionIconButton(
                                            icon: AppIcons.arrowExternal,
                                            onTap: () => homeController
                                                .openExternalLink(
                                                    project.liveUrl),
                                            accentColor: themeColor,
                                            tooltip: 'Launch Demo',
                                          ),
                                        if (project.scrollToTopOnClick)
                                          _ActionIconButton(
                                            icon: AppIcons.solid(
                                              FontAwesomeIcons.arrowUp,
                                            ),
                                            onTap: widget.onTap,
                                            accentColor: themeColor,
                                            tooltip: 'Back to Top',
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 2. Card Content Body (Content-driven natural height, zero empty gap, zero text clipping)
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              AppScale.w(18),
                              AppScale.h(14),
                              AppScale.w(18),
                              AppScale.h(18),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // App Icon & Title
                                Row(
                                  children: [
                                    _buildAppIcon(project, themeColor),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        project.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.sb18.copyWith(
                                          color: _isHovered
                                              ? themeColor
                                              : AppColors.textPrimary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: AppScale.font(16.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppScale.h(8)),

                                // Description (maxLines: 3, line-height: 1.45 for crisp readability)
                                Text(
                                  project.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.r14.copyWith(
                                    color: AppColors.textSecondary
                                        .withValues(alpha: 0.9),
                                    height: 1.45,
                                    fontSize: AppScale.font(13),
                                  ),
                                ),
                                SizedBox(height: AppScale.h(18)),

                                // Tags / Labels
                                if (project.tags.isNotEmpty)
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: project.tags.take(3).map((tag) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: themeColor
                                              .withValues(alpha: 0.08),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: themeColor
                                                .withValues(alpha: 0.2),
                                            width: 0.8,
                                          ),
                                        ),
                                        child: Text(
                                          tag,
                                          style: AppTextStyles.mono12
                                              .copyWith(
                                            color: themeColor,
                                            fontSize: AppScale.font(9.5),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                              ],
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

  Widget _buildStatusBadge(ProjectModel project, bool isPubDev) {
    if (project.isInDevelopment) {
      return const InDevelopmentBadge(compact: true);
    }

    if (isPubDev) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.scaffoldDark.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent,
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Text(
              'PUB.DEV PACKAGE',
              style: AppTextStyles.mono12.copyWith(
                color: AppColors.accent,
                fontSize: AppScale.font(8.5),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }

    final isLive =
        (project.playStoreUrl != null && project.playStoreUrl != '#') ||
        (project.appStoreUrl != null && project.appStoreUrl != '#');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.scaffoldDark.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLive
              ? AppColors.success.withValues(alpha: 0.4)
              : AppColors.accent.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLive ? AppColors.success : AppColors.accent,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isLive ? 'LIVE ON STORE' : 'WEB PLATFORM',
            style: AppTextStyles.mono12.copyWith(
              color: isLive ? AppColors.success : AppColors.accent,
              fontSize: AppScale.font(8.5),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppIcon(ProjectModel project, Color themeColor) {
    final isScenarioKit = project.title.toLowerCase().contains('scenariokit');

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: themeColor.withValues(alpha: 0.3),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: isScenarioKit
            ? Center(
                child: AppFaIcon(
                  AppIcons.solid(FontAwesomeIcons.cubes),
                  color: themeColor,
                  size: 15,
                ),
              )
            : (project.imageUrl != null
                ? (project.imageUrl!.endsWith('.svg')
                    ? Padding(
                        padding: const EdgeInsets.all(5),
                        child: SvgPicture.asset(
                          project.imageUrl!,
                          fit: BoxFit.contain,
                        ),
                      )
                    : Image.asset(
                        project.imageUrl!,
                        fit: BoxFit.cover,
                      ))
                : Center(
                    child: AppFaIcon(
                      AppIcons.folder,
                      color: themeColor,
                      size: 14,
                    ),
                  )),
      ),
    );
  }

  Widget _buildSvgOrCustomBanner(ProjectModel project, Color themeColor) {
    if (project.title.toLowerCase().contains('scenariokit')) {
      // Custom Cyber DevTools Package Banner
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.surfaceDark,
              const Color(0xFF131522),
              themeColor.withValues(alpha: 0.12),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: -15,
              top: -15,
              child: Opacity(
                opacity: 0.08,
                child: AppFaIcon(
                  AppIcons.solid(FontAwesomeIcons.cubes),
                  color: themeColor,
                  size: 110,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldDark.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: themeColor.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withValues(alpha: 0.25),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: AppFaIcon(
                    AppIcons.solid(FontAwesomeIcons.cubes),
                    color: themeColor,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ScenarioKit Flutter',
                  style: AppTextStyles.sb18.copyWith(
                    color: Colors.white,
                    fontSize: AppScale.font(15),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: themeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: themeColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    'v0.2.5 • Developer Toolkit',
                    style: AppTextStyles.mono12.copyWith(
                      color: themeColor,
                      fontSize: AppScale.font(9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      color: AppColors.surfaceDark,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    themeColor.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SvgPicture.asset(
            project.bannerAsset!,
            width: 70,
            height: 70,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackBanner(Color themeColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.surfaceDark,
            themeColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: AppFaIcon(
          AppIcons.folder,
          color: themeColor.withValues(alpha: 0.4),
          size: 40,
        ),
      ),
    );
  }
}

class _ActionIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color accentColor;
  final String? tooltip;

  const _ActionIconButton({
    required this.icon,
    required this.onTap,
    required this.accentColor,
    this.tooltip,
  });

  @override
  State<_ActionIconButton> createState() => _ActionIconButtonState();
}

class _ActionIconButtonState extends State<_ActionIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final button = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: _isHovered
                  ? widget.accentColor.withValues(alpha: 0.25)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: AppFaIcon(
              widget.icon,
              color: _isHovered ? Colors.white : AppColors.textSecondary,
              size: AppScale.icon(13),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }
    return button;
  }
}

class _BorderFlowPainter extends CustomPainter {
  final double hoverProgress;
  final double flowProgress;
  final Color color;

  _BorderFlowPainter({
    required this.hoverProgress,
    required this.flowProgress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (hoverProgress == 0) return;

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(16));

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: 3.14159 * 2,
        transform: GradientRotation(flowProgress * 3.14159 * 2),
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: hoverProgress * 0.9),
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _BorderFlowPainter oldDelegate) {
    return oldDelegate.hoverProgress != hoverProgress ||
        oldDelegate.flowProgress != flowProgress ||
        oldDelegate.color != color;
  }
}
