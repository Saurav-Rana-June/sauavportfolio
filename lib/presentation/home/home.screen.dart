import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/presentation/home/controllers/home.controller.dart';
import 'package:saurav_portfolio/presentation/home/widgets/about_section.dart';
import 'package:saurav_portfolio/presentation/home/widgets/contact_section.dart';
import 'package:saurav_portfolio/presentation/home/widgets/experience_section.dart';
import 'package:saurav_portfolio/presentation/home/widgets/hero_section.dart';
import 'package:saurav_portfolio/presentation/home/widgets/projects_section.dart';
import 'package:saurav_portfolio/presentation/home/widgets/skills_section.dart';
import 'package:saurav_portfolio/widgets/layout/portfolio_navbar.dart';
import 'package:saurav_portfolio/widgets/layout/portfolio_nav_section.dart';
import 'package:saurav_portfolio/widgets/loaders/loading_spinner.dart';

/// The entry screen of the personal portfolio website.
/// Performs lazy loading and coordinates a seamless Hero flight transition connecting
/// the central logo in LoadingSpinner directly to the FuturisticIllustration logo in HeroSection.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final HomeController controller;
  late final AnimationController _flightController;
  late final Animation<double> _flightAnimation;
  late final Animation<double> _hudFadeOutAnimation;
  late final Animation<double> _contentFadeInAnimation;

  bool _isFlightRunning = false;
  bool _flightCompleted = false;
  Rect? _startRect;
  Rect? _targetRect;

  Worker? _loadingWorker;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();

    _flightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _flightAnimation = CurvedAnimation(
      parent: _flightController,
      curve: Curves.easeInOutCubicEmphasized,
    );

    _hudFadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _flightController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    _contentFadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _flightController,
        curve: const Interval(0.15, 0.85, curve: Curves.easeIn),
      ),
    );

    if (!controller.isLoading.value) {
      _flightCompleted = true;
      controller.isHeroLogoDocked.value = true;
    } else {
      _loadingWorker = ever<bool>(controller.isLoading, (isLoading) {
        if (!isLoading && !_flightCompleted && !_isFlightRunning) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _startHeroFlight();
          });
        }
      });
    }
  }

  void _startHeroFlight() {
    if (!mounted || _isFlightRunning || _flightCompleted) return;

    final startBox = controller.spinnerCentralLogoKey.currentContext?.findRenderObject() as RenderBox?;
    final targetBox = controller.heroCentralLogoKey.currentContext?.findRenderObject() as RenderBox?;
    final screenSize = MediaQuery.sizeOf(context);

    final Rect start;
    if (startBox != null && startBox.hasSize) {
      start = startBox.localToGlobal(Offset.zero) & startBox.size;
    } else {
      const defaultSpinnerLogoSize = 65.0;
      start = Rect.fromCenter(
        center: Offset(screenSize.width / 2, screenSize.height / 2),
        width: defaultSpinnerLogoSize,
        height: defaultSpinnerLogoSize,
      );
    }

    final Rect? target;
    if (targetBox != null && targetBox.hasSize) {
      target = targetBox.localToGlobal(Offset.zero) & targetBox.size;
    } else {
      target = null;
    }

    if (target != null) {
      setState(() {
        _startRect = start;
        _targetRect = target;
        _isFlightRunning = true;
      });

      _flightController.forward().then((_) {
        if (!mounted) return;
        controller.isHeroLogoDocked.value = true;
        setState(() {
          _isFlightRunning = false;
          _flightCompleted = true;
        });
      });
    } else {
      // Retry once on next frame in case layout is still settling
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _flightCompleted) return;
        final retryTargetBox = controller.heroCentralLogoKey.currentContext?.findRenderObject() as RenderBox?;
        if (retryTargetBox != null && retryTargetBox.hasSize) {
          _startHeroFlight();
        } else {
          controller.isHeroLogoDocked.value = true;
          setState(() {
            _flightCompleted = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _loadingWorker?.dispose();
    _flightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.sizeOf(context);

    if (_flightCompleted) {
      return const Scaffold(
        backgroundColor: AppColors.scaffoldDark,
        body: HomeContent(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: Obx(() {
        final isLoading = controller.isLoading.value;

        if (isLoading && !_isFlightRunning) {
          return LoadingSpinner(
            key: const ValueKey('active_loader'),
            logoKey: controller.spinnerCentralLogoKey,
          );
        }

        return Stack(
          children: [
            // 1. Home content fading in
            AnimatedBuilder(
              animation: _contentFadeInAnimation,
              builder: (context, child) => Opacity(
                opacity: _isFlightRunning ? _contentFadeInAnimation.value : 0.0,
                child: child,
              ),
              child: const HomeContent(),
            ),

            // 2. Loading spinner HUD rings/particles fading out
            if (!_flightCompleted)
              AnimatedBuilder(
                animation: _hudFadeOutAnimation,
                builder: (context, child) => Opacity(
                  opacity: _isFlightRunning ? _hudFadeOutAnimation.value : 1.0,
                  child: child,
                ),
                child: LoadingSpinner(
                  key: const ValueKey('fading_loader'),
                  logoKey: controller.spinnerCentralLogoKey,
                  hideCenterLogo: _isFlightRunning,
                  showText: false,
                ),
              ),

            // 3. Flying Hero Central Logo Pod
            if (_isFlightRunning && _startRect != null && _targetRect != null)
              AnimatedBuilder(
                animation: _flightAnimation,
                builder: (context, child) {
                  final t = _flightAnimation.value;
                  final currentRect = Rect.lerp(_startRect, _targetRect, t)!;

                  return Positioned.fromRect(
                    rect: currentRect,
                    child: RepaintBoundary(
                      child: _HeroFloatingLogoPod(
                        size: currentRect.width,
                        progress: t,
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      }),
    );
  }
}

/// Floating glassmorphic cyber pod that smoothly flies from the spinner center to the hero section.
class _HeroFloatingLogoPod extends StatelessWidget {
  final double size;
  final double progress;

  const _HeroFloatingLogoPod({
    required this.size,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = Color.lerp(
      AppColors.primary,
      AppColors.accent,
      progress,
    )!;

    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surfaceDark.withValues(alpha: 0.88),
          border: Border.all(
            color: borderColor.withValues(alpha: 0.6 + (progress * 0.2)),
            width: 1.5 + (progress * 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(
                alpha: 0.35 + (progress * 0.1),
              ),
              blurRadius: 18 + (progress * 8),
              spreadRadius: 1 + (progress * 1.5),
            ),
            BoxShadow(
              color: AppColors.accent.withValues(
                alpha: 0.2 + (progress * 0.1),
              ),
              blurRadius: 28,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: size * 0.75,
            height: size * 0.75,
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
                width: size * 0.44,
                height: size * 0.44,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Holds the structured sliver layout of the home screen once data has completed loading.
class HomeContent extends GetView<HomeController> {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = controller.globalController.profile.value;
    return Stack(
      children: [
        CustomScrollView(
          controller: controller.scrollController,
          physics: controller.isHeroLogoDocked.value
              ? const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                )
              : const NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: AppScale.navTopSpacer()),
            ),
            SliverToBoxAdapter(child: HeroSection(profile: profile)),
            SliverToBoxAdapter(
              key: controller.aboutSectionKey,
              child: ScrollReveal(child: AboutSection(profile: profile)),
            ),
            SliverToBoxAdapter(
              key: controller.experienceSectionKey,
              child: ScrollReveal(
                child: ExperienceSection(experiences: controller.experiences),
              ),
            ),
            SliverToBoxAdapter(
              key: controller.skillsSectionKey,
              child: ScrollReveal(
                child: SkillsSection(skills: profile?.skills ?? []),
              ),
            ),
            SliverToBoxAdapter(
              key: controller.projectsSectionKey,
              child: ScrollReveal(
                child: ProjectsSection(projects: controller.projects),
              ),
            ),
            SliverToBoxAdapter(
              key: controller.contactSectionKey,
              child: ScrollReveal(child: ContactSection(profile: profile)),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: AppScale.sectionPaddingVertical()),
            ),
          ],
        ),
        Positioned(
          top: 15,
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
  }
}

/// A high-performance entrance animation widget that triggers when scrolled into view.
/// Automatically unsubscribes from scrolling once the animation finishes to run with zero overhead.
class ScrollReveal extends StatefulWidget {
  final Widget child;

  const ScrollReveal({super.key, required this.child});

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  bool _hasRevealed = false;
  ScrollPosition? _scrollPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 40.0), // Slide up 40 pixels
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribeToScroll();
  }

  @override
  void dispose() {
    _unsubscribeFromScroll();
    _controller.dispose();
    super.dispose();
  }

  void _subscribeToScroll() {
    _unsubscribeFromScroll();
    try {
      final scrollableState = Scrollable.maybeOf(context);
      if (scrollableState != null) {
        _scrollPosition = scrollableState.position;
        _scrollPosition?.addListener(_checkVisibility);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
    } catch (_) {}
  }

  void _unsubscribeFromScroll() {
    _scrollPosition?.removeListener(_checkVisibility);
    _scrollPosition = null;
  }

  void _checkVisibility() {
    if (!mounted || _hasRevealed) return;

    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) return;

    if (!renderObject.hasSize) return;

    final size = renderObject.size;
    final position = renderObject.localToGlobal(Offset.zero);
    final double viewportHeight = MediaQuery.of(context).size.height;

    // Trigger reveal when the top of the element is visible in the viewport
    final double topOffset = position.dy;
    if (topOffset < viewportHeight - 80 && topOffset + size.height > 0) {
      setState(() {
        _hasRevealed = true;
      });
      _controller.forward();
      _unsubscribeFromScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isCompleted) {
      return widget.child;
    }

    if (_hasRevealed) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.translate(
              offset: _slideAnimation.value,
              child: child,
            ),
          );
        },
        child: widget.child,
      );
    }

    return Opacity(opacity: 0.0, child: widget.child);
  }
}
