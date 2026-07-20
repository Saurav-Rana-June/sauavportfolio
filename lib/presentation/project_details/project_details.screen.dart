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
          const Icon(Icons.search_off, color: AppColors.textSecondary, size: 64),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Navbar
        _buildNavbar(project),

        // Screen Body
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppScale.pagePaddingHorizontal(),
              vertical: AppScale.h(24),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: AppScale.contentMaxWidth()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Header
                    _buildTitleHeader(project, themeColor),
                    SizedBox(height: AppScale.h(24)),

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
      ],
    );
  }

  Widget _buildNavbar(ProjectModel project) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: AppScale.h(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withValues(alpha: 0.4),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.accent,
                    size: AppScale.icon(14),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Back to Portfolio',
                    style: AppTextStyles.r14.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                      fontSize: AppScale.font(13),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Text(
            'PROJECT DETAILS',
            style: AppTextStyles.mono12.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w700,
              fontSize: AppScale.font(9),
            ),
          ),
        ],
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
                color: themeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: themeColor.withValues(alpha: 0.3)),
              ),
              child: Icon(
                AppIcons.folder,
                color: themeColor,
                size: AppScale.icon(18),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Screenshots',
          style: AppTextStyles.sb18.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppScale.h(16)),
        SizedBox(
          height: AppScale.h(320),
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
                        color: Colors.black.withValues(alpha: 0.85),
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
                                  iconSize: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(right: AppScale.w(16)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.border.withValues(alpha: 0.6),
                          width: 1.0,
                        ),
                      ),
                      child: Image.asset(
                        screenshot,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
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
      padding: EdgeInsets.all(AppScale.w(24)),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
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
                    onPressed: () => controller.openExternalLink(project.githubUrl),
                    icon: Icon(AppIcons.github, size: AppScale.icon(14)),
                    label: Text(
                      'GitHub',
                      style: AppTextStyles.r14.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: AppScale.font(13),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.scaffoldDark,
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
                    onPressed: () => controller.openExternalLink(project.liveUrl),
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
    );
  }

  Widget _buildFeaturesSection(ProjectModel project) {
    if (project.features.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Features',
          style: AppTextStyles.sb18.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppScale.h(16)),
        ...project.features.map(_buildFeatureItem),
      ],
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
            child: Text(
              emoji,
              style: TextStyle(fontSize: AppScale.font(14)),
            ),
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
