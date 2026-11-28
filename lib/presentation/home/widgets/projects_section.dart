import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/data/models/portfolio/project.model.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/presentation/home/controllers/home.controller.dart';
import 'package:saurav_portfolio/widgets/portfolio/project_card.dart';

enum ProjectCategoryFilter {
  all('All'),
  mobile('Mobile Apps'),
  packages('Packages & Tools'),
  web('Web & Platforms');

  final String label;
  const ProjectCategoryFilter(this.label);
}

/// Renders a responsive, content-driven grid of portfolio project cards with
/// filter tabs using width-based fluid Wrap layout.
/// Cache-optimized with AutomaticKeepAliveClientMixin.
class ProjectsSection extends StatefulWidget {
  final List<ProjectModel> projects;

  const ProjectsSection({super.key, required this.projects});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with AutomaticKeepAliveClientMixin {
  ProjectCategoryFilter _selectedFilter = ProjectCategoryFilter.all;

  @override
  bool get wantKeepAlive => true;

  bool _matchesFilter(ProjectModel project, ProjectCategoryFilter filter) {
    switch (filter) {
      case ProjectCategoryFilter.all:
        return true;
      case ProjectCategoryFilter.mobile:
        return project.id == '1' ||
            project.id == '2' ||
            project.id == '4' ||
            project.tags.any((t) =>
                t.toLowerCase().contains('mobile') ||
                t.toLowerCase().contains('android') ||
                t.toLowerCase().contains('ios') ||
                t.toLowerCase().contains('playstore') ||
                t.toLowerCase().contains('appstore'));
      case ProjectCategoryFilter.packages:
        return project.id == '6' ||
            (project.liveUrl != null && project.liveUrl!.contains('pub.dev')) ||
            project.tags.any((t) =>
                t.toLowerCase().contains('package') ||
                t.toLowerCase().contains('sdk') ||
                t.toLowerCase().contains('toolkit') ||
                t.toLowerCase().contains('open source') ||
                t.toLowerCase().contains('library') ||
                t.toLowerCase().contains('pub.dev'));
      case ProjectCategoryFilter.web:
        return project.id == '3' ||
            project.id == '5' ||
            project.tags.any((t) =>
                t.toLowerCase().contains('web') ||
                t.toLowerCase().contains('portal') ||
                t.toLowerCase().contains('portfolio') ||
                t.toLowerCase().contains('admin') ||
                t.toLowerCase().contains('cms'));
    }
  }

  int _countForFilter(ProjectCategoryFilter filter) {
    return widget.projects.where((p) => _matchesFilter(p, filter)).length;
  }

  void _handleProjectTap(ProjectModel project, HomeController controller) {
    if (project.id == '6' ||
        (project.liveUrl != null && project.liveUrl!.contains('pub.dev'))) {
      controller.openExternalLink(project.liveUrl);
    } else if (project.scrollToTopOnClick ||
        project.title.toLowerCase() == 'my portfolio' ||
        project.id == '5') {
      controller.scrollToTop();
    } else {
      controller.openProject(project);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = Get.find<HomeController>();

    final filteredProjects = widget.projects
        .where((p) => _matchesFilter(p, _selectedFilter))
        .toList();

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
                'My Work',
                style: AppTextStyles.b32.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'A collection of production mobile apps, open-source packages, and platforms I\'ve built',
                textAlign: TextAlign.center,
                style: AppTextStyles.r14.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: AppScale.font(14),
                ),
              ),
              AppScale.h(28).gapH,

              // Filter Category Tabs
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: ProjectCategoryFilter.values.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  final count = _countForFilter(filter);

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (_selectedFilter != filter) {
                          setState(() => _selectedFilter = filter);
                        }
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accent.withValues(alpha: 0.14)
                              : AppColors.surfaceDark.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent.withValues(alpha: 0.7)
                                : AppColors.border.withValues(alpha: 0.45),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.accent
                                        .withValues(alpha: 0.2),
                                    blurRadius: 12,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              filter.label,
                              style: AppTextStyles.mono12.copyWith(
                                color: isSelected
                                    ? AppColors.accent
                                    : AppColors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: AppScale.font(12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.accent.withValues(alpha: 0.25)
                                    : Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$count',
                                style: AppTextStyles.mono12.copyWith(
                                  color: isSelected
                                      ? AppColors.accent
                                      : AppColors.textSecondary
                                          .withValues(alpha: 0.7),
                                  fontSize: AppScale.font(10),
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

              AppScale.h(32).gapH,

              // Content-driven project layout
              if (filteredProjects.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Text(
                      'No projects found in this category.',
                      style: AppTextStyles.r14.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                )
              else if (filteredProjects.length == 1)
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: AppScale.isMobile ? double.infinity : 400,
                    ),
                    child: _AnimatedProjectCard(
                      key: ValueKey(filteredProjects.first.id),
                      index: 0,
                      child: ProjectCard(
                        project: filteredProjects.first,
                        onTap: () => _handleProjectTap(
                          filteredProjects.first,
                          controller,
                        ),
                      ),
                    ),
                  ),
                )
              else
                LayoutBuilder(
                  key: ValueKey(_selectedFilter),
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth;
                    final int columns = AppScale.isDesktop
                        ? 3
                        : (AppScale.isTablet ? 2 : 1);
                    final double gap = AppScale.w(16);
                    final double itemWidth =
                        (availableWidth - (gap * (columns - 1))) / columns;

                    return Wrap(
                      spacing: gap,
                      runSpacing: AppScale.h(16),
                      children: filteredProjects.asMap().entries.map((entry) {
                        final index = entry.key;
                        final project = entry.value;
                        return SizedBox(
                          width: itemWidth,
                          child: _AnimatedProjectCard(
                            key: ValueKey(project.id),
                            index: index,
                            child: ProjectCard(
                              project: project,
                              onTap: () =>
                                  _handleProjectTap(project, controller),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedProjectCard extends StatelessWidget {
  final Widget child;
  final int index;

  const _AnimatedProjectCard({
    super.key,
    required this.child,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 80)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final double scale = 0.95 + (value * 0.05);
        final opacity = value.clamp(0.0, 1.0);
        final translatedChild = Transform.scale(
          scale: scale,
          child: Transform.translate(
            offset: Offset(0, 24 * (1.0 - opacity)),
            child: child,
          ),
        );
        // Performance optimization: bypass Opacity, Scale, and Translate widgets once animation completes.
        if (opacity >= 1.0) {
          return this.child;
        }
        return Opacity(opacity: opacity, child: translatedChild);
      },
      child: child,
    );
  }
}
