import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Status / label badge — uses [AppColors.statusColor] where appropriate.
class AppBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;
  final IconData? icon;

  const AppBadge({
    super.key,
    required this.label,
    this.color,
    this.textColor,
    this.icon,
  });

  /// Badge coloured by order status string.
  factory AppBadge.status(String status, {IconData? icon}) {
    return AppBadge(
      label: status.replaceAll('_', ' ').toUpperCase(),
      color: AppColors.statusColor(status),
      textColor: AppColors.surface,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.cardFill;
    final fg = textColor ?? AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.rPill,
        border: color == null
            ? Border.all(color: AppColors.cardBorder, width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}
