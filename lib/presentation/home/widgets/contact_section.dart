import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/data/models/portfolio/profile.model.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_icons.dart';
import 'package:saurav_portfolio/infrastructure/theme/app_scale.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/presentation/home/controllers/home.controller.dart';
import 'package:saurav_portfolio/widgets/buttons/primary_button.dart';
import 'package:saurav_portfolio/widgets/form_fields/app_text_field.dart';
import 'package:saurav_portfolio/widgets/icons/app_fa_icon.dart';
import 'package:saurav_portfolio/widgets/loaders/loading_spinner.dart';

/// Renders the Contact section, including a form and information card.
/// Cache-optimized with AutomaticKeepAliveClientMixin.
class ContactSection extends StatefulWidget {
  final ProfileModel? profile;

  const ContactSection({super.key, required this.profile});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final controller = Get.find<HomeController>();
    final isDesktop = AppScale.isDesktop;
    final themeColor = AppColors.accent;
    final email = widget.profile?.email ?? 'sauravsevenjune@gmail.com';

    final contactInfoCard = Container(
      padding: EdgeInsets.all(AppScale.w(24)),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.3),
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
            'Contact Information',
            style: AppTextStyles.sb18.copyWith(
              color: themeColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacing.s24.gapH,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppFaIcon(
                  AppIcons.location,
                  color: themeColor,
                  size: AppScale.icon(16),
                ),
              ),
              Spacing.s16.gapW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: AppTextStyles.sb18.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: AppScale.font(14),
                      ),
                    ),
                    4.0.gapH,
                    Text(
                      widget.profile?.location ??
                          'Rishikesh, Uttarakhand, India',
                      style: AppTextStyles.r14.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          20.0.gapH,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ContactInfoIconButton(
                icon: AppIcons.mail,
                onTap: () => controller.openExternalLink('mailto:$email'),
                accentColor: themeColor,
              ),
              Spacing.s16.gapW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email Address',
                      style: AppTextStyles.sb18.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: AppScale.font(14),
                      ),
                    ),
                    4.0.gapH,
                    GestureDetector(
                      onTap: () => controller.openExternalLink('mailto:$email'),
                      child: Text(
                        email,
                        style: AppTextStyles.r14.copyWith(
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacing.s32.gapH,
          Text(
            'Social Channels',
            style: AppTextStyles.sb18.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: AppScale.font(16),
            ),
          ),
          Spacing.s16.gapH,
          Row(
            children: [
              if (widget.profile?.githubUrl != null &&
                  widget.profile!.githubUrl!.isNotEmpty)
                _SocialIconRoundButton(
                  icon: AppIcons.github,
                  onTap: () =>
                      controller.openExternalLink(widget.profile!.githubUrl),
                  accentColor: themeColor,
                ),
              if (widget.profile?.linkedInUrl != null &&
                  widget.profile!.linkedInUrl!.isNotEmpty) ...[
                if (widget.profile!.githubUrl != null) Spacing.s12.gapW,
                _SocialIconRoundButton(
                  icon: AppIcons.linkedin,
                  onTap: () =>
                      controller.openExternalLink(widget.profile!.linkedInUrl),
                  accentColor: themeColor,
                ),
              ],
            ],
          ),
        ],
      ),
    );

    final contactFormCard = Container(
      padding: EdgeInsets.all(AppScale.w(24)),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Form(
        key: controller.contactFormKey,
        child: Column(
          children: [
            AppTextField(
              controller: controller.nameController,
              label: 'Name',
              hint: 'Your name',
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Name is required'
                  : null,
            ),
            Spacing.s16.gapH,
            AppTextField(
              controller: controller.emailController,
              label: 'Email',
              hint: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!GetUtils.isEmail(value.trim())) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            Spacing.s16.gapH,
            AppTextField(
              controller: controller.messageController,
              label: 'Message',
              hint: 'Tell me about your project...',
              maxLines: 5,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Message is required'
                  : null,
            ),
            Spacing.s24.gapH,
            Obx(() {
              if (controller.isSubmitting.value) {
                return const LoadingSpinner();
              }
              return PrimaryButton(
                label: 'Send Message',
                onPressed: controller.submitContactForm,
                icon: AppIcons.send,
                expand: true,
              );
            }),
          ],
        ),
      ),
    );

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
                'CONTACT',
                style: AppTextStyles.mono12.copyWith(
                  color: themeColor,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                  fontSize: AppScale.font(10),
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'Get in Touch',
                style: AppTextStyles.b32.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Spacing.s8.gapH,
              Text(
                'Let\'s collaborate on building your next high-tech solution',
                style: AppTextStyles.r14.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: AppScale.font(14),
                ),
              ),
              AppScale.h(48).gapH,
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: contactInfoCard),
                    Spacing.s24.gapW,
                    Expanded(flex: 3, child: contactFormCard),
                  ],
                )
              else
                Column(
                  children: [
                    contactInfoCard,
                    Spacing.s24.gapH,
                    contactFormCard,
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialIconRoundButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color accentColor;

  const _SocialIconRoundButton({
    required this.icon,
    required this.onTap,
    required this.accentColor,
  });

  @override
  State<_SocialIconRoundButton> createState() => _SocialIconRoundButtonState();
}

class _SocialIconRoundButtonState extends State<_SocialIconRoundButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: AppScale.icon(42),
          height: AppScale.icon(42),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: 0.15)
                : AppColors.surfaceDark.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor.withValues(alpha: 0.4)
                  : AppColors.border,
              width: 1.5,
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
          child: Center(
            child: AppFaIcon(
              widget.icon,
              color: _isHovered ? widget.accentColor : AppColors.textSecondary,
              size: AppScale.icon(16),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactInfoIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color accentColor;

  const _ContactInfoIconButton({
    required this.icon,
    required this.onTap,
    required this.accentColor,
  });

  @override
  State<_ContactInfoIconButton> createState() => _ContactInfoIconButtonState();
}

class _ContactInfoIconButtonState extends State<_ContactInfoIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.accentColor.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isHovered
                  ? widget.accentColor
                  : widget.accentColor.withValues(alpha: 0.35),
              width: 1.5,
            ),
          ),
          child: AppFaIcon(
            widget.icon,
            color: widget.accentColor,
            size: AppScale.icon(16),
          ),
        ),
      ),
    );
  }
}
