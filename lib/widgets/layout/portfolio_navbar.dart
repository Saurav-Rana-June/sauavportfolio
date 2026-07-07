import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';

class PortfolioNavbar extends StatelessWidget {
  const PortfolioNavbar({
    super.key,
    required this.onLogoTap,
    required this.onAboutTap,
    required this.onProjectsTap,
    required this.onContactTap,
  });

  final VoidCallback onLogoTap;
  final VoidCallback onAboutTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onContactTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1100.w),
          child: Row(
            children: [
              InkWell(
                onTap: onLogoTap,
                borderRadius: BorderRadius.circular(8),
                child: Text('Saurav.', style: AppTextStyles.sb24.copyWith(color: AppColors.primary)),
              ),
              const Spacer(),
              if (MediaQuery.sizeOf(context).width > 640) ...[
                _NavLink(label: 'About', onTap: onAboutTap),
                _NavLink(label: 'Projects', onTap: onProjectsTap),
                _NavLink(label: 'Contact', onTap: onContactTap),
              ] else
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                  onSelected: (value) {
                    switch (value) {
                      case 'about':
                        onAboutTap();
                      case 'projects':
                        onProjectsTap();
                      case 'contact':
                        onContactTap();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'about', child: Text('About')),
                    PopupMenuItem(value: 'projects', child: Text('Projects')),
                    PopupMenuItem(value: 'contact', child: Text('Contact')),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text(label, style: AppTextStyles.r16),
        ),
      ),
    );
  }
}
