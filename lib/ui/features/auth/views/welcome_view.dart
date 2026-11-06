import 'package:flutter/material.dart';

import '../../../../core/animations/app_animations.dart';
import '../../../../core/utils/navigation.dart';
import '../../../core/theme/app_colors.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Column(
                children: [
                  FadeIn(
                    duration: const Duration(milliseconds: 600),
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withValues(alpha: 0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 193,
                        height: 193,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.cardBorder, width: 1),
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/MK-Tour-Logo.png',
                          width: 70,
                          height: 70,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SlideIn.fromBottom(
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      children: [
                        Text(
                          'Run Your Kitchen',
                          style: AppTextStyles.display.copyWith(color: AppColors.textPrimary),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'From Your Pocket',
                          style: AppTextStyles.display.copyWith(color: AppColors.primary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Manage orders, menu and earnings for your restaurant, all in one place.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Spacer(),
              SlideIn.fromBottom(
                delay: const Duration(milliseconds: 250),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppPrimaryButton(
                      label: 'Get Started',
                      onPressed: () {
                        Navigator.of(context).push(
                          slideRightFadeRoute(const PhoneEntryView()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already registered? ',
                          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              slideRightFadeRoute(const PhoneEntryView()),
                            );
                          },
                          child: Text(
                            'Log in',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
