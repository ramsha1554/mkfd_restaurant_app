import 'package:flutter/material.dart';
import '../../../core/animations/app_durations.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Consistent bottom-sheet layout with drag handle per §5.
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;
  final bool showHandle;

  const AppBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.actions,
    this.showHandle = true,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    List<Widget>? actions,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => AppBottomSheet(
        title: title,
        actions: actions,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showHandle) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: 36,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: AppRadius.rPill,
                ),
              ),
            ],
            if (title != null) ...[
              Padding(
                padding: AppSpacing.lgAll,
                child: Text(title!, style: AppTextStyles.title),
              ),
              const Divider(height: 1),
            ],
            Flexible(
              child: SingleChildScrollView(
                padding: AppSpacing.lgAll,
                child: child,
              ),
            ),
            if (actions != null && actions!.isNotEmpty) ...[
              const Divider(height: 1),
              Padding(
                padding: AppSpacing.lgAll,
                child: Row(
                  children: [
                    for (var i = 0; i < actions!.length; i++) ...[
                      Expanded(child: actions![i]),
                      if (i != actions!.length - 1)
                        const SizedBox(width: AppSpacing.md),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

/// Helper to show a bottom sheet with slide animation using AppDurations.
Future<T?> showAppSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    transitionAnimationController: AnimationController(
      vsync: Navigator.of(context),
      duration: AppDurations.medium,
    ),
    builder: builder,
  );
}
