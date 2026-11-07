import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';
import '../../../core/animations/app_durations.dart';

class AppFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingTap;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
    this.icon,
    this.trailingIcon,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.primaryLight : AppColors.cardBackground;
    final fg = selected ? AppColors.primaryText : AppColors.textSecondary;
    final weight = selected ? FontWeight.w700 : FontWeight.w500;

    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          HapticFeedback.selectionClick();
          onTap!();
        }
      },
      child: AnimatedContainer(
        duration: AppDurations.fast,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.rPill,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: fg, fontWeight: weight),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 4),
              Semantics(
                button: true,
                label: 'Remove $label',
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onTrailingTap?.call();
                  },
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: Icon(trailingIcon, size: 15, color: fg),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
