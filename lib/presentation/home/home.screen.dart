import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/presentation/home/controllers/home.controller.dart';
import 'package:saurav_portfolio/widgets/buttons/primary_button.dart';
import 'package:saurav_portfolio/widgets/buttons/secondary_button.dart';
import 'package:saurav_portfolio/widgets/layout/portfolio_navbar.dart';
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
        return CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: PortfolioNavbar(
                onAboutTap: () => controller.scrollToSection(controller.aboutSectionKey),
                onProjectsTap: () => controller.scrollToSection(controller.projectsSectionKey),
                onContactTap: controller.navigateToContact,
              ),
            ),
            SliverToBoxAdapter(child: _buildHeroSection(profile?.name ?? 'Saurav', profile?.title ?? '')),
            SliverToBoxAdapter(
              key: controller.aboutSectionKey,
              child: _buildAboutSection(profile?.bio ?? '', profile?.location ?? ''),
            ),
            SliverToBoxAdapter(
              key: controller.skillsSectionKey,
              child: _buildSkillsSection(profile?.skills ?? []),
            ),
            SliverToBoxAdapter(
              key: controller.projectsSectionKey,
              child: _buildFeaturedProjectsSection(),
            ),
            SliverToBoxAdapter(child: _buildContactCta()),
            const SliverToBoxAdapter(child: SizedBox(height: 64)),
          ],
        );
      }),
    );
  }

  Widget _buildHeroSection(String name, String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 80.h),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 960.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi, I\'m', style: AppTextStyles.r16.copyWith(color: AppColors.accent)),
              Spacing.s8.gapH,
              Text(name, style: AppTextStyles.b48),
              Spacing.s12.gapH,
              Text(title, style: AppTextStyles.sb24.copyWith(color: AppColors.primaryLight)),
              Spacing.s24.gapH,
              Text(
                'Building elegant, scalable Flutter applications for web and mobile.',
                style: AppTextStyles.r16.copyWith(color: AppColors.textSecondary, height: 1.6),
              ),
              Spacing.s32.gapH,
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  PrimaryButton(
                    label: 'View Projects',
                    onPressed: controller.navigateToProjects,
                    icon: Icons.work_outline,
                  ),
                  SecondaryButton(
                    label: 'Contact Me',
                    onPressed: controller.navigateToContact,
                    icon: Icons.mail_outline,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection(String bio, String location) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 960.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'About Me', subtitle: 'Who I am'),
              Spacing.s24.gapH,
              Text(bio, style: AppTextStyles.r16.copyWith(height: 1.7, color: AppColors.textSecondary)),
              Spacing.s16.gapH,
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: AppColors.accent, size: 18),
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
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 960.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Skills', subtitle: 'Technologies I work with'),
              Spacing.s24.gapH,
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: skills.map((skill) => SkillChip(label: skill)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedProjectsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 960.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'Featured Projects',
                subtitle: 'Recent work',
                actionLabel: 'View all',
                onActionTap: controller.navigateToProjects,
              ),
              Spacing.s24.gapH,
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 900 ? 3 : constraints.maxWidth > 600 ? 2 : 1;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: controller.featuredProjects.length,
                    itemBuilder: (context, index) {
                      final project = controller.featuredProjects[index];
                      return ProjectCard(
                        project: project,
                        onTap: () => controller.openProjectDetail(project),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCta() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 960.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.accent.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Let\'s work together', style: AppTextStyles.sb24),
                Spacing.s12.gapH,
                Text(
                  'Have a project in mind? I\'d love to hear about it.',
                  style: AppTextStyles.r16.copyWith(color: AppColors.textSecondary),
                ),
                Spacing.s24.gapH,
                PrimaryButton(
                  label: 'Get in Touch',
                  onPressed: controller.navigateToContact,
                  icon: Icons.send_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
