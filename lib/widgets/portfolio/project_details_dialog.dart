import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/data/models/portfolio/project.model.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_icons.dart';
import 'package:saurav_portfolio/presentation/home/controllers/home.controller.dart';

class ProjectDetailsDialog extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailsDialog({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final themeColor = AppColors.accent;
    final isMobile = AppScale.isMobile;

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppScale.pagePaddingHorizontal(),
          vertical: AppScale.h(24),
        ),
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 700,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeColor.withValues(alpha: 0.15),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    _buildHeader(context, themeColor),

                    // Scrollable Body
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppScale.pagePaddingHorizontal() + 4,
                          vertical: AppScale.h(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Description
                            Text(
                              project.description,
                              style: AppTextStyles.r16.copyWith(
                                color: AppColors.textPrimary.withValues(alpha: 0.9),
                                height: 1.6,
                                fontSize: AppScale.font(14),
                              ),
                            ),
                            SizedBox(height: AppScale.h(24)),

                            // Screenshots Gallery
                            if (project.screenshots.isNotEmpty) ...[
                              Text(
                                'Screenshots',
                                style: AppTextStyles.sb18.copyWith(
                                  color: AppColors.accent,
                                  fontSize: AppScale.font(16),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: AppScale.h(16)),
                              SizedBox(
                                height: AppScale.h(280),
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
                                        padding: EdgeInsets.only(
                                          right: AppScale.w(12),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
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
                              SizedBox(height: AppScale.h(24)),
                            ],

                            // Key Features
                            if (project.features.isNotEmpty) ...[
                              Text(
                                'Key Features',
                                style: AppTextStyles.sb18.copyWith(
                                  color: AppColors.accent,
                                  fontSize: AppScale.font(16),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: AppScale.h(16)),
                              ...project.features.map(_buildFeatureItem),
                              SizedBox(height: AppScale.h(24)),
                            ],

                            // Tech Stack
                            Text(
                              'Technologies Used',
                              style: AppTextStyles.sb18.copyWith(
                                color: AppColors.primaryLight,
                                fontSize: AppScale.font(16),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: AppScale.h(12)),
                            Wrap(
                              spacing: AppScale.w(8),
                              runSpacing: AppScale.h(8),
                              children: project.tags.map((tag) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppScale.w(12),
                                    vertical: AppScale.h(6),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(alpha: 0.25),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: AppTextStyles.mono12.copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: AppScale.font(11),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Footer
                    _buildFooter(context, themeColor),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color themeColor) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppScale.pagePaddingHorizontal() + 4,
        AppScale.h(20),
        AppScale.pagePaddingHorizontal() - 4,
        AppScale.h(20),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withValues(alpha: 0.4),
            width: 1.0,
          ),
        ),
        gradient: LinearGradient(
          colors: [
            themeColor.withValues(alpha: 0.05),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: AppScale.icon(36),
            height: AppScale.icon(36),
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: themeColor.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              AppIcons.folder,
              color: themeColor,
              size: AppScale.icon(16),
            ),
          ),
          SizedBox(width: AppScale.w(16)),
          Expanded(
            child: Text(
              project.title,
              style: AppTextStyles.sb24.copyWith(
                fontSize: AppScale.font(20),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
            color: AppColors.textSecondary,
            hoverColor: AppColors.border.withValues(alpha: 0.4),
            splashColor: Colors.transparent,
            iconSize: AppScale.icon(20),
          ),
        ],
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
            width: AppScale.w(28),
            height: AppScale.h(28),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: TextStyle(
                fontSize: AppScale.font(13),
              ),
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

  Widget _buildFooter(BuildContext context, Color themeColor) {
    final showPlayStore =
        project.playStoreUrl != null && project.playStoreUrl != '#';
    final showAppStore =
        project.appStoreUrl != null && project.appStoreUrl != '#';
    final showGithub = project.githubUrl != null && project.githubUrl != '#';
    final showLive = project.liveUrl != null && project.liveUrl != '#';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal() + 4,
        vertical: AppScale.h(16),
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.border.withValues(alpha: 0.4),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.border),
              padding: EdgeInsets.symmetric(
                horizontal: AppScale.w(16),
                vertical: AppScale.h(14),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Close',
              style: AppTextStyles.r14.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: AppScale.font(13),
              ),
            ),
          ),
          if (showPlayStore) ...[
            SizedBox(width: AppScale.w(12)),
            ElevatedButton.icon(
              onPressed: () {
                final controller = Get.find<HomeController>();
                controller.openExternalLink(project.playStoreUrl);
              },
              icon: Icon(
                AppIcons.googlePlay,
                size: AppScale.icon(14),
              ),
              label: Text(
                'Play Store',
                style: AppTextStyles.r14.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: AppScale.font(13),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceDark,
                foregroundColor: AppColors.textPrimary,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: AppScale.w(16),
                  vertical: AppScale.h(14),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                    color: AppColors.border,
                  ),
                ),
              ),
            ),
          ],
          if (showAppStore) ...[
            SizedBox(width: AppScale.w(12)),
            ElevatedButton.icon(
              onPressed: () {
                final controller = Get.find<HomeController>();
                controller.openExternalLink(project.appStoreUrl);
              },
              icon: Icon(
                AppIcons.ios,
                size: AppScale.icon(14),
              ),
              label: Text(
                'App Store',
                style: AppTextStyles.r14.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: AppScale.font(13),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceDark,
                foregroundColor: AppColors.textPrimary,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: AppScale.w(16),
                  vertical: AppScale.h(14),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                    color: AppColors.border,
                  ),
                ),
              ),
            ),
          ],
          if (showGithub) ...[
            SizedBox(width: AppScale.w(12)),
            ElevatedButton.icon(
              onPressed: () {
                final controller = Get.find<HomeController>();
                controller.openExternalLink(project.githubUrl);
              },
              icon: Icon(
                AppIcons.github,
                size: AppScale.icon(14),
              ),
              label: Text(
                'GitHub',
                style: AppTextStyles.r14.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: AppScale.font(13),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceDark,
                foregroundColor: AppColors.textPrimary,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: AppScale.w(16),
                  vertical: AppScale.h(14),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                    color: AppColors.border,
                  ),
                ),
              ),
            ),
          ],
          if (showLive) ...[
            SizedBox(width: AppScale.w(12)),
            ElevatedButton.icon(
              onPressed: () {
                final controller = Get.find<HomeController>();
                controller.openExternalLink(project.liveUrl);
              },
              icon: Icon(
                AppIcons.arrowExternal,
                size: AppScale.icon(14),
              ),
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
                padding: EdgeInsets.symmetric(
                  horizontal: AppScale.w(16),
                  vertical: AppScale.h(14),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
