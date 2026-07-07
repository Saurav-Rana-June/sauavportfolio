import 'package:flutter/material.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle.toUpperCase(),
                style: AppTextStyles.r12.copyWith(
                  color: AppColors.accent,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacing.s8.gapH,
              Text(title, style: AppTextStyles.sb24),
            ],
          ),
        ),
        if (actionLabel != null && onActionTap != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(actionLabel!, style: AppTextStyles.m16.copyWith(color: AppColors.primaryLight)),
          ),
      ],
    );
  }
}
