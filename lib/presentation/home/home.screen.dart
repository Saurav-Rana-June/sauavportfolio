import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/data/models/portfolio/experience.model.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_icons.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/presentation/home/controllers/home.controller.dart';
import 'package:saurav_portfolio/widgets/animations/animated_typing_text.dart';
import 'package:saurav_portfolio/widgets/buttons/primary_button.dart';
import 'package:saurav_portfolio/widgets/buttons/secondary_button.dart';
import 'package:saurav_portfolio/widgets/form_fields/app_text_field.dart';
import 'package:saurav_portfolio/widgets/icons/app_fa_icon.dart';
import 'package:saurav_portfolio/widgets/layout/portfolio_navbar.dart';
import 'package:saurav_portfolio/widgets/layout/portfolio_nav_section.dart';
import 'package:saurav_portfolio/widgets/loaders/loading_spinner.dart';
import 'package:saurav_portfolio/widgets/portfolio/project_card.dart';
import 'package:saurav_portfolio/data/models/portfolio/profile.model.dart';

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
                    profile?.name ?? 'Saurav Rana',
                    profile?.title ?? '',
                    profile,
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
                  key: controller.experienceSectionKey,
                  child: _buildExperienceSection(controller.experiences),
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

  Widget _buildHeroSection(String name, String title, ProfileModel? profile) {
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
            child: showRow
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._buildHeroLeftContent(name, title),
                            Spacing.s32.gapH,
                            _buildSocialMediaSection(profile),
                          ],
                        ),
                      ),
                      Spacing.s24.gapW,
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
                      Spacing.s24.gapH,
                      ..._buildHeroLeftContent(name, title),
                      Spacing.s32.gapH,
                      _buildSocialMediaSection(profile),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection(ProfileModel? profile) {
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
        Spacing.s16.gapW,
        if (profile.githubUrl != null &&
            profile.githubUrl!.isNotEmpty &&
            profile.githubUrl != '#') ...[
          _SocialIconButton(
            icon: AppIcons.github,
            label: 'GITHUB',
            onPressed: () => controller.openExternalLink(profile.githubUrl),
          ),
          Spacing.s8.gapW,
        ],
        if (profile.linkedInUrl != null &&
            profile.linkedInUrl!.isNotEmpty &&
            profile.linkedInUrl != '#') ...[
          _SocialIconButton(
            icon: AppIcons.linkedin,
            label: 'LINKEDIN',
            onPressed: () => controller.openExternalLink(profile.linkedInUrl),
          ),
          Spacing.s8.gapW,
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

  List<Widget> _buildHeroLeftContent(String name, String title) {
    return [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PulsingStatusDot(color: AppColors.success),
            6.0.gapW,
            Text(
              'AVAILABLE FOR OPPORTUNITIES',
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
      Spacing.s12.gapH,
      AnimatedTypingText(
        texts: [
          title.isNotEmpty ? title : 'Senior Flutter Developer',
          'UI/UX & Figma-to-Flutter Specialist',
          'FastAPI Learner',
          'Cross-Platform Apps Developer',
        ],
        style: AppTextStyles.sb24.copyWith(
          color: AppColors.primaryLight,
          fontWeight: FontWeight.w600,
        ),
      ),
      Spacing.s24.gapH,
      Text(
        'Passionate Flutter Engineer with 2+ years of experience building high-performance cross-platform apps. Skilled in Flutter, Figma-to-Flutter development, and UI/UX principles, with a focus on clean, scalable, and pixel-perfect applications. Currently learning FastAPI to strengthen my backend development skills.',
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
          SecondaryButton(
            label: 'Review CV',
            onPressed: () {
              final resumeUrl =
                  controller.globalController.profile.value?.resumeUrl;
              controller.openExternalLink(resumeUrl);
            },
            icon: AppIcons.resume,
          ),
        ],
      ),
    ];
  }

  Widget _buildAboutSection(String bio, String location) {
    final bool showRow = !AppScale.isMobile && !AppScale.isTablet;
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
                'ABOUT ME',
                style: AppTextStyles.mono12.copyWith(
                  color: AppColors.accent,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                  fontSize: AppScale.font(10),
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'Who I Am',
                style: AppTextStyles.b32.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'A brief introduction about my journey as a developer',
                style: AppTextStyles.r14.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: AppScale.font(14),
                ),
              ),
              48.0.gapH,
              showRow
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 11,
                          child: _buildAboutLeftContent(bio, location),
                        ),
                        48.0.gapW,
                        Expanded(flex: 9, child: _buildAboutRightContent()),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAboutLeftContent(bio, location),
                        48.0.gapH,
                        _buildAboutRightContent(),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutLeftContent(String bio, String location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bio,
          style: AppTextStyles.r16.copyWith(
            height: 1.8,
            color: AppColors.textSecondary,
            fontSize: AppScale.font(15),
          ),
        ),
        Spacing.s16.gapH,
        Row(
          children: [
            AppFaIcon(
              AppIcons.location,
              color: AppColors.accent,
              size: AppScale.icon(16),
            ),
            Spacing.s8.gapW,
            Text(
              location,
              style: AppTextStyles.r14.copyWith(
                color: AppColors.textSecondary,
                fontSize: AppScale.font(13),
              ),
            ),
          ],
        ),
        Spacing.s32.gapH,
        LayoutBuilder(
          builder: (context, constraints) {
            final double cardWidth = (constraints.maxWidth - 32) / 3;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: cardWidth.clamp(140.0, double.infinity),
                  child: const _AboutStatCard(value: '2+', label: 'YEARS EXP'),
                ),
                SizedBox(
                  width: cardWidth.clamp(140.0, double.infinity),
                  child: const _AboutStatCard(
                    value: '15+',
                    label: 'PROJECTS BUILT',
                  ),
                ),
                SizedBox(
                  width: cardWidth.clamp(140.0, double.infinity),
                  child: const _AboutStatCard(
                    value: '25K+',
                    label: 'USERS IMPACTED',
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAboutRightContent() {
    return Column(
      children: [
        _AboutFocusCard(
          icon: AppIcons.mobile,
          title: 'Cross-Platform Development',
          description:
              'Building beautiful, native-quality mobile apps for both iOS and Android using Flutter and Dart.',
          highlightColor: AppColors.accent,
        ),
        _AboutFocusCard(
          icon: AppIcons.projects,
          title: 'Clean Architecture',
          description:
              'Applying SOLID principles and clean architecture patterns for scalable, maintainable codebases.',
          highlightColor: AppColors.primaryLight,
        ),
        _AboutFocusCard(
          icon: AppIcons.bolt,
          title: 'Performance Focused',
          description:
              'Optimizing app performance with efficient state management and responsive adaptive UI design.',
          highlightColor: AppColors.success,
        ),
      ],
    );
  }

  Widget _buildExperienceSection(List<ExperienceModel> experiences) {
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
              48.0.gapH,
              _buildTimeline(experiences),
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
              Spacing.s24.gapW,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _ExperienceCard(experience: exp),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkillsSection(List<String> skills) {
    final skillItems = [
      const _SkillItem(name: 'Flutter', level: 0.95, subtitle: 'Expert'),
      const _SkillItem(name: 'Dart', level: 0.90, subtitle: 'Expert'),
      const _SkillItem(name: 'GetX', level: 0.90, subtitle: 'Expert'),
      const _SkillItem(name: 'BLoC', level: 0.70, subtitle: 'Intermediate'),
      const _SkillItem(
        name: 'Clean Architecture',
        level: 0.85,
        subtitle: 'Advanced',
      ),
      const _SkillItem(name: 'REST APIs', level: 0.90, subtitle: 'Advanced'),
      const _SkillItem(name: 'Firebase', level: 0.85, subtitle: 'Advanced'),
      const _SkillItem(name: 'Supabase', level: 0.80, subtitle: 'Advanced'),
      const _SkillItem(
        name: 'Web (HTML/JS)',
        level: 0.80,
        subtitle: 'Advanced',
      ),
      const _SkillItem(name: 'React.js', level: 0.75, subtitle: 'Intermediate'),
      const _SkillItem(
        name: 'System Design',
        level: 0.80,
        subtitle: 'Advanced',
      ),
      const _SkillItem(name: 'UI/UX', level: 0.70, subtitle: 'Intermediate'),
      const _SkillItem(name: 'Figma', level: 0.70, subtitle: 'Intermediate'),
      const _SkillItem(name: 'FastAPI', level: 0.50, subtitle: 'Learning'),
      const _SkillItem(name: 'Render', level: 0.70, subtitle: 'Intermediate'),
    ];

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
                'SKILLS',
                style: AppTextStyles.mono12.copyWith(
                  color: AppColors.accent,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                  fontSize: AppScale.font(10),
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'Technical Stack',
                style: AppTextStyles.b32.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'My professional skillset and toolbelt',
                style: AppTextStyles.r14.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: AppScale.font(14),
                ),
              ),
              48.0.gapH,
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: skillItems
                    .map(
                      (skill) => _SkillTileChip(
                        skill: skill,
                        accentColor: AppColors.accent,
                      ),
                    )
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'PROJECTS',
                style: AppTextStyles.mono12.copyWith(
                  color: AppColors.accent,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                  fontSize: AppScale.font(10),
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'Selected Work',
                style: AppTextStyles.b32.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'A collection of mobile applications and tools I\'ve built',
                style: AppTextStyles.r14.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: AppScale.font(14),
                ),
              ),
              48.0.gapH,
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
                  return _AnimatedProjectCard(
                    index: index,
                    child: ProjectCard(
                      project: project,
                      onTap: () => controller.openProject(project),
                    ),
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
    final profile = controller.globalController.profile.value;
    final isDesktop = AppScale.isDesktop;
    final themeColor = AppColors.accent;

    final contactInfoCard = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: AppTextStyles.sb18.copyWith(
              color: themeColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacing.s24.gapH,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppFaIcon(
                  AppIcons.location,
                  color: themeColor,
                  size: AppScale.icon(16),
                ),
              ),
              Spacing.s16.gapW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: AppTextStyles.sb18.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: AppScale.font(14),
                      ),
                    ),
                    4.0.gapH,
                    Text(
                      profile?.location ?? 'Rishikesh, Uttarakhand, India',
                      style: AppTextStyles.r14.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          20.0.gapH,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppFaIcon(
                  AppIcons.mail,
                  color: themeColor,
                  size: AppScale.icon(16),
                ),
              ),
              Spacing.s16.gapW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email Address',
                      style: AppTextStyles.sb18.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: AppScale.font(14),
                      ),
                    ),
                    4.0.gapH,
                    GestureDetector(
                      onTap: () => controller.openExternalLink('mailto:$email'),
                      child: Text(
                        email,
                        style: AppTextStyles.r14.copyWith(
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacing.s32.gapH,
          Text(
            'Social Channels',
            style: AppTextStyles.sb18.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: AppScale.font(16),
            ),
          ),
          Spacing.s16.gapH,
          Row(
            children: [
              if (profile?.githubUrl != null && profile!.githubUrl!.isNotEmpty)
                _SocialIconRoundButton(
                  icon: AppIcons.github,
                  onTap: () => controller.openExternalLink(profile.githubUrl),
                  accentColor: themeColor,
                ),
              if (profile?.linkedInUrl != null &&
                  profile!.linkedInUrl!.isNotEmpty) ...[
                if (profile.githubUrl != null) Spacing.s12.gapW,
                _SocialIconRoundButton(
                  icon: AppIcons.linkedin,
                  onTap: () => controller.openExternalLink(profile.linkedInUrl),
                  accentColor: themeColor,
                ),
              ],
            ],
          ),
        ],
      ),
    );

    final contactFormCard = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Form(
        key: controller.contactFormKey,
        child: Column(
          children: [
            AppTextField(
              controller: controller.nameController,
              label: 'Name',
              hint: 'Your name',
              validator: (value) => value == null || value.trim().isEmpty
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
              validator: (value) => value == null || value.trim().isEmpty
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
    );

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
                'CONTACT',
                style: AppTextStyles.mono12.copyWith(
                  color: themeColor,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                  fontSize: AppScale.font(10),
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'Get in Touch',
                style: AppTextStyles.b32.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'Let\'s collaborate on building your next high-tech solution',
                style: AppTextStyles.r14.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: AppScale.font(14),
                ),
              ),
              48.0.gapH,
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: contactInfoCard),
                    Spacing.s24.gapW,
                    Expanded(flex: 3, child: contactFormCard),
                  ],
                )
              else
                Column(
                  children: [
                    contactInfoCard,
                    Spacing.s24.gapH,
                    contactFormCard,
                  ],
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

class _FuturisticIllustrationState extends State<FuturisticIllustration>
    with TickerProviderStateMixin {
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
          // HUD Background and orbiting nodes
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              final double centerCoord = boxSize / 2;
              final double r1 = boxSize * 0.38;
              final double r2 = boxSize * 0.28;
              final double nodeSize = 32.0;

              // Outer Orbit (Flutter & Figma, offset by pi)
              final double angle1 = _rotationController.value * 2 * math.pi;
              final double node1X =
                  centerCoord + r1 * math.cos(angle1) - (nodeSize / 2);
              final double node1Y =
                  centerCoord + r1 * math.sin(angle1) - (nodeSize / 2);

              final double angle3 = angle1 + math.pi;
              final double node3X =
                  centerCoord + r1 * math.cos(angle3) - (nodeSize / 2);
              final double node3Y =
                  centerCoord + r1 * math.sin(angle3) - (nodeSize / 2);

              // Inner Orbit (Dart & FastAPI, offset by pi)
              final double angle2 =
                  -_rotationController.value * 2 * math.pi + (math.pi / 2);
              final double node2X =
                  centerCoord + r2 * math.cos(angle2) - (nodeSize / 2);
              final double node2Y =
                  centerCoord + r2 * math.sin(angle2) - (nodeSize / 2);

              final double angle4 = angle2 + math.pi;
              final double node4X =
                  centerCoord + r2 * math.cos(angle4) - (nodeSize / 2);
              final double node4Y =
                  centerCoord + r2 * math.sin(angle4) - (nodeSize / 2);

              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _IllustrationHudPainter(
                        rotationValue: _rotationController.value,
                      ),
                    ),
                  ),
                  // Orbiting Flutter node (Outer)
                  Positioned(
                    left: node1X,
                    top: node1Y,
                    child: Container(
                      width: nodeSize,
                      height: nodeSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceDark.withValues(alpha: 0.9),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Center(child: FlutterLogo(size: 16.0)),
                    ),
                  ),
                  // Orbiting Figma node (Outer - opposite to Flutter)
                  Positioned(
                    left: node3X,
                    top: node3Y,
                    child: Container(
                      width: nodeSize,
                      height: nodeSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceDark.withValues(alpha: 0.9),
                        border: Border.all(
                          color: const Color(0xFFF24E1E).withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFA259FF,
                            ).withValues(alpha: 0.4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Center(child: FigmaVectorLogo(size: 15.0)),
                    ),
                  ),
                  // Orbiting Dart node (Inner)
                  Positioned(
                    left: node2X,
                    top: node2Y,
                    child: Container(
                      width: nodeSize,
                      height: nodeSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceDark.withValues(alpha: 0.9),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Center(child: DartVectorLogo(size: 14.0)),
                    ),
                  ),
                  // Orbiting FastAPI node (Inner - opposite to Dart)
                  Positioned(
                    left: node4X,
                    top: node4Y,
                    child: Container(
                      width: nodeSize,
                      height: nodeSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceDark.withValues(alpha: 0.9),
                        border: Border.all(
                          color: const Color(0xFF009485).withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF05D3B4,
                            ).withValues(alpha: 0.4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Center(child: FastApiVectorLogo(size: 14.0)),
                    ),
                  ),
                ],
              );
            },
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
                        color: AppColors.primary.withValues(
                          alpha: 0.3 + (glow * 0.3),
                        ),
                        blurRadius: 15 + (glow * 15),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: AppColors.accent.withValues(
                          alpha: 0.2 + (glow * 0.2),
                        ),
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
    canvas.drawLine(
      Offset(size.width / 2, 20),
      Offset(size.width / 2, size.height - 20),
      guidePaint,
    );
    canvas.drawLine(
      Offset(20, size.height / 2),
      Offset(size.width - 20, size.height / 2),
      guidePaint,
    );

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

    // 4. Orbiting nodes are painted as widgets overlaying the HUD in Stack
  }

  @override
  bool shouldRepaint(covariant _IllustrationHudPainter oldDelegate) {
    return oldDelegate.rotationValue != rotationValue;
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

class PulsingStatusDot extends StatefulWidget {
  const PulsingStatusDot({super.key, required this.color});
  final Color color;

  @override
  State<PulsingStatusDot> createState() => _PulsingStatusDotState();
}

class _PulsingStatusDotState extends State<PulsingStatusDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: 0.5 + (_controller.value * 0.5),
          child: Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.4),
                  blurRadius: 3 + (_controller.value * 3),
                  spreadRadius: 0.5 + (_controller.value * 0.5),
                ),
              ],
            ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
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

