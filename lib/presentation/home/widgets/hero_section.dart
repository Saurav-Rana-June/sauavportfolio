import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/data/models/portfolio/profile.model.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_icons.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/presentation/home/controllers/home.controller.dart';
import 'package:saurav_portfolio/widgets/animations/animated_typing_text.dart';
import 'package:saurav_portfolio/widgets/buttons/primary_button.dart';
import 'package:saurav_portfolio/widgets/buttons/secondary_button.dart';
import 'package:saurav_portfolio/widgets/icons/app_fa_icon.dart';
import 'package:saurav_portfolio/widgets/layout/portfolio_nav_section.dart';

/// Renders the primary landing view of the portfolio, including name, title typing animations,
/// social links, and the pulsing, rotating futuristic HUD illustration.
/// Cache-optimized with AutomaticKeepAliveClientMixin.
class HeroSection extends StatefulWidget {
  final ProfileModel? profile;

  const HeroSection({super.key, required this.profile});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = Get.find<HomeController>();
    final name = widget.profile?.name ?? 'Saurav Rana';
    final title = widget.profile?.title ?? '';
    final showRow = AppScale.isDesktop;

    return FuturisticBackground(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: AppScale.pagePaddingHorizontal(),
          right: AppScale.pagePaddingHorizontal(),
          top: AppScale.heroPaddingVertical(),
          bottom: AppScale.sectionPaddingVertical(),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppScale.contentMaxWidth()),
            child: showRow
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._buildHeroLeftContent(controller, name, title),
                            AppScale.h(Spacing.s32).gapH,
                            _buildSocialMediaSection(
                              controller,
                              widget.profile,
                            ),
                          ],
                        ),
                      ),
                      AppScale.w(Spacing.s24).gapW,
                      const Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FuturisticIllustration(),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: FuturisticIllustration()),
                      AppScale.h(Spacing.s24).gapH,
                      ..._buildHeroLeftContent(controller, name, title),
                      AppScale.h(Spacing.s32).gapH,
                      _buildSocialMediaSection(controller, widget.profile),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection(
    HomeController controller,
    ProfileModel? profile,
  ) {
    if (profile == null) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'FIND ME ON //',
          style: AppTextStyles.mono12.copyWith(
            color: AppColors.textSecondary.withValues(alpha: 0.6),
            letterSpacing: 2.0,
            fontWeight: FontWeight.w700,
            fontSize: AppScale.font(10),
          ),
        ),
        AppScale.w(Spacing.s16).gapW,
        if (profile.githubUrl != null &&
            profile.githubUrl!.isNotEmpty &&
            profile.githubUrl != '#') ...[
          _SocialIconButton(
            icon: AppIcons.github,
            label: 'GITHUB',
            onPressed: () => controller.openExternalLink(profile.githubUrl),
          ),
          AppScale.w(Spacing.s8).gapW,
        ],
        if (profile.linkedInUrl != null &&
            profile.linkedInUrl!.isNotEmpty &&
            profile.linkedInUrl != '#') ...[
          _SocialIconButton(
            icon: AppIcons.linkedin,
            label: 'LINKEDIN',
            onPressed: () => controller.openExternalLink(profile.linkedInUrl),
          ),
          AppScale.w(Spacing.s8).gapW,
        ],
        _SocialIconButton(
          icon: AppIcons.mail,
          label: 'EMAIL',
          onPressed: () =>
              controller.openExternalLink('mailto:${profile.email}'),
        ),
      ],
    );
  }

  List<Widget> _buildHeroLeftContent(
    HomeController controller,
    String name,
    String title,
  ) {
    return [
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppScale.w(8),
          vertical: AppScale.h(3.5),
        ),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppScale.r(20)),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PulsingStatusDot(color: AppColors.success),
            AppScale.w(6).gapW,
            Text(
              'AVAILABLE ',
              style: AppTextStyles.mono12.copyWith(
                color: AppColors.success,
                fontSize: AppScale.font(10),
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      AppScale.h(Spacing.s16).gapH,
      Text(
        'Hi, I\'m',
        style: AppTextStyles.r16.copyWith(
          color: AppColors.accent,
          fontWeight: FontWeight.w500,
        ),
      ),
      AppScale.h(Spacing.s8).gapH,
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Colors.white, AppColors.accent, AppColors.primaryLight],
        ).createShader(bounds),
        child: Text(
          name,
          style: AppTextStyles.b48.copyWith(
            fontSize: AppScale.isMobile
                ? 42
                : AppScale.isTablet
                ? 54
                : 60,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      AppScale.h(Spacing.s12).gapH,
      AnimatedTypingText(
        texts: [
          title.isNotEmpty ? title : 'Senior Flutter Developer',
          'UI/UX & Figma Enthusiast',
          'FastAPI Learner',
          'Cross-Platform Apps Developer',
        ],
        style: AppTextStyles.sb24.copyWith(
          color: AppColors.primaryLight,
          fontWeight: FontWeight.w600,
        ),
      ),
      AppScale.h(Spacing.s24).gapH,
      Text(
        'Passionate Flutter Engineer with 2.5+ years of experience building high-performance cross-platform apps. Skilled in Flutter, Figma-to-Flutter development, and UI/UX principles, with a focus on clean, scalable, and pixel-perfect applications. Currently learning FastAPI to strengthen my backend development skills.',
        style: AppTextStyles.r16.copyWith(
          color: AppColors.textSecondary,
          height: 1.6,
          fontSize: AppScale.font(15),
        ),
      ),
      AppScale.h(Spacing.s32).gapH,
      Wrap(
        spacing: AppScale.w(16),
        runSpacing: AppScale.h(12),
        children: [
          PrimaryButton(
            label: 'View Projects',
            onPressed: () => controller.scrollToSection(
              controller.projectsSectionKey,
              PortfolioNavSection.projects,
            ),
            icon: AppIcons.work,
          ),
          SecondaryButton(
            label: 'Contact Me',
            onPressed: () => controller.scrollToSection(
              controller.contactSectionKey,
              PortfolioNavSection.contact,
            ),
            icon: AppIcons.mail,
          ),
          SecondaryButton(
            label: 'Review CV',
            onPressed: () => controller.downloadCv(),
            icon: AppIcons.resume,
          ),
        ],
      ),
    ];
  }
}

