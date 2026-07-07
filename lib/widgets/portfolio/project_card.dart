import 'package:flutter/material.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/data/models/portfolio/project.model.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  final ProjectModel project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.folder_outlined, color: AppColors.primary),
            ),
            Spacing.s16.gapH,
            Text(
              project.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.sb18,
            ),
            Spacing.s8.gapH,
            Expanded(
              child: Text(
                project.description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.r14.copyWith(height: 1.5),
              ),
            ),
            Spacing.s12.gapH,
            Text(
              project.techStack,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.r12.copyWith(color: AppColors.accent),
            ),
          ],
        ),
      ),
    );
  }
}
