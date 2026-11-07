import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Four-segment progress header used by the registration flow.
class AppStepper extends StatelessWidget {
  final int step;
  final int total;
  final String label;

  const AppStepper({
    super.key,
    required this.step,
    required this.label,
    this.total = 4,
  });

  @override
  Widget build(BuildContext context) {
    final current = step.clamp(1, total);
    return Semantics(
      label: 'Step $current of $total, $label',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Step $current of $total',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    label.toUpperCase(),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.eyebrow.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                for (var i = 0; i < total; i++) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Container(
                      key: ValueKey('app_stepper_segment_$i'),
                      height: 4,
                      decoration: BoxDecoration(
                        color: i < current
                            ? AppColors.primary
                            : AppColors.cardBackground,
                        borderRadius: AppRadius.rPill,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
