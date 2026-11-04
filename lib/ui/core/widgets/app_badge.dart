import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

/// Status / label badge
class AppStatusBadge extends StatelessWidget {
  final String label;
  final Color fg;
  final Color bg;
  final IconData? icon;

  const AppStatusBadge({
    super.key,
    required this.label,
    required this.fg,
    required this.bg,
    this.icon,
  });

  factory AppStatusBadge.status(String status, {IconData? icon}) {
    final meta = AppColors.statusMeta(status);
    return AppStatusBadge(
      label: meta.label,
      fg: meta.fg,
      bg: meta.bg,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.rSm,
        border: Border.all(color: fg, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.badge.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}

typedef AppBadge = AppStatusBadge;
