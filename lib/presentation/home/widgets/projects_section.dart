import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/data/models/portfolio/project.model.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/presentation/home/controllers/home.controller.dart';
import 'package:saurav_portfolio/widgets/portfolio/project_card.dart';

/// Renders a responsive grid of portfolio project cards.
/// Cache-optimized with AutomaticKeepAliveClientMixin.
class ProjectsSection extends StatefulWidget {
  final List<ProjectModel> projects;

  const ProjectsSection({super.key, required this.projects});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = Get.find<HomeController>();
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
                'My Work',
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
                itemCount: widget.projects.length,
                itemBuilder: (context, index) {
                  final project = widget.projects[index];
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
        final opacity = value.clamp(0.0, 1.0);
        final translatedChild = Transform.scale(
          scale: scale,
          child: Transform.translate(
            offset: Offset(0, 40 * (1.0 - opacity)),
            child: child,
          ),
        );
        // Performance optimization: bypass Opacity widget once fade animation completes.
        if (opacity >= 1.0) {
          return translatedChild;
        }
        return Opacity(opacity: opacity, child: translatedChild);
      },
      child: child,
    );
  }
}
