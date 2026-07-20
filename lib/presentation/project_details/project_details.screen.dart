import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/data/models/portfolio/project.model.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_icons.dart';
import 'package:saurav_portfolio/presentation/project_details/controllers/project_details.controller.dart';
import 'package:saurav_portfolio/widgets/loaders/loading_spinner.dart';

class ProjectDetailsScreen extends GetView<ProjectDetailsController> {
  const ProjectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context); // Register media query for responsive design

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: LoadingSpinner());
          }

          if (controller.errorMessage.isNotEmpty) {
            return _buildErrorState();
          }

          final project = controller.project.value;
          if (project == null) {
            return _buildNotFoundState();
          }

          return _buildContent(context, project);
        }),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 64),
          const SizedBox(height: 16),
          Text(
            controller.errorMessage.value,
            style: AppTextStyles.sb18.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            color: AppColors.textSecondary,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Project not found',
            style: AppTextStyles.sb18.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProjectModel project) {
    final themeColor = AppColors.accent;
    final isDesktop = !AppScale.isMobile;

    return Stack(
      children: [
        // 1. Futuristic Faded Background Banner
        if (project.bannerAsset != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: AppScale.isMobile ? AppScale.h(280) : AppScale.h(420),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  project.bannerAsset!,
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.35),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.scaffoldDark.withValues(alpha: 0.5),
                        AppColors.scaffoldDark,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.7, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),

        // 2. Scrollable Content Layer
        Positioned.fill(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppScale.pagePaddingHorizontal(),
              AppScale.h(90), // Spaced below navbar
              AppScale.pagePaddingHorizontal(),
              AppScale.h(42),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: AppScale.contentMaxWidth(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppScale.h(20)),
                    // Title Header
                    _buildTitleHeader(project, themeColor),
                    SizedBox(height: AppScale.h(32)),

                    if (isDesktop)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column: Screenshots & Description
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildScreenshotsSection(project),
                                _buildDescriptionSection(project),
                              ],
                            ),
                          ),
                          SizedBox(width: AppScale.w(32)),
                          // Right Column: Details & Tech Stack & Features
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildActionsCard(project, themeColor),
                                SizedBox(height: AppScale.h(24)),
                                _buildFeaturesSection(project),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildScreenshotsSection(project),
                          _buildDescriptionSection(project),
                          SizedBox(height: AppScale.h(24)),
                          _buildActionsCard(project, themeColor),
                          SizedBox(height: AppScale.h(24)),
                          _buildFeaturesSection(project),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // 3. Sticky Glassmorphic Navbar (always on top)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _buildNavbar(project),
        ),
      ],
    );
  }

  Widget _buildNavbar(ProjectModel project) {
    final themeColor = AppColors.accent;
    final showGithub = project.githubUrl != null && project.githubUrl != '#';
    final showLive = project.liveUrl != null && project.liveUrl != '#';

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppScale.pagePaddingHorizontal(),
            vertical: AppScale.h(10),
          ),
          decoration: BoxDecoration(
            color: AppColors.scaffoldDark.withValues(alpha: 0.65),
            border: Border(
              bottom: BorderSide(
                color: AppColors.border.withValues(alpha: 0.3),
                width: 1.0,
              ),
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: AppScale.contentMaxWidth()),
              child: Row(
                children: [
                  // Back Button (Futuristic Pill Shape)
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppScale.w(14),
                        vertical: AppScale.h(8),
                      ),
                      decoration: BoxDecoration(
                        color: themeColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: themeColor.withValues(alpha: 0.25),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new,
                            color: themeColor,
                            size: AppScale.icon(12),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Back',
                            style: AppTextStyles.r14.copyWith(
                              color: themeColor,
                              fontWeight: FontWeight.w600,
                              fontSize: AppScale.font(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Action shortcuts on the right side
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showGithub)
                        _buildMiniNavbarAction(
                          icon: AppIcons.github,
                          tooltip: 'View Source Code',
                          onTap: () => controller.openExternalLink(project.githubUrl),
                        ),
                      if (showGithub && showLive) const SizedBox(width: 10),
                      if (showLive)
                        _buildMiniNavbarAction(
                          icon: AppIcons.arrowExternal,
                          tooltip: 'Launch Live Demo',
                          isAccent: true,
                          onTap: () => controller.openExternalLink(project.liveUrl),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniNavbarAction({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    bool isAccent = false,
  }) {
    final themeColor = AppColors.accent;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: AppScale.icon(36),
          height: AppScale.icon(36),
          decoration: BoxDecoration(
            color: isAccent 
                ? themeColor.withValues(alpha: 0.1) 
                : AppColors.surfaceDark.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isAccent 
                  ? themeColor.withValues(alpha: 0.3) 
                  : AppColors.border.withValues(alpha: 0.5),
              width: 1.0,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: isAccent ? themeColor : AppColors.textPrimary,
            size: AppScale.icon(16),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleHeader(ProjectModel project, Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: AppScale.icon(42),
              height: AppScale.icon(42),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: project.imageUrl != null ? AppColors.border : themeColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: project.imageUrl != null
                    ? Image.asset(
                        project.imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        AppIcons.folder,
                        color: themeColor,
                        size: AppScale.icon(18),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                project.title,
                style: AppTextStyles.sb24.copyWith(
                  fontSize: AppScale.font(24),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScreenshotsSection(ProjectModel project) {
    if (project.screenshots.isEmpty) return const SizedBox.shrink();
    final double galleryHeight = AppScale.isMobile
        ? AppScale.h(380)
        : AppScale.h(480);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Screenshots',
          style: AppTextStyles.sb18.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: AppScale.font(16),
          ),
        ),
        SizedBox(height: AppScale.h(16)),
        SizedBox(
          height: galleryHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: project.screenshots.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final screenshot = project.screenshots[index];
              return GestureDetector(
                onTap: () {
                  Get.dialog(
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.9),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            InteractiveViewer(
                              child: Image.asset(
                                screenshot,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Positioned(
                              top: 24,
                              right: 24,
                              child: Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Get.back(),
                                  iconSize: AppScale.icon(24),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    barrierColor: Colors.black.withValues(alpha: 0.9),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(right: AppScale.w(16)),
                  child: _DeviceMockup(assetPath: screenshot),
                ),
              );
            },
          ),
        ),
        SizedBox(height: AppScale.h(32)),
      ],
    );
  }

  Widget _buildDescriptionSection(ProjectModel project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About the Project',
          style: AppTextStyles.sb18.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppScale.h(12)),
        Text(
          project.description,
          style: AppTextStyles.r16.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
            fontSize: AppScale.font(14),
          ),
        ),
        SizedBox(height: AppScale.h(24)),
      ],
    );
  }

  Widget _buildActionsCard(ProjectModel project, Color themeColor) {
    final showGithub = project.githubUrl != null && project.githubUrl != '#';
    final showLive = project.liveUrl != null && project.liveUrl != '#';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.45),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: EdgeInsets.all(AppScale.w(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project Info',
                  style: AppTextStyles.sb18.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppScale.h(16)),
                Text(
                  'Technologies Used',
                  style: AppTextStyles.mono12.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppScale.h(8)),
                Wrap(
                  spacing: AppScale.w(8),
                  runSpacing: AppScale.h(8),
                  children: project.tags.map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppScale.w(10),
                        vertical: AppScale.h(5),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: AppTextStyles.mono12.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: AppScale.font(10),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: AppScale.h(24)),
                Row(
                  children: [
                    if (showGithub)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              controller.openExternalLink(project.githubUrl),
                          icon: Icon(AppIcons.github, size: AppScale.icon(14)),
                          label: Text(
                            'GitHub',
                            style: AppTextStyles.r14.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: AppScale.font(13),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.scaffoldDark.withValues(alpha: 0.8),
                            foregroundColor: AppColors.textPrimary,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: AppScale.h(14)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: AppColors.border),
                            ),
                          ),
                        ),
                      ),
                    if (showGithub && showLive) SizedBox(width: AppScale.w(12)),
                    if (showLive)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              controller.openExternalLink(project.liveUrl),
                          icon: Icon(AppIcons.arrowExternal, size: AppScale.icon(14)),
                          label: Text(
                            'Live Demo',
                            style: AppTextStyles.r14.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: AppScale.font(13),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            foregroundColor: AppColors.scaffoldDark,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: AppScale.h(14)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    if (!showGithub && !showLive)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => controller.openExternalLink('#'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.border,
                            foregroundColor: AppColors.textSecondary,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: AppScale.h(14)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Coming Soon',
                            style: AppTextStyles.r14.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: AppScale.font(13),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(ProjectModel project) {
    if (project.features.isEmpty) return const SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.45),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: EdgeInsets.all(AppScale.w(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Features',
                  style: AppTextStyles.sb18.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppScale.h(20)),
                ...project.features.map(_buildFeatureItem),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    String emoji = '⚡';
    String content = feature;

    final runes = content.runes;
    if (runes.isNotEmpty) {
      final firstRune = runes.first;
      if (firstRune > 127) {
        emoji = String.fromCharCode(firstRune);
        content = String.fromCharCodes(runes.skip(1)).trim();
      }
    }

    final colonIdx = content.indexOf(':');
    String title = content;
    String desc = '';
    if (colonIdx != -1) {
      title = content.substring(0, colonIdx).trim();
      desc = content.substring(colonIdx + 1).trim();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: AppScale.h(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppScale.w(32),
            height: AppScale.h(32),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: TextStyle(fontSize: AppScale.font(14))),
          ),
          SizedBox(width: AppScale.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.m16.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: AppScale.font(14),
                  ),
                ),
                if (desc.isNotEmpty) ...[
                  SizedBox(height: AppScale.h(4)),
                  Text(
                    desc,
                    style: AppTextStyles.r14.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                      fontSize: AppScale.font(13),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceMockup extends StatelessWidget {
  final String assetPath;

  const _DeviceMockup({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    final double bezelWidth = AppScale.w(6);
    final double innerRadius = AppScale.r(16);
    final double outerRadius = AppScale.r(22);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(outerRadius),
        border: Border.all(
          color: const Color(0xFF2C2D3A), // Metallic outer frame rim
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(bezelWidth),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F12), // Black bezel
          borderRadius: BorderRadius.circular(outerRadius - 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(innerRadius),
          child: Stack(
            children: [
              // Screen image
              AspectRatio(
                aspectRatio: 9 / 19.5,
                child: Image.asset(assetPath, fit: BoxFit.cover),
              ),
              // Dynamic Island / Camera Notch
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: AppScale.h(6)),
                  child: Container(
                    width: AppScale.w(44),
                    height: AppScale.h(10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              // Diagonal glass glare sheen overlay
              Positioned.fill(
                child: FractionallySizedBox(
                  alignment: Alignment.topLeft,
                  widthFactor: 0.6,
                  heightFactor: 0.8,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.04),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
