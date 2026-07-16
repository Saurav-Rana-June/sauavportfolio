import 'package:flutter/material.dart';
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
/// Performs lazy loading and handles composition of technical page sections.
class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Register dependency on MediaQuery to trigger rebuilds on window resize
    MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingSpinner();
        }
        return HomeContent();
      }),
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
