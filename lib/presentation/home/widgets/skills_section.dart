import 'package:flutter/material.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';

/// Renders the skills/technical stack section of the portfolio.
/// Cache-optimized with AutomaticKeepAliveClientMixin.
class SkillsSection extends StatefulWidget {
  final List<String> skills;

  const SkillsSection({super.key, required this.skills});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
