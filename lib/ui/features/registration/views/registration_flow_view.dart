import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_stepper.dart';
import '../providers/registration_provider.dart';
import 'register_location_step_view.dart';
import 'register_pricing_step_view.dart';
import 'register_review_step_view.dart';
import 'register_step_one_view.dart';

class RegistrationFlowView extends ConsumerWidget {
  final VoidCallback onLogout;

  const RegistrationFlowView({super.key, required this.onLogout});

  static const List<String> _stepLabels = [
    'About you',
    'Location',
    'Order rules',
    'Review',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(registrationProvider.select((s) => s.step));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            if (step > 1)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.sm,
                    top: AppSpacing.xs,
                  ),
                  child: TextButton.icon(
                    onPressed: () =>
                        ref.read(registrationProvider.notifier).previousStep(),
                    icon: const AppIcon.sm(Icons.arrow_back),
                    label: Text(
                      'Back',
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            AppStepper(
              step: step,
              label: _stepLabels[step - 1],
            ),
            Expanded(
              child: switch (step) {
                1 => RegisterStepOneView(onLogout: onLogout),
                2 => const RegisterLocationStepView(),
                3 => const RegisterPricingStepView(),
                _ => const RegisterReviewStepView(),
              },
            ),
          ],
        ),
      ),
    );
  }
}
