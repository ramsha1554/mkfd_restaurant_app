import 'package:flutter/material.dart';

import '../../../../core/animations/app_animations.dart';
import '../../../../core/utils/navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import 'phone_entry_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPaddingAll,
          child: Column(
            children: [
              const Spacer(),
              FadeIn(
                child: Column(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.restaurant_rounded,
                        size: 48,
                        color: AppColors.surface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text('MK Foods', style: AppTextStyles.display, textAlign: TextAlign.center),
                    Text('Restaurant', style: AppTextStyles.display.copyWith(color: AppColors.primary), textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Manage orders, menu and earnings\nfor your restaurant in Milton Keynes.',
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SlideIn.fromBottom(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryButton(
                      label: 'Get started',
                      icon: Icons.arrow_forward_outlined,
                      onPressed: () {
                        Navigator.of(context).push(
                          slideRightFadeRoute(const PhoneEntryView()),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Sign in with your phone number',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
