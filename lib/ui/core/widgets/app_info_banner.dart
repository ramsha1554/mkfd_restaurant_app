import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum AppInfoBannerTone { info, success, warning, error }

class AppInfoBanner extends StatelessWidget {
  final String message;
  final AppInfoBannerTone tone;
  final IconData? icon;
  final Widget? trailing;

  const AppInfoBanner({
    super.key,
    required this.message,
    this.tone = AppInfoBannerTone.warning,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      AppInfoBannerTone.info => (fg: AppColors.infoText, bg: AppColors.infoBg),
      AppInfoBannerTone.success => (
          fg: AppColors.successText,
          bg: AppColors.successBg,
        ),
      AppInfoBannerTone.warning => (
          fg: AppColors.warningText,
          bg: AppColors.warningBg,
        ),
      AppInfoBannerTone.error => (fg: AppColors.errorText, bg: AppColors.errorBg),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: AppRadius.rSm,
        border: Border.all(
          color: colors.fg.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppIconSize.xs, color: colors.fg),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption.copyWith(
                color: colors.fg,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}
