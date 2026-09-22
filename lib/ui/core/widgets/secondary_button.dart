import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Secondary / outlined button — secondary action on forms, dialogs.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;
  final bool isLoading;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expanded = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: AppColors.textPrimary),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label, style: AppTextStyles.bodyLarge),
            ],
          );

    final button = OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.rSm),
        minimumSize: const Size.fromHeight(48),
        padding: AppSpacing.mdAll,
      ),
      child: child,
    );

    if (expanded) return SizedBox(width: double.infinity, child: button);
    return button;
  }
}