/// Renders a futuristic dynamic background utilizing CustomPaint.
/// Pauses painting animations automatically when off-screen to improve mobile runtime frame times.
class FuturisticBackground extends StatefulWidget {
  const FuturisticBackground({super.key, required this.child});

  final Widget child;

  @override
  State<FuturisticBackground> createState() => _FuturisticBackgroundState();
}

class _FuturisticBackgroundState extends State<FuturisticBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  HomeController? _homeController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _controller.repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        _homeController = Get.find<HomeController>();
        _homeController?.scrollController.addListener(_onScroll);
        _onScroll(); // initial check
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _homeController?.scrollController.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    try {
      final position = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.sizeOf(context).height;
      final isVisible =
          position.dy < screenHeight &&
          (position.dy + renderBox.size.height) > 0;

      if (isVisible) {
        if (!_controller.isAnimating) {
          _controller.repeat();
        }
      } else {
        if (_controller.isAnimating) {
          _controller.stop();
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _FuturisticBgPainter(
                    animationValue: _controller.value,
                  ),
                );
              },
            ),
          ),
        ),
        RepaintBoundary(child: widget.child),
      ],
    );
  }
}

class _FuturisticBgPainter extends CustomPainter {
  _FuturisticBgPainter({required this.animationValue});

  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Tech Grid drawing
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.015)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const double step = 50.0;
    final double gridOffset = (animationValue * step) % step;

    for (double x = gridOffset; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = gridOffset; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 2. Slow moving glow orbs
    final double radius1 = size.width * (AppScale.isDesktop ? 0.28 : 0.45);
    final double radius2 = size.width * (AppScale.isDesktop ? 0.32 : 0.5);
    final double radius3 = size.width * (AppScale.isDesktop ? 0.22 : 0.35);

    // Orb 1: Purple (Primary) drifting top-left to center-bottom
    final double orb1X =
        size.width * (0.3 + 0.12 * math.sin(animationValue * 2 * math.pi));
    final double orb1Y =
        size.height * (0.35 + 0.15 * math.cos(animationValue * 2 * math.pi));
    final orb1Paint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.12),
              AppColors.primary.withValues(alpha: 0.0),
            ],
          ).createShader(
            Rect.fromCircle(center: Offset(orb1X, orb1Y), radius: radius1),
          );
    canvas.drawCircle(Offset(orb1X, orb1Y), radius1, orb1Paint);

    // Orb 2: Cyan (Accent) drifting right to bottom-left
    final double orb2X =
        size.width * (0.7 + 0.12 * math.cos(animationValue * 2 * math.pi));
    final double orb2Y =
        size.height * (0.45 + 0.12 * math.sin(animationValue * 2 * math.pi));
    final orb2Paint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.accent.withValues(alpha: 0.09),
              AppColors.accent.withValues(alpha: 0.0),
            ],
          ).createShader(
            Rect.fromCircle(center: Offset(orb2X, orb2Y), radius: radius2),
          );
    canvas.drawCircle(Offset(orb2X, orb2Y), radius2, orb2Paint);

    // Orb 3: Violet (Primary Light) drifting top-center to center-right
    final double orb3X =
        size.width *
        (0.5 + 0.15 * math.sin((animationValue + 0.3) * 2 * math.pi));
    final double orb3Y =
        size.height *
        (0.25 + 0.08 * math.cos((animationValue + 0.3) * 2 * math.pi));
    final orb3Paint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.primaryLight.withValues(alpha: 0.05),
              AppColors.primaryLight.withValues(alpha: 0.0),
            ],
          ).createShader(
            Rect.fromCircle(center: Offset(orb3X, orb3Y), radius: radius3),
          );
    canvas.drawCircle(Offset(orb3X, orb3Y), radius3, orb3Paint);

    // 3. Floating particle dust
    const int particleCount = 15;
    for (int i = 0; i < particleCount; i++) {
      final double scaleX = (i * 17) % 100 / 100.0;
      final double scaleY = (i * 23) % 100 / 100.0;
      final double speedFactor = 0.8 + (i % 3) * 0.4;

      final double px =
          (scaleX * size.width +
              (math.sin(animationValue * 2 * math.pi * speedFactor + i) * 12)) %
          size.width;
      final double py =
          (scaleY * size.height -
              (animationValue * size.height * 0.25 * speedFactor)) %
          size.height;

      final double opacity =
          0.12 +
          0.12 * math.sin(animationValue * 2 * math.pi * speedFactor + i);
      final double pRadius = 1.2 + (i % 3) * 0.6;

      final pPaint = Paint()
        ..color = (i % 2 == 0 ? AppColors.accent : AppColors.primaryLight)
            .withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(px, py), pRadius, pPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FuturisticBgPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// A rotating HUD visual illustration showcasing central logo and orbiting tech tags.
/// Performance-optimized to pause tickers when off-screen.
class FuturisticIllustration extends StatefulWidget {
  const FuturisticIllustration({super.key});

  @override
  State<FuturisticIllustration> createState() => _FuturisticIllustrationState();
}

class _FuturisticIllustrationState extends State<FuturisticIllustration>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  HomeController? _homeController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    );
    _rotationController.repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOutSine,
    );
    _pulseController.repeat(reverse: true);

    try {
      _homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    } catch (_) {}

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        _homeController ??= Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
        _homeController?.scrollController.addListener(_onScroll);
        _onScroll(); // initial check
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _homeController?.scrollController.removeListener(_onScroll);
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    try {
      final position = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.sizeOf(context).height;
      final isVisible =
          position.dy < screenHeight &&
          (position.dy + renderBox.size.height) > 0;

      if (isVisible) {
        if (!_rotationController.isAnimating) {
          _rotationController.repeat();
        }
        if (!_pulseController.isAnimating) {
          _pulseController.repeat(reverse: true);
        }
      } else {
        if (_rotationController.isAnimating) {
          _rotationController.stop();
        }
        if (_pulseController.isAnimating) {
          _pulseController.stop();
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final double boxSize = AppScale.isMobile
        ? 280
        : AppScale.isTablet
        ? 320
        : 420;

    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. HUD Background, Cyber Sweeps & Orbiting Tech Nodes
          AnimatedBuilder(
            animation: Listenable.merge([_rotationController, _pulseAnimation]),
            builder: (context, child) {
              final double rot = _rotationController.value;
              final double pulse = _pulseAnimation.value;
              final double centerCoord = boxSize / 2;
              final double r1 = boxSize * 0.38;
              final double r2 = boxSize * 0.27;
              final double nodeSize = AppScale.isMobile ? 36.0 : 42.0;

              // Outer Orbit: Flutter & Figma (clockwise, offset by pi)
              // Seamless 1 full revolution (2*pi) per cycle
              final double angleFlutter = rot * 2 * math.pi;
              final double nodeFlutterX =
                  centerCoord + r1 * math.cos(angleFlutter) - (nodeSize / 2);
              final double nodeFlutterY =
                  centerCoord + r1 * math.sin(angleFlutter) - (nodeSize / 2);

              final double angleFigma = angleFlutter + math.pi;
              final double nodeFigmaX =
                  centerCoord + r1 * math.cos(angleFigma) - (nodeSize / 2);
              final double nodeFigmaY =
                  centerCoord + r1 * math.sin(angleFigma) - (nodeSize / 2);

              // Inner Orbit: Dart & FastAPI (counter-clockwise, offset by pi)
              // Seamless 1 full revolution (-2*pi) per cycle without jump
              final double angleDart = -(rot * 2 * math.pi) + (math.pi / 2);
              final double nodeDartX =
                  centerCoord + r2 * math.cos(angleDart) - (nodeSize / 2);
              final double nodeDartY =
                  centerCoord + r2 * math.sin(angleDart) - (nodeSize / 2);

              final double angleFastApi = angleDart + math.pi;
              final double nodeFastApiX =
                  centerCoord + r2 * math.cos(angleFastApi) - (nodeSize / 2);
              final double nodeFastApiY =
                  centerCoord + r2 * math.sin(angleFastApi) - (nodeSize / 2);

              return Stack(
                children: [
                  // Cyber HUD Canvas: trails and head beacons terminate exactly at avatar coordinates
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _IllustrationHudPainter(
                        angleFlutter: angleFlutter,
                        angleFigma: angleFigma,
                        angleDart: angleDart,
                        angleFastApi: angleFastApi,
                        rotationValue: rot,
                        pulseValue: pulse,
                      ),
                    ),
                  ),

                  // Tech Avatar Node: Flutter (Directly on top of Outer Orbit Head 1)
                  _buildOrbitNode(
                    x: nodeFlutterX,
                    y: nodeFlutterY,
                    size: nodeSize,
                    pulse: pulse,
                    color: const Color(0xFF02569B),
                    accentColor: const Color(0xFF00C4FF),
                    child: FlutterLogo(size: nodeSize * 0.52),
                  ),

                  // Tech Avatar Node: Figma (Directly on top of Outer Orbit Head 2)
                  _buildOrbitNode(
                    x: nodeFigmaX,
                    y: nodeFigmaY,
                    size: nodeSize,
                    pulse: pulse,
                    color: const Color(0xFFF24E1E),
                    accentColor: const Color(0xFFA259FF),
                    child: FigmaVectorLogo(size: nodeSize * 0.50),
                  ),

                  // Tech Avatar Node: Dart (Directly on top of Inner Orbit Head 1)
                  _buildOrbitNode(
                    x: nodeDartX,
                    y: nodeDartY,
                    size: nodeSize,
                    pulse: pulse,
                    color: const Color(0xFF007ACC),
                    accentColor: const Color(0xFF00C4FF),
                    child: DartVectorLogo(size: nodeSize * 0.48),
                  ),

                  // Tech Avatar Node: FastAPI (Directly on top of Inner Orbit Head 2)
                  _buildOrbitNode(
                    x: nodeFastApiX,
                    y: nodeFastApiY,
                    size: nodeSize,
                    pulse: pulse,
                    color: const Color(0xFF009485),
                    accentColor: const Color(0xFF05D3B4),
                    child: FastApiVectorLogo(size: nodeSize * 0.48),
                  ),
                ],
              );
            },
          ),

          // 2. Central Glassmorphic Futuristic Core with Portfolio Logo
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              final pulse = _pulseAnimation.value;
              final scale = 0.96 + (pulse * 0.08);

              final Widget podWidget = SizedBox(
                key: _homeController?.heroCentralLogoKey,
                width: boxSize * 0.32,
                height: boxSize * 0.32,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceDark.withValues(alpha: 0.85),
                      border: Border.all(
                        color: Color.lerp(
                          AppColors.primary,
                          AppColors.accent,
                          pulse,
                        )!.withValues(alpha: 0.5 + (pulse * 0.3)),
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(
                            alpha: 0.28 + (pulse * 0.25),
                          ),
                          blurRadius: 18 + (pulse * 12),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: AppColors.accent.withValues(
                            alpha: 0.22 + (pulse * 0.2),
                          ),
                          blurRadius: 30,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: boxSize * 0.24,
                        height: boxSize * 0.24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.scaffoldDark.withValues(alpha: 0.95),
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.6),
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/logo.svg',
                            width: boxSize * 0.14,
                            height: boxSize * 0.14,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );

              if (_homeController != null) {
                return Obx(() {
                  final isDocked = _homeController!.isHeroLogoDocked.value;
                  return Opacity(
                    opacity: isDocked ? 1.0 : 0.0,
                    child: podWidget,
                  );
                });
              }

              return podWidget;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrbitNode({
    required double x,
    required double y,
    required double size,
    required double pulse,
    required Color color,
    required Color accentColor,
    required Widget child,
  }) {
    final double nodeScale = 0.96 + (pulse * 0.06);

    return Positioned(
      left: x,
      top: y,
      child: Transform.scale(
        scale: nodeScale,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceDark.withValues(alpha: 0.92),
            border: Border.all(
              color: Color.lerp(
                color,
                accentColor,
                pulse,
              )!.withValues(alpha: 0.6 + (pulse * 0.25)),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35 + (pulse * 0.2)),
                blurRadius: 10 + (pulse * 4),
                spreadRadius: 1,
              ),
              BoxShadow(
                color: accentColor.withValues(alpha: 0.18),
                blurRadius: 18,
              ),
            ],
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// Advanced Futuristic HUD Painter with orbiting sweep gradients that
/// stream directly behind the 4 tech avatar heads.
class _IllustrationHudPainter extends CustomPainter {
  _IllustrationHudPainter({
    required this.angleFlutter,
    required this.angleFigma,
    required this.angleDart,
    required this.angleFastApi,
    required this.rotationValue,
    required this.pulseValue,
  });

  final double angleFlutter;
  final double angleFigma;
  final double angleDart;
  final double angleFastApi;
  final double rotationValue;
  final double pulseValue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // 1. Ambient Background Halo Bloom
    final haloPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accent.withValues(alpha: 0.12 + (pulseValue * 0.08)),
          AppColors.primary.withValues(alpha: 0.06 + (pulseValue * 0.05)),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius * 0.9));
    canvas.drawCircle(center, maxRadius * 0.9, haloPaint);

    // 2. Corner HUD Brackets
    final bracketPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.3 + (pulseValue * 0.2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final double pad = 12.0;
    final double len = 18.0;

    // Top-Left bracket
    canvas.drawPath(
      Path()
        ..moveTo(pad, pad + len)
        ..lineTo(pad, pad)
        ..lineTo(pad + len, pad),
      bracketPaint,
    );
    // Top-Right bracket
    canvas.drawPath(
      Path()
        ..moveTo(size.width - pad, pad + len)
        ..lineTo(size.width - pad, pad)
        ..lineTo(size.width - pad - len, pad),
      bracketPaint,
    );
    // Bottom-Left bracket
    canvas.drawPath(
      Path()
        ..moveTo(pad, size.height - pad - len)
        ..lineTo(pad, size.height - pad)
        ..lineTo(pad + len, size.height - pad),
      bracketPaint,
    );
    // Bottom-Right bracket
    canvas.drawPath(
      Path()
        ..moveTo(size.width - pad, size.height - pad - len)
        ..lineTo(size.width - pad, size.height - pad)
        ..lineTo(size.width - pad - len, size.height - pad),
      bracketPaint,
    );

    // 3. Segmented Crosshair Guidelines with Center Core Clearance
    final guidePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final double coreClearance = size.width * 0.18;

    // Vertical guides
    canvas.drawLine(
      Offset(center.dx, pad + len),
      Offset(center.dx, center.dy - coreClearance),
      guidePaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + coreClearance),
      Offset(center.dx, size.height - pad - len),
      guidePaint,
    );
    // Horizontal guides
    canvas.drawLine(
      Offset(pad + len, center.dy),
      Offset(center.dx - coreClearance, center.dy),
      guidePaint,
    );
    canvas.drawLine(
      Offset(center.dx + coreClearance, center.dy),
      Offset(size.width - pad - len, center.dy),
      guidePaint,
    );

    // 4. Outer Peripheral Compass Tech Ticks (24 ticks)
    final tickRadius = size.width * 0.44;
    final tickPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.5)
      ..strokeWidth = 1.0;
    final majorTickPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.6)
      ..strokeWidth = 1.5;

    for (int i = 0; i < 24; i++) {
      final double angle = i * (2 * math.pi / 24);
      final bool isCardinal = i % 6 == 0;
      final double tickLength = isCardinal ? 6.0 : 3.5;
      final p1 = Offset(
        center.dx + (tickRadius - tickLength) * math.cos(angle),
        center.dy + (tickRadius - tickLength) * math.sin(angle),
      );
      final p2 = Offset(
        center.dx + tickRadius * math.cos(angle),
        center.dy + tickRadius * math.sin(angle),
      );
      canvas.drawLine(p1, p2, isCardinal ? majorTickPaint : tickPaint);
    }

    // 5. Outer Orbit Track & Trails (r1 = size.width * 0.38, moving clockwise)
    final double r1 = size.width * 0.38;
    final ringPaint1 = Paint()
      ..color = AppColors.border.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, r1, ringPaint1);

    const double trailOuter = math.pi * 0.55; // ~100 degrees trail length

    // 5a. Flutter Arc Trail (Terminating right at Flutter Avatar Head)
    final flutterArcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: trailOuter,
        transform: GradientRotation(angleFlutter - trailOuter),
        colors: [
          Colors.transparent,
          const Color(0xFF00C4FF).withValues(alpha: 0.3),
          const Color(0xFF00C4FF),
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: r1));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r1),
      angleFlutter - trailOuter,
      trailOuter,
      false,
      flutterArcPaint,
    );

    // Glowing head beacon directly under Flutter Avatar
    final pFlutterX = center.dx + r1 * math.cos(angleFlutter);
    final pFlutterY = center.dy + r1 * math.sin(angleFlutter);
    canvas.drawCircle(
      Offset(pFlutterX, pFlutterY),
      8.0 + (pulseValue * 3.0),
      Paint()
        ..color = const Color(0xFF00C4FF).withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // 5b. Figma Arc Trail (Terminating right at Figma Avatar Head)
    final figmaArcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: trailOuter,
        transform: GradientRotation(angleFigma - trailOuter),
        colors: [
          Colors.transparent,
          const Color(0xFFA259FF).withValues(alpha: 0.3),
          const Color(0xFFF24E1E),
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: r1));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r1),
      angleFigma - trailOuter,
      trailOuter,
      false,
      figmaArcPaint,
    );

    // Glowing head beacon directly under Figma Avatar
    final pFigmaX = center.dx + r1 * math.cos(angleFigma);
    final pFigmaY = center.dy + r1 * math.sin(angleFigma);
    canvas.drawCircle(
      Offset(pFigmaX, pFigmaY),
      8.0 + (pulseValue * 3.0),
      Paint()
        ..color = const Color(0xFFF24E1E).withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // 6. Inner Orbit Track & Trails (r2 = size.width * 0.27, counter-clockwise)
    final double r2 = size.width * 0.27;
    final ringPaint2 = Paint()
      ..color = AppColors.border.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, r2, ringPaint2);

    const double trailInner = math.pi * 0.48; // ~86 degrees trail length

    // 6a. Dart Arc Trail (Streaming behind Dart Avatar Head)
    final dartArcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: trailInner,
        transform: GradientRotation(angleDart),
        colors: [
          const Color(0xFF00C4FF),
          const Color(0xFF00C4FF).withValues(alpha: 0.3),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: r2));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r2),
      angleDart,
      trailInner,
      false,
      dartArcPaint,
    );

    // Glowing head beacon directly under Dart Avatar
    final pDartX = center.dx + r2 * math.cos(angleDart);
    final pDartY = center.dy + r2 * math.sin(angleDart);
    canvas.drawCircle(
      Offset(pDartX, pDartY),
      7.0 + (pulseValue * 2.5),
      Paint()
        ..color = const Color(0xFF00C4FF).withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );

    // 6b. FastAPI Arc Trail (Streaming behind FastAPI Avatar Head)
    final fastApiArcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: trailInner,
        transform: GradientRotation(angleFastApi),
        colors: [
          const Color(0xFF05D3B4),
          const Color(0xFF009485).withValues(alpha: 0.3),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: r2));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r2),
      angleFastApi,
      trailInner,
      false,
      fastApiArcPaint,
    );

    // Glowing head beacon directly under FastAPI Avatar
    final pFastApiX = center.dx + r2 * math.cos(angleFastApi);
    final pFastApiY = center.dy + r2 * math.sin(angleFastApi);
    canvas.drawCircle(
      Offset(pFastApiX, pFastApiY),
      7.0 + (pulseValue * 2.5),
      Paint()
        ..color = const Color(0xFF05D3B4).withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );

    // 7. Intermediate Rotating Cyber Dashed Ring (r = size.width * 0.19)
    final double rCyber = size.width * 0.19;
    final cyberDashPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.3 + (pulseValue * 0.2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const int dashCount = 16;
    final double dashAngle = 2 * math.pi / dashCount;
    // Exactly 1 full cycle per rotation cycle for seamless looping
    final double dashRot = rotationValue * 2 * math.pi;
    for (int i = 0; i < dashCount; i++) {
      final double start = dashRot + (i * dashAngle);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: rCyber),
        start,
        dashAngle * 0.45,
        false,
        cyberDashPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _IllustrationHudPainter oldDelegate) {
    return oldDelegate.angleFlutter != angleFlutter ||
        oldDelegate.rotationValue != rotationValue ||
        oldDelegate.pulseValue != pulseValue;
  }
}

