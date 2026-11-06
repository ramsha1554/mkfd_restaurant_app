import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum AppInfoBannerTone { info, success, warning, error }

class AppInfoBanner extends StatelessWidget {
  final String message;
  final String? title;
  final AppInfoBannerTone tone;
  final IconData? icon;
  final Widget? trailing;
  final bool prominent;

  const AppInfoBanner({
    super.key,
    required this.message,
    this.title,
    this.tone = AppInfoBannerTone.warning,
    this.icon,
    this.trailing,
    this.prominent = false,
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
      AppInfoBannerTone.error => (
        fg: AppColors.errorText,
        bg: AppColors.errorBg,
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: prominent ? AppSpacing.lg : AppSpacing.md,
        vertical: prominent ? AppSpacing.lg : AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: AppRadius.rSm,
        border: Border.all(color: colors.fg.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            if (prominent)
              Container(
                width: AppIconSize.xl + AppSpacing.sm,
                height: AppIconSize.xl + AppSpacing.sm,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.fg.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(icon, size: AppIconSize.sm, color: colors.fg),
              )
            else
              Icon(icon, size: AppIconSize.xs, color: colors.fg),
            SizedBox(width: prominent ? AppSpacing.md : AppSpacing.sm),
          ],
          Expanded(
            child: prominent
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null) ...[
                        Text(
                          title!,
                          style: AppTextStyles.body.copyWith(
                            color: colors.fg,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                      ],
                      Text(
                        message,
                        style: AppTextStyles.body.copyWith(color: colors.fg),
                      ),
                    ],
                  )
                : Text(
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