class _AboutStatCard extends StatefulWidget {
  final String value;
  final String label;

  const _AboutStatCard({required this.value, required this.label});

  @override
  State<_AboutStatCard> createState() => _AboutStatCardState();
}

class _AboutStatCardState extends State<_AboutStatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.surfaceDark.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.border.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.value,
              style: AppTextStyles.b32.copyWith(
                color: AppColors.primaryLight,
                fontWeight: FontWeight.w800,
              ),
            ),
            Spacing.s8.gapH,
            Text(
              widget.label,
              style: AppTextStyles.mono12.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.8),
                fontSize: AppScale.font(10),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutFocusCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color highlightColor;

  const _AboutFocusCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.highlightColor,
  });

  @override
  State<_AboutFocusCard> createState() => _AboutFocusCardState();
}

class _AboutFocusCardState extends State<_AboutFocusCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.surfaceDark.withValues(alpha: 0.7)
              : AppColors.surfaceDark.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? widget.highlightColor.withValues(alpha: 0.4)
                : AppColors.border.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: widget.highlightColor.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isHovered
                    ? widget.highlightColor.withValues(alpha: 0.15)
                    : AppColors.scaffoldDark.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isHovered
                      ? widget.highlightColor.withValues(alpha: 0.3)
                      : AppColors.border,
                ),
              ),
              child: AppFaIcon(
                widget.icon,
                color: _isHovered
                    ? widget.highlightColor
                    : AppColors.textSecondary,
                size: AppScale.icon(18),
              ),
            ),
            Spacing.s16.gapW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: AppTextStyles.sb18.copyWith(
                      color: _isHovered
                          ? widget.highlightColor
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: AppScale.font(16),
                    ),
                  ),
                  6.0.gapH,
                  Text(
                    widget.description,
                    style: AppTextStyles.r14.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineNodeIndicator extends StatefulWidget {
  final bool isLast;
  final bool isActive;

  const _TimelineNodeIndicator({required this.isLast, required this.isActive});

  @override
  State<_TimelineNodeIndicator> createState() => _TimelineNodeIndicatorState();
}

class _TimelineNodeIndicatorState extends State<_TimelineNodeIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    if (widget.isActive) {
      _pulseController.repeat();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (!widget.isLast)
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
                      widget.isActive
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
                if (widget.isActive)
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 14 * _pulseAnimation.value,
                        height: 14 * _pulseAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accent.withValues(
                            alpha:
                                (2.0 - _pulseAnimation.value).clamp(0.0, 1.0) *
                                0.4,
                          ),
                        ),
                      );
                    },
                  ),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.scaffoldDark,
                    border: Border.all(
                      color: widget.isActive
                          ? AppColors.accent
                          : AppColors.primary.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (widget.isActive
                                    ? AppColors.accent
                                    : AppColors.primary)
                                .withValues(alpha: widget.isActive ? 0.3 : 0.1),
                        blurRadius: widget.isActive ? 8 : 4,
                        spreadRadius: widget.isActive ? 1 : 0,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isActive
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
  bool shouldRepaint(covariant _CardTechBorderPainter oldDelegate) {
    return oldDelegate.hoverProgress != hoverProgress ||
        oldDelegate.color != color;
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
            padding: const EdgeInsets.all(24),
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
                      Spacing.s8.gapW,
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
                  Spacing.s12.gapH,
                  Text(
                    exp.role,
                    style: AppTextStyles.sb18.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: AppScale.font(18),
                    ),
                  ),
                  Spacing.s8.gapH,
                  Row(
                    children: [
                      Text(
                        exp.company,
                        style: AppTextStyles.m16.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: AppScale.font(14),
                        ),
                      ),
                      Spacing.s12.gapW,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: exp.isRemote
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.border.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(20),
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
                            6.0.gapW,
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
                  Spacing.s16.gapH,
                  Text(
                    exp.description,
                    style: AppTextStyles.r14.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.9),
                      height: 1.6,
                      fontSize: AppScale.font(13.5),
                    ),
                  ),
                  if (exp.skills.isNotEmpty) ...[
                    Spacing.s24.gapH,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: exp.skills.map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
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

class _SkillItem {
  final String name;
  final double level;
  final String? subtitle;

  const _SkillItem({required this.name, required this.level, this.subtitle});
}

class _SkillTileChip extends StatefulWidget {
  final _SkillItem skill;
  final Color accentColor;

  const _SkillTileChip({required this.skill, required this.accentColor});

  @override
  State<_SkillTileChip> createState() => _SkillTileChipState();
}

class _SkillTileChipState extends State<_SkillTileChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final skill = widget.skill;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _isHovered
              ? widget.accentColor.withValues(alpha: 0.1)
              : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: 0.5)
                : AppColors.border,
            width: 1.0,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: widget.accentColor.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              skill.name,
              style: AppTextStyles.r14.copyWith(
                color: _isHovered
                    ? AppColors.textPrimary
                    : AppColors.textPrimary.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
                fontSize: AppScale.font(13),
              ),
            ),
            if (skill.subtitle != null) ...[
              Spacing.s8.gapW,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? widget.accentColor.withValues(alpha: 0.2)
                      : widget.accentColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  skill.subtitle!.toUpperCase(),
                  style: AppTextStyles.mono12.copyWith(
                    color: _isHovered
                        ? AppColors.textPrimary
                        : widget.accentColor,
                    fontSize: AppScale.font(8),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnimatedProjectCard extends StatelessWidget {
  final Widget child;
  final int index;

  const _AnimatedProjectCard({required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 150)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final double scale = 0.95 + (value * 0.05);
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: scale,
            child: Transform.translate(
              offset: Offset(0, 40 * (1.0 - value.clamp(0.0, 1.0))),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class _SocialIconRoundButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color accentColor;

  const _SocialIconRoundButton({
    required this.icon,
    required this.onTap,
    required this.accentColor,
  });

  @override
  State<_SocialIconRoundButton> createState() => _SocialIconRoundButtonState();
}

class _SocialIconRoundButtonState extends State<_SocialIconRoundButton> {
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
          width: AppScale.icon(42),
          height: AppScale.icon(42),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: 0.15)
                : AppColors.surfaceDark.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor.withValues(alpha: 0.4)
                  : AppColors.border,
              width: 1.5,
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: widget.accentColor.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Center(
            child: AppFaIcon(
              widget.icon,
              color: _isHovered ? widget.accentColor : AppColors.textSecondary,
              size: AppScale.icon(16),
            ),
          ),
        ),
      ),
    );
  }
}