class DartVectorLogo extends StatelessWidget {
  const DartVectorLogo({super.key, this.size = 24.0});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _DartLogoPainter()),
    );
  }
}

class _DartLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Draw the three facets of the Dart Logo
    // 1. Top-Left facet (Light Cyan)
    final path1 = Path()
      ..moveTo(w * 0.5, h * 0.1)
      ..lineTo(w * 0.15, h * 0.5)
      ..lineTo(w * 0.5, h * 0.55)
      ..close();
    final paint1 = Paint()
      ..color = const Color(0xFF00C4FF)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path1, paint1);

    // 2. Bottom-Left facet (Medium Blue)
    final path2 = Path()
      ..moveTo(w * 0.15, h * 0.5)
      ..lineTo(w * 0.5, h * 0.9)
      ..lineTo(w * 0.5, h * 0.55)
      ..close();
    final paint2 = Paint()
      ..color = const Color(0xFF007ACC)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path2, paint2);

    // 3. Right facet (Dark Blue)
    final path3 = Path()
      ..moveTo(w * 0.5, h * 0.1)
      ..lineTo(w * 0.85, h * 0.5)
      ..lineTo(w * 0.5, h * 0.9)
      ..close();
    final paint3 = Paint()
      ..color = const Color(0xFF01579B)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FigmaVectorLogo extends StatelessWidget {
  const FigmaVectorLogo({super.key, this.size = 24.0});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _FigmaLogoPainter()),
    );
  }
}

