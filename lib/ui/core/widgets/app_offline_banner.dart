import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AppOfflineBanner extends StatelessWidget {
  const AppOfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: AppRadius.rSm,
        border: Border.all(
          color: AppColors.warningText.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: AppIconSize.sm,
            color: AppColors.warningText,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You're offline",
                  style: AppTextStyles.sectionLabel.copyWith(
                    color: AppColors.warningText,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Showing last known orders. Actions are locked until '
                  'the connection returns.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warningText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
