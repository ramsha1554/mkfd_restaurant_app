import 'package:flutter/material.dart';

import '../../../core/animations/app_curves.dart';
import '../../../core/animations/app_durations.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AppSwitchRow extends StatelessWidget {
  final String title;
  final String caption;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isLocked;

  const AppSwitchRow({
    super.key,
    required this.title,
    required this.caption,
    required this.value,
    this.onChanged,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = isLocked || onChanged == null;
    final reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final duration = reduceMotion ? Duration.zero : AppDurations.fast;

    return Semantics(
      container: true,
      toggled: value,
      enabled: !disabled,
      label: title,
      hint: caption,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: disabled ? null : () => onChanged!(!value),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySecondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                _Switch(
                  value: value,
                  duration: duration,
                  disabled: disabled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Switch extends StatelessWidget {
  final bool value;
  final Duration duration;
  final bool disabled;

  const _Switch({
    required this.value,
    required this.duration,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    final trackColor = disabled
        ? AppColors.cardBackground
        : (value ? AppColors.primary : AppColors.cardBorder);
    final thumbColor =
        disabled || !value ? AppColors.surface : AppColors.onPrimary;
    final border = disabled
        ? Border.all(color: AppColors.cardBorder, width: 1)
        : value
            ? null
            : Border.all(color: AppColors.borderStrong, width: 1);

    return AnimatedContainer(
      duration: duration,
      curve: AppCurves.state,
      width: 44,
      height: 24,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: AppRadius.rPill,
        border: border,
      ),
      child: AnimatedAlign(
        duration: duration,
        curve: AppCurves.state,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: thumbColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
