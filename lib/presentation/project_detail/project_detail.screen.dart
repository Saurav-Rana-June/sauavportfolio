import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/presentation/project_detail/controllers/project_detail.controller.dart';
import 'package:saurav_portfolio/widgets/buttons/primary_button.dart';
import 'package:saurav_portfolio/widgets/buttons/secondary_button.dart';
import 'package:saurav_portfolio/widgets/loaders/loading_spinner.dart';
import 'package:saurav_portfolio/widgets/portfolio/skill_chip.dart';

class ProjectDetailScreen extends GetView<ProjectDetailController> {
  const ProjectDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        title: const Text('Project Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingSpinner();
        }
        final project = controller.project.value;
        if (project == null) {
          return const Center(child: Text('Project not found'));
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 860.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 220.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Icon(Icons.web_asset, size: 64, color: Colors.white70),
                    ),
                  ),
                  Spacing.s24.gapH,
                  Text(project.title, style: AppTextStyles.b32),
                  Spacing.s12.gapH,
                  Text(
                    project.techStack,
                    style: AppTextStyles.r14.copyWith(color: AppColors.accent),
                  ),
                  Spacing.s24.gapH,
                  Text(
                    project.description,
                    style: AppTextStyles.r16.copyWith(height: 1.7, color: AppColors.textSecondary),
                  ),
                  Spacing.s24.gapH,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: project.tags.map((tag) => SkillChip(label: tag)).toList(),
                  ),
                  Spacing.s32.gapH,
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      PrimaryButton(
                        label: 'Live Demo',
                        onPressed: () => controller.openExternalLink(project.liveUrl),
                        icon: Icons.open_in_new,
                      ),
                      SecondaryButton(
                        label: 'View Code',
                        onPressed: () => controller.openExternalLink(project.githubUrl),
                        icon: Icons.code,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
