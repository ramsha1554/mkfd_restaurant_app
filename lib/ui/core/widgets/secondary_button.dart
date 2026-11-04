import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

/// Outlined secondary button
class AppOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool trailingIcon;
  final double height;

  const AppOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.trailingIcon = false,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primaryText,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null && !trailingIcon) ...[
                Icon(icon, size: 20, color: AppColors.primaryText),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.button.copyWith(color: AppColors.primaryText),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (icon != null && trailingIcon) ...[
                const SizedBox(width: 8),
                Icon(icon, size: 20, color: AppColors.primaryText),
              ],
            ],
          );

    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryText,
          disabledForegroundColor: AppColors.textSecondary,
          side: const BorderSide(color: AppColors.borderStrong, width: 1.5),
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: AppTextStyles.button,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.rMd),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          child: child,
        ),
      ),
    );
  }
}

typedef SecondaryButton = AppOutlinedButton;

}
