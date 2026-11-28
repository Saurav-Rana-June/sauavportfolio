import 'package:flutter/material.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';

enum SkillCategory {
  all('All'),
  mobile('Mobile & State'),
  architecture('Architecture & APIs'),
  backend('Backend & Cloud'),
  webDesign('Web & Design');

  final String label;
  const SkillCategory(this.label);
}

class _SkillItem {
  final String name;
  final double level;
  final String subtitle;
  final SkillCategory category;

  const _SkillItem({
    required this.name,
    required this.level,
    required this.subtitle,
    required this.category,
  });
}

/// Renders the skills/technical stack section of the portfolio with category
/// filtering and responsive compact mobile optimization.
/// Cache-optimized with AutomaticKeepAliveClientMixin.
class SkillsSection extends StatefulWidget {
  final List<String> skills;

  const SkillsSection({super.key, required this.skills});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with AutomaticKeepAliveClientMixin {
  SkillCategory? _selectedCategory;

  SkillCategory get _activeCategory => _selectedCategory ?? SkillCategory.all;

  @override
  void initState() {
    super.initState();
    _selectedCategory = SkillCategory.all;
  }

  @override
  bool get wantKeepAlive => true;

  static const List<_SkillItem> _allSkills = [
    _SkillItem(
      name: 'Flutter',
      level: 0.95,
      subtitle: 'Expert',
      category: SkillCategory.mobile,
    ),
    _SkillItem(
      name: 'Dart',
      level: 0.90,
      subtitle: 'Expert',
      category: SkillCategory.mobile,
    ),
    _SkillItem(
      name: 'GetX',
      level: 0.90,
      subtitle: 'Expert',
      category: SkillCategory.mobile,
    ),
    _SkillItem(
      name: 'BLoC',
      level: 0.70,
      subtitle: 'Intermediate',
      category: SkillCategory.mobile,
    ),
    _SkillItem(
      name: 'Clean Architecture',
      level: 0.85,
      subtitle: 'Advanced',
      category: SkillCategory.architecture,
    ),
    _SkillItem(
      name: 'REST APIs',
      level: 0.90,
      subtitle: 'Advanced',
      category: SkillCategory.architecture,
    ),
    _SkillItem(
      name: 'System Design',
      level: 0.80,
      subtitle: 'Advanced',
      category: SkillCategory.architecture,
    ),
    _SkillItem(
      name: 'Firebase',
      level: 0.85,
      subtitle: 'Advanced',
      category: SkillCategory.backend,
    ),
    _SkillItem(
      name: 'Supabase',
      level: 0.80,
      subtitle: 'Advanced',
      category: SkillCategory.backend,
    ),
    _SkillItem(
      name: 'FastAPI',
      level: 0.50,
      subtitle: 'Learning',
      category: SkillCategory.backend,
    ),
    _SkillItem(
      name: 'Render',
      level: 0.70,
      subtitle: 'Intermediate',
      category: SkillCategory.backend,
    ),
    _SkillItem(
      name: 'Web (HTML/JS)',
      level: 0.80,
      subtitle: 'Advanced',
      category: SkillCategory.webDesign,
    ),
    _SkillItem(
      name: 'React.js',
      level: 0.75,
      subtitle: 'Intermediate',
      category: SkillCategory.webDesign,
    ),
    _SkillItem(
      name: 'UI/UX',
      level: 0.70,
      subtitle: 'Intermediate',
      category: SkillCategory.webDesign,
    ),
    _SkillItem(
      name: 'Figma',
      level: 0.70,
      subtitle: 'Intermediate',
      category: SkillCategory.webDesign,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isMobile = AppScale.isMobile;
    final activeCategory = _activeCategory;

    final filteredSkills = activeCategory == SkillCategory.all
        ? _allSkills
        : _allSkills.where((s) => s.category == activeCategory).toList();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppScale.pagePaddingHorizontal(),
        vertical: isMobile
            ? AppScale.h(28)
            : AppScale.sectionPaddingVertical(),
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
              SizedBox(height: isMobile ? AppScale.h(20) : AppScale.h(28)),

              // Category Filter Tabs
              Wrap(
                alignment: WrapAlignment.center,
                spacing: isMobile ? 6 : 10,
                runSpacing: isMobile ? 6 : 8,
                children: SkillCategory.values.map((category) {
                  final isSelected = activeCategory == category;
                  final count = category == SkillCategory.all
                      ? _allSkills.length
                      : _allSkills
                          .where((s) => s.category == category)
                          .length;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (_selectedCategory != category) {
                          setState(() => _selectedCategory = category);
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 10 : 14,
                          vertical: isMobile ? 5 : 7,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accent.withValues(alpha: 0.15)
                              : AppColors.surfaceDark.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent.withValues(alpha: 0.7)
                                : AppColors.border.withValues(alpha: 0.4),
                            width: isSelected ? 1.4 : 1.0,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.accent
                                        .withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              category.label,
                              style: AppTextStyles.mono12.copyWith(
                                color: isSelected
                                    ? AppColors.accent
                                    : AppColors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: AppScale.font(isMobile ? 10.5 : 11.5),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.accent.withValues(alpha: 0.25)
                                    : Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$count',
                                style: AppTextStyles.mono12.copyWith(
                                  color: isSelected
                                      ? AppColors.accent
                                      : AppColors.textSecondary
                                          .withValues(alpha: 0.7),
                                  fontSize: AppScale.font(isMobile ? 8.5 : 9.5),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: isMobile ? AppScale.h(16) : AppScale.h(24)),

              // Skills Chips
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Wrap(
                  key: ValueKey(activeCategory),
                  spacing: isMobile ? 8 : 12,
                  runSpacing: isMobile ? 8 : 12,
                  alignment: WrapAlignment.center,
                  children: filteredSkills
                      .map(
                        (skill) => _SkillTileChip(
                          skill: skill,
                          accentColor: AppColors.accent,
                          isMobile: isMobile,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillTileChip extends StatefulWidget {
  final _SkillItem skill;
  final Color accentColor;
  final bool isMobile;

  const _SkillTileChip({
    required this.skill,
    required this.accentColor,
    required this.isMobile,
  });

  @override
  State<_SkillTileChip> createState() => _SkillTileChipState();
}

class _SkillTileChipState extends State<_SkillTileChip> {
  bool _isHovered = false;

  Color _badgeColor(String subtitle) {
    switch (subtitle.toLowerCase()) {
      case 'expert':
        return widget.accentColor;
      case 'advanced':
        return const Color(0xFF10B981); // Emerald
      case 'intermediate':
        return const Color(0xFF8B5CF6); // Violet
      case 'learning':
        return const Color(0xFFF59E0B); // Amber
      default:
        return widget.accentColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final skill = widget.skill;
    final isMobile = widget.isMobile;
    final badgeColor = _badgeColor(skill.subtitle);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10 : 14,
          vertical: isMobile ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: _isHovered
              ? widget.accentColor.withValues(alpha: 0.1)
              : AppColors.surfaceDark.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
          border: Border.all(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: 0.5)
                : AppColors.border.withValues(alpha: 0.6),
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
                fontSize: AppScale.font(isMobile ? 11.5 : 13),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 5 : 6,
                vertical: isMobile ? 1.5 : 2,
              ),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: badgeColor.withValues(alpha: 0.3),
                  width: 0.8,
                ),
              ),
              child: Text(
                skill.subtitle.toUpperCase(),
                style: AppTextStyles.mono12.copyWith(
                  color: badgeColor,
                  fontSize: AppScale.font(isMobile ? 7.5 : 8.5),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
