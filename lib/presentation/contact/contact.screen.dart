import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/presentation/contact/controllers/contact.controller.dart';
import 'package:saurav_portfolio/widgets/buttons/primary_button.dart';
import 'package:saurav_portfolio/widgets/form_fields/app_text_field.dart';
import 'package:saurav_portfolio/widgets/layout/section_header.dart';
import 'package:saurav_portfolio/widgets/loaders/loading_spinner.dart';

class ContactScreen extends GetView<ContactController> {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        title: const Text('Contact'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 640.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'Get in Touch',
                  subtitle: 'Send me a message',
                ),
                Spacing.s24.gapH,
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: controller.nameController,
                        label: 'Name',
                        hint: 'Your name',
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'Name is required' : null,
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
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'Message is required' : null,
                      ),
                      Spacing.s24.gapH,
                      Obx(() {
                        if (controller.isSubmitting.value) {
                          return const LoadingSpinner();
                        }
                        return PrimaryButton(
                          label: 'Send Message',
                          onPressed: controller.submitForm,
                          icon: Icons.send,
                          expand: true,
                        );
                      }),
                    ],
                  ),
                ),
                Spacing.s32.gapH,
                Text(
                  'Prefer email? Reach out at hello@saurav.dev',
                  style: AppTextStyles.r14.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
