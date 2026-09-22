import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'primary_button.dart';
import 'secondary_button.dart';

/// Confirm dialog — consistent shape and actions.
class AppDialog extends StatelessWidget {
  final String title;
  final String? description;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final bool isLoading;

  const AppDialog({
    super.key,
    required this.title,
    this.description,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.isLoading = false,
  });

  static Future<bool?> showConfirm({
    required BuildContext context,
    required String title,
    String? description,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppDialog(
        title: title,
        description: description,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.rLg),
      title: Text(title, style: AppTextStyles.title),
      content: description != null
          ? Text(description!, style: AppTextStyles.body)
          : null,
      actionsPadding: AppSpacing.lgAll,
      actions: [
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: cancelLabel,
                onPressed: onCancel ?? () => Navigator.of(context).pop(false),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: isDestructive
                  ? _DestructiveButton(
                      label: confirmLabel,
                      isLoading: isLoading,
                      onPressed: onConfirm,
                    )
                  : PrimaryButton(
                      label: confirmLabel,
                      isLoading: isLoading,
                      onPressed: onConfirm,
                    ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DestructiveButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _DestructiveButton({
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.rSm),
        minimumSize: const Size.fromHeight(48),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.surface,
              ),
            )
          : Text(
              label,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.surface,
              ),
            ),
    );
  }
}

/// Simple info dialog.
Future<void> showAppInfoDialog({
  required BuildContext context,
  required String title,
  String? description,
  String buttonLabel = 'OK',
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.rLg),
      title: Text(title, style: AppTextStyles.title),
      content: description != null
          ? Text(description, style: AppTextStyles.body)
          : null,
      actions: [
        PrimaryButton(
          label: buttonLabel,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
