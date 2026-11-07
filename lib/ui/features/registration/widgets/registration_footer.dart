import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';

class RegistrationFooter extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? extra;

  const RegistrationFooter({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.md,
            AppSpacing.screenPadding,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppPrimaryButton(
                label: label,
                onPressed: onPressed,
                isLoading: isLoading,
                icon: Icons.arrow_forward,
                trailingIcon: true,
                height: 52,
              ),
              if (extra != null) ...[
                const SizedBox(height: AppSpacing.sm),
                extra!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
