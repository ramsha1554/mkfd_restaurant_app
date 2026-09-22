import 'package:flutter/material.dart';
import '../../../core/animations/app_durations.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Snackbar / toast — only place that shows transient messages.
/// UI must not render `error.toString()` directly; use [AppError.message].
abstract final class AppSnackbar {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
    Duration duration = AppDurations.slow,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              size: 20,
              color: AppColors.surface,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.body.copyWith(color: AppColors.surface),
              ),
            ),
          ],
        ),
        backgroundColor:
            isError ? AppColors.error : AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.rSm),
        margin: const EdgeInsets.all(AppSpacing.lg),
        duration: duration,
      ),
    );
  }

  static void showError(BuildContext context, String message) =>
      show(context, message, isError: true);

  static void showSuccess(BuildContext context, String message) =>
      show(context, message);

  const AppSnackbar._();
}
