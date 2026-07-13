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
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingSpinner();
        }
        return const HomeContent();
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
            SliverToBoxAdapter(
              child: HeroSection(profile: profile),
            ),
            SliverToBoxAdapter(
              key: controller.aboutSectionKey,
              child: AboutSection(profile: profile),
            ),
            SliverToBoxAdapter(
              key: controller.experienceSectionKey,
              child: ExperienceSection(experiences: controller.experiences),
            ),
            SliverToBoxAdapter(
              key: controller.skillsSectionKey,
              child: SkillsSection(skills: profile?.skills ?? []),
            ),
            SliverToBoxAdapter(
              key: controller.projectsSectionKey,
              child: ProjectsSection(projects: controller.projects),
            ),
            SliverToBoxAdapter(
              key: controller.contactSectionKey,
              child: ContactSection(profile: profile),
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
  }
}
