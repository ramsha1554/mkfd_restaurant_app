import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../../../core/animations/app_durations.dart';

/// Full-width primary action
class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool trailingIcon;
  final double height;
  final bool destructive;

  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.trailingIcon = false,
    this.height = 52,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final foreground =
        destructive ? AppColors.onError : AppColors.onPrimary;
    final background = destructive ? AppColors.error : AppColors.primary;
    final pressed = destructive ? AppColors.errorText : AppColors.primaryDark;

    final child = isLoading
        ? SizedBox(
            width: AppIconSize.sm,
            height: AppIconSize.sm,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: foreground,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null && !trailingIcon) ...[
                Icon(icon, size: AppIconSize.sm, color: foreground),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.button.copyWith(color: foreground),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (icon != null && trailingIcon) ...[
                const SizedBox(width: AppSpacing.sm),
                Icon(icon, size: AppIconSize.sm, color: foreground),
              ],
            ],
          );

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: AppColors.cardBackground,
          disabledForegroundColor: AppColors.textSecondary,
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: AppTextStyles.button,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.rMd),
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) return pressed;
            if (states.contains(WidgetState.disabled)) {
              return AppColors.cardBackground;
            }
            return background;
          }),
        ),
        child: AnimatedSwitcher(
          duration: AppDurations.fastest,
          child: child,
        ),
      ),
    );
  }
}

typedef PrimaryButton = AppPrimaryButton;
