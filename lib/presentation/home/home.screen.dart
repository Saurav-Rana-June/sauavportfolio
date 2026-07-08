import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_icons.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/presentation/home/controllers/home.controller.dart';
import 'package:saurav_portfolio/widgets/buttons/primary_button.dart';
import 'package:saurav_portfolio/widgets/buttons/secondary_button.dart';
import 'package:saurav_portfolio/widgets/form_fields/app_text_field.dart';
import 'package:saurav_portfolio/widgets/icons/app_fa_icon.dart';
import 'package:saurav_portfolio/widgets/layout/portfolio_navbar.dart';
import 'package:saurav_portfolio/widgets/layout/portfolio_nav_section.dart';
import 'package:saurav_portfolio/widgets/layout/section_header.dart';
import 'package:saurav_portfolio/widgets/loaders/loading_spinner.dart';
import 'package:saurav_portfolio/widgets/portfolio/project_card.dart';
import 'package:saurav_portfolio/widgets/portfolio/skill_chip.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingSpinner();
        }
        final profile = controller.globalController.profile.value;
        return Stack(
          children: [
            CustomScrollView(
              controller: controller.scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: AppScale.navTopSpacer()),
                ),
                SliverToBoxAdapter(
                  child: _buildHeroSection(
                    profile?.name ?? 'Saurav',
                    profile?.title ?? '',
                  ),
                ),
                SliverToBoxAdapter(
                  key: controller.aboutSectionKey,
                  child: _buildAboutSection(
                    profile?.bio ?? '',
                    profile?.location ?? '',
                  ),
                ),
                SliverToBoxAdapter(
                  key: controller.skillsSectionKey,
                  child: _buildSkillsSection(profile?.skills ?? []),
                ),
                SliverToBoxAdapter(
                  key: controller.projectsSectionKey,
                  child: _buildProjectsSection(),
                ),
                SliverToBoxAdapter(
                  key: controller.contactSectionKey,
                  child: _buildContactSection(
                    profile?.email ?? 'hello@saurav.dev',
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: AppScale.h(64))),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppScale.pagePaddingHorizontal(),
                    AppScale.h(10),
                    AppScale.pagePaddingHorizontal(),
                    0,
                  ),
                  child: Obx(
                    () => PortfolioNavbar(
                      activeSection: controller.activeNavSection.value,
                      onLogoTap: controller.scrollToTop,
                      onAboutTap: () => controller.scrollToSection(
                        controller.aboutSectionKey,
                        PortfolioNavSection.about,
                      ),
                      onProjectsTap: () => controller.scrollToSection(
                        controller.projectsSectionKey,
                        PortfolioNavSection.projects,
                      ),
                      onContactTap: () => controller.scrollToSection(
                        controller.contactSectionKey,
                        PortfolioNavSection.contact,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeroSection(String name, String title) {
    final showRow = !AppScale.isMobile;

    return FuturisticBackground(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppScale.pagePaddingHorizontal(),
          vertical: AppScale.heroPaddingVertical(),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppScale.contentMaxWidth()),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppScale.w(28),
                    vertical: AppScale.h(32),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.glassFill.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.glassBorder),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.glowPrimary.withValues(alpha: 0.05),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: showRow
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _buildHeroLeftContent(name, title),
                              ),
                            ),
                            Spacing.s24.gapW,
                            const Expanded(
                              flex: 2,
                              child: Center(
                                child: FuturisticIllustration(),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: FuturisticIllustration(),
                            ),
                            Spacing.s24.gapH,
                            ..._buildHeroLeftContent(name, title),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHeroLeftContent(String name, String title) {
    return [
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          'SYSTEM STATUS: ACTIVE // PORTFOLIO v1.0',
          style: AppTextStyles.r12.copyWith(
            color: AppColors.primaryLight,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Spacing.s16.gapH,
      Text(
        'Hi, I\'m',
        style: AppTextStyles.r16.copyWith(
          color: AppColors.accent,
          fontWeight: FontWeight.w500,
        ),
      ),
      Spacing.s8.gapH,
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [
            Colors.white,
            AppColors.accent,
            AppColors.primaryLight,
          ],
        ).createShader(bounds),
        child: Text(
          name,
          style: AppTextStyles.b48.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      Spacing.s12.gapH,
      Text(
        title,
        style: AppTextStyles.sb24.copyWith(
          color: AppColors.primaryLight,
          fontWeight: FontWeight.w600,
        ),
      ),
      Spacing.s24.gapH,
      Text(
        'Building elegant, scalable Flutter applications for web and mobile.',
        style: AppTextStyles.r16.copyWith(
          color: AppColors.textSecondary,
          height: 1.6,
        ),
      ),
      Spacing.s32.gapH,
      Wrap(
        spacing: 16,
        runSpacing: 12,
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
        ],
      ),
    ];
  }

  Widget _buildAboutSection(String bio, String location) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: AppScale.sectionPaddingVertical(),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppScale.contentMaxWidth()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'About Me', subtitle: 'Who I am'),
              Spacing.s24.gapH,
              Text(
                bio,
                style: AppTextStyles.r16.copyWith(
                  height: 1.7,
                  color: AppColors.textSecondary,
                ),
              ),
              Spacing.s16.gapH,
              Row(
                children: [
                  AppFaIcon(
                    AppIcons.location,
                    color: AppColors.accent,
                    size: AppScale.icon(18),
                  ),
                  Spacing.s8.gapW,
                  Text(location, style: AppTextStyles.r14),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsSection(List<String> skills) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: AppScale.sectionPaddingVertical(),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppScale.contentMaxWidth()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Skills',
                subtitle: 'Technologies I work with',
              ),
              Spacing.s24.gapH,
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: skills
                    .map((skill) => SkillChip(label: skill))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsSection() {
    final crossAxisCount = AppScale.isDesktop
        ? 3
        : AppScale.isTablet
        ? 2
        : 1;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: AppScale.sectionPaddingVertical(),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppScale.contentMaxWidth()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Projects', subtitle: 'Selected work'),
              Spacing.s24.gapH,
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: AppScale.isMobile ? 1.05 : 1.1,
                ),
                itemCount: controller.projects.length,
                itemBuilder: (context, index) {
                  final project = controller.projects[index];
                  return ProjectCard(
                    project: project,
                    onTap: () => controller.openProject(project),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection(String email) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: AppScale.sectionPaddingVertical(),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppScale.contactMaxWidth()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Get in Touch', subtitle: 'Contact'),
              Spacing.s24.gapH,
              Form(
                key: controller.contactFormKey,
                child: Column(
                  children: [
                    AppTextField(
                      controller: controller.nameController,
                      label: 'Name',
                      hint: 'Your name',
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Name is required'
                          : null,
                    ),
                    Spacing.s16.gapH,
                    AppTextField(
                      controller: controller.emailController,
                      label: 'Email',
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!GetUtils.isEmail(value.trim())) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    Spacing.s16.gapH,
                    AppTextField(
                      controller: controller.messageController,
                      label: 'Message',
                      hint: 'Tell me about your project...',
                      maxLines: 5,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Message is required'
                          : null,
                    ),
                    Spacing.s24.gapH,
                    Obx(() {
                      if (controller.isSubmitting.value) {
                        return const LoadingSpinner();
                      }
                      return PrimaryButton(
                        label: 'Send Message',
                        onPressed: controller.submitContactForm,
                        icon: AppIcons.send,
                        expand: true,
                      );
                    }),
                  ],
                ),
              ),
              Spacing.s24.gapH,
              Text(
                'Prefer email? Reach out at $email',
                style: AppTextStyles.r14.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FuturisticBackground extends StatefulWidget {
  const FuturisticBackground({super.key, required this.child});

  final Widget child;

  @override
  State<FuturisticBackground> createState() => _FuturisticBackgroundState();
}

class _FuturisticBackgroundState extends State<FuturisticBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

class FuturisticIllustration extends StatefulWidget {
  const FuturisticIllustration({super.key});

  @override
  State<FuturisticIllustration> createState() => _FuturisticIllustrationState();
}

class _FuturisticIllustrationState extends State<FuturisticIllustration> with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double boxSize = AppScale.isTablet ? 200 : 250;

    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // HUD Background and orbiting nodes
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _IllustrationHudPainter(
                    rotationValue: _rotationController.value,
                  ),
                );
              },
            ),
          ),
          // Central Pulsing core
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final scale = 1.0 + (_pulseController.value * 0.08);
              final glow = _pulseController.value;

              return Transform.scale(
                scale: scale,
                child: Container(
                  width: boxSize * 0.32,
                  height: boxSize * 0.32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3 + (glow * 0.3)),
                        blurRadius: 15 + (glow * 15),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.2 + (glow * 0.2)),
                        blurRadius: 25,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: boxSize * 0.24,
                      height: boxSize * 0.24,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.scaffoldDark,
                      ),
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.white, AppColors.accent],
                          ).createShader(bounds),
                          child: AppFaIcon(
                            AppIcons.code,
                            size: boxSize * 0.1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _IllustrationHudPainter extends CustomPainter {
  _IllustrationHudPainter({required this.rotationValue});

  final double rotationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Draw outer corner HUD brackets
    final bracketPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final double pad = 12.0;
    final double len = 16.0;

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

    // 2. Draw crosshair guidelines
    final guidePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(size.width / 2, 20), Offset(size.width / 2, size.height - 20), guidePaint);
    canvas.drawLine(Offset(20, size.height / 2), Offset(size.width - 20, size.height / 2), guidePaint);

    // 3. Draw orbit rings
    // Ring 1 (Outer)
    final ringPaint1 = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, size.width * 0.38, ringPaint1);

    // Ring 2 (Inner)
    final ringPaint2 = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, size.width * 0.28, ringPaint2);

    // 4. Draw orbiting data nodes (small colored circles)
    final double angle1 = rotationValue * 2 * math.pi;
    final double r1 = size.width * 0.38;
    final double node1X = center.dx + r1 * math.cos(angle1);
    final double node1Y = center.dy + r1 * math.sin(angle1);

    final nodePaint1 = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(node1X, node1Y), 5.0, nodePaint1);

    // Add glow to node 1
    final nodeGlow1 = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(node1X, node1Y), 10.0, nodeGlow1);

    // Node 2 (Orbiting opposite direction, on Ring 2)
    final double angle2 = -rotationValue * 2 * math.pi + math.pi / 2;
    final double r2 = size.width * 0.28;
    final double node2X = center.dx + r2 * math.cos(angle2);
    final double node2Y = center.dy + r2 * math.sin(angle2);

    final nodePaint2 = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(node2X, node2Y), 4.0, nodePaint2);

    final nodeGlow2 = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(node2X, node2Y), 8.0, nodeGlow2);
  }

  @override
  bool shouldRepaint(covariant _IllustrationHudPainter oldDelegate) {
    return oldDelegate.rotationValue != rotationValue;
  }
}
