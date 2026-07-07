import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saurav_portfolio/data/extensions/spacing.dart';
import 'package:saurav_portfolio/infrastructure/theme/colors.dart';
import 'package:saurav_portfolio/infrastructure/theme/text_styles.dart';
import 'package:saurav_portfolio/presentation/landing/controllers/landing.controller.dart';
import 'package:saurav_portfolio/widgets/buttons/primary_button.dart';
import 'package:saurav_portfolio/widgets/loaders/loading_spinner.dart';

class LandingScreen extends GetView<LandingController> {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.code, color: Colors.white, size: 40),
                ),
                Spacing.s32.gapH,
                Text('Saurav', style: AppTextStyles.b48),
                Spacing.s12.gapH,
                Text(
                  'Senior Flutter Developer & System Designer',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.r16.copyWith(color: AppColors.textSecondary),
                ),
                Spacing.s40.gapH,
                Obx(() {
                  if (controller.isNavigating.value) {
                    return const LoadingSpinner();
                  }
                  return PrimaryButton(
                    label: 'Enter Portfolio',
                    onPressed: controller.enterPortfolio,
                    icon: Icons.arrow_forward_rounded,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
