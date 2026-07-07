import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/presentation/home/controllers/home.controller.dart';
import 'package:saurav_portfolio/widgets/buttons/primary_button.dart';
import 'package:saurav_portfolio/widgets/buttons/secondary_button.dart';
import 'package:saurav_portfolio/widgets/form_fields/app_text_field.dart';
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
                SliverToBoxAdapter(child: SizedBox(height: 96.h)),
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
                  child: _buildProjectsSection(),
                ),
                SliverToBoxAdapter(
                  key: controller.contactSectionKey,
                  child: _buildContactSection(profile?.email ?? 'hello@saurav.dev'),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 64)),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
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
                    onPressed: () => controller.scrollToSection(
                      controller.projectsSectionKey,
                      PortfolioNavSection.projects,
                    ),
                    icon: Icons.work_outline,
                  ),
                  SecondaryButton(
                    label: 'Contact Me',
                    onPressed: () => controller.scrollToSection(
                      controller.contactSectionKey,
                      PortfolioNavSection.contact,
                    ),
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

  Widget _buildProjectsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 960.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Projects', subtitle: 'Selected work'),
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
                    itemCount: controller.projects.length,
                    itemBuilder: (context, index) {
                      final project = controller.projects[index];
                      return ProjectCard(
                        project: project,
                        onTap: () => controller.openProject(project),
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

  Widget _buildContactSection(String email) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 640.w),
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
                          value == null || value.trim().isEmpty ? 'Name is required' : null,
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
                          value == null || value.trim().isEmpty ? 'Message is required' : null,
                    ),
                    Spacing.s24.gapH,
                    Obx(() {
                      if (controller.isSubmitting.value) {
                        return const LoadingSpinner();
                      }
                      return PrimaryButton(
                        label: 'Send Message',
                        onPressed: controller.submitContactForm,
                        icon: Icons.send,
                        expand: true,
                      );
                    }),
                  ],
                ),
              ),
              Spacing.s24.gapH,
              Text(
                'Prefer email? Reach out at $email',
                style: AppTextStyles.r14.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