class _FigmaLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = w * 0.14;

    // Top-Left (Orange-Red: 0xFFF24E1E)
    final paint1 = Paint()
      ..color = const Color(0xFFF24E1E)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTRB(w * 0.22, h * 0.16, w * 0.5, h * 0.44),
        topLeft: Radius.circular(r),
        bottomLeft: Radius.circular(r),
      ),
      paint1,
    );

    // Top-Right (Orange-Yellow: 0xFFFF7262)
    final paint2 = Paint()
      ..color = const Color(0xFFFF7262)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.64, h * 0.3), r, paint2);

    // Mid-Left (Purple: 0xFFA259FF)
    final paint3 = Paint()
      ..color = const Color(0xFFA259FF)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTRB(w * 0.22, h * 0.44, w * 0.5, h * 0.72),
        topLeft: Radius.circular(r),
        bottomLeft: Radius.circular(r),
      ),
      paint3,
    );

    // Mid-Right (Blue: 0xFF1ABC9C)
    final paint4 = Paint()
      ..color = const Color(0xFF1ABC9C)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.64, h * 0.58), r, paint4);

    // Bottom-Left (Green: 0xFF0ACF83)
    final paint5 = Paint()
      ..color = const Color(0xFF0ACF83)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTRB(w * 0.22, h * 0.72, w * 0.5, h * 1.0),
        topLeft: Radius.circular(r),
        bottomLeft: Radius.circular(r),
        bottomRight: Radius.circular(r),
      ),
      paint5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FastApiVectorLogo extends StatelessWidget {
  const FastApiVectorLogo({super.key, this.size = 24.0});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _FastApiLogoPainter()),
    );
  }
}

