import 'package:flutter/material.dart';
import '../../../core/animations/app_durations.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Full-width primary action — pinned to bottom of form screens per §5.
/// Built-in loading state; disabled when [isLoading] true.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool expanded;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.surface,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: AppColors.surface),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label, style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.surface,
              )),
            ],
          );

    final button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.rSm),
        minimumSize: const Size.fromHeight(48),
        padding: AppSpacing.mdAll,
      ),
      child: AnimatedSwitcher(
        duration: AppDurations.fast,
        child: child,
      ),
    );

    if (expanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
