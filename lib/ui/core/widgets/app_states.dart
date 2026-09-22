import 'package:flutter/material.dart';
import '../../../core/animations/app_animations.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'primary_button.dart';

/// Loading state — centered spinner with optional message.
class AppLoadingState extends StatelessWidget {
  final String? message;
  const AppLoadingState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.xlAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                message!,
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton placeholder — shimmer-like flat cards.
class AppSkeleton extends StatelessWidget {
  final int itemCount;
  const AppSkeleton({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: AppSpacing.screenPaddingAll,
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, __) => Container(
        height: 92,
        decoration: const BoxDecoration(
          color: AppColors.cardFill,
          borderRadius: AppRadius.rMd,
        ),
        foregroundDecoration: const BoxDecoration(
          borderRadius: AppRadius.rMd,
        ),
      ),
    );
  }
}

/// Empty state — illustration + message + optional action.
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Center(
        child: Padding(
          padding: AppSpacing.xlAll,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.cardFill,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36, color: AppColors.textHint),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(title, style: AppTextStyles.title, textAlign: TextAlign.center),
              if (description != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  description!,
                  style: AppTextStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: actionLabel!,
                  onPressed: onAction,
                  expanded: false,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-screen error state — icon + message + retry.
class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const AppErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Center(
        child: Padding(
          padding: AppSpacing.xlAll,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.cardFill,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36, color: AppColors.error),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Something went wrong', style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'Retry',
                  icon: Icons.refresh_outlined,
                  onPressed: onRetry,
                  expanded: false,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