class _FastApiLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Draw Teal background circle
    final bgPaint = Paint()
      ..color = const Color(0xFF009485)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.45, bgPaint);

    // Draw bright cyan/green lightning bolt
    final path = Path()
      ..moveTo(w * 0.58, h * 0.22)
      ..lineTo(w * 0.32, h * 0.55)
      ..lineTo(w * 0.52, h * 0.55)
      ..lineTo(w * 0.42, h * 0.82)
      ..lineTo(w * 0.68, h * 0.45)
      ..lineTo(w * 0.48, h * 0.45)
      ..close();

    final boltPaint = Paint()
      ..color = const Color(0xFF05D3B4)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, boltPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A status dot that pulses.
/// Set dynamic opacity directly in Container BoxDecoration color & shadow rather than using the expensive Opacity widget.
/// Performance-optimized to pause tickers when off-screen.
class PulsingStatusDot extends StatefulWidget {
  const PulsingStatusDot({super.key, required this.color});
  final Color color;

  @override
  State<PulsingStatusDot> createState() => _PulsingStatusDotState();
}

class _PulsingStatusDotState extends State<PulsingStatusDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  HomeController? _homeController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        _homeController = Get.find<HomeController>();
        _homeController?.scrollController.addListener(_onScroll);
        _onScroll(); // initial check
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _homeController?.scrollController.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    try {
      final position = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.sizeOf(context).height;
      final isVisible =
          position.dy < screenHeight &&
          (position.dy + renderBox.size.height) > 0;

      if (isVisible) {
        if (!_controller.isAnimating) {
          _controller.repeat(reverse: true);
        }
      } else {
        if (_controller.isAnimating) {
          _controller.stop();
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity = 0.5 + (_controller.value * 0.5);
        final baseColor = widget.color.withValues(alpha: opacity);
        return Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: baseColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: opacity * 0.4),
                blurRadius: 3 + (_controller.value * 3),
                spreadRadius: 0.5 + (_controller.value * 0.5),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SocialIconButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _SocialIconButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton>
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
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _hoverAnimation,
          builder: (context, child) {
            final hoverVal = _hoverAnimation.value;
            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  if (hoverVal > 0)
                    BoxShadow(
                      color: AppColors.primaryLight.withValues(
                        alpha: hoverVal * 0.15,
                      ),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: Offset.zero,
                    ),
                ],
              ),
              child: CustomPaint(
                painter: _SocialIconButtonPainter(
                  hoverProgress: hoverVal,
                  activeColor: AppColors.primaryLight,
                  inactiveColor: AppColors.glassBorder,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppScale.w(12),
                    vertical: AppScale.h(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppFaIcon(
                        widget.icon,
                        color: Color.lerp(
                          AppColors.textSecondary,
                          AppColors.primaryLight,
                          hoverVal,
                        ),
                        size: AppScale.icon(14),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        child: SizedBox(
                          height: AppScale.icon(14),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_isHovered) ...[
                                const SizedBox(width: 8),
                                Text(
                                  widget.label,
                                  style: AppTextStyles.mono12.copyWith(
                                    color: Color.lerp(
                                      AppColors.textSecondary,
                                      AppColors.textPrimary,
                                      hoverVal,
                                    ),
                                    fontWeight: FontWeight.w700,
                                    fontSize: AppScale.font(10),
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
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

class _SocialIconButtonPainter extends CustomPainter {
  final double hoverProgress;
  final Color activeColor;
  final Color inactiveColor;

  _SocialIconButtonPainter({
    required this.hoverProgress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));

    // Fill background only on hover
    final bgPaint = Paint()
      ..color = Color.lerp(
        Colors.transparent,
        activeColor.withValues(alpha: 0.08),
        hoverProgress,
      )!;
    canvas.drawRRect(rrect, bgPaint);

    // Draw main border only on hover
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Color.lerp(
        Colors.transparent,
        activeColor.withValues(alpha: 0.25),
        hoverProgress,
      )!;
    canvas.drawRRect(rrect, borderPaint);

    // If hovered, draw glowing futuristic corner brackets!
    if (hoverProgress > 0) {
      final bracketPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = activeColor.withValues(alpha: hoverProgress * 0.7)
        ..strokeCap = StrokeCap.round;

      const offset = 2.0;
      const bracketSize = 4.0;
      final path = Path();

      // Top-Left corner bracket
      path.moveTo(-offset, bracketSize - offset);
      path.lineTo(-offset, -offset);
      path.lineTo(bracketSize - offset, -offset);

      // Top-Right corner bracket
      path.moveTo(size.width + offset - bracketSize, -offset);
      path.lineTo(size.width + offset, -offset);
      path.lineTo(size.width + offset, bracketSize - offset);

      // Bottom-Left corner bracket
      path.moveTo(-offset, size.height + offset - bracketSize);
      path.lineTo(-offset, size.height + offset);
      path.lineTo(bracketSize - offset, size.height + offset);

      // Bottom-Right corner bracket
      path.moveTo(size.width + offset - bracketSize, size.height + offset);
      path.lineTo(size.width + offset, size.height + offset);
      path.lineTo(size.width + offset, size.height + offset - bracketSize);

      canvas.drawPath(path, bracketPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SocialIconButtonPainter oldDelegate) {
    return oldDelegate.hoverProgress != hoverProgress;
  }
}
