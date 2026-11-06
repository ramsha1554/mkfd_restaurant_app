import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_card.dart';

class AppSectionCard extends StatelessWidget {
  final String? eyebrow;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppSectionCard({
    super.key,
    this.eyebrow,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final label = eyebrow?.trim();
    return AppCard(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null && label.isNotEmpty) ...[
            Text(
              label.toUpperCase(),
              style: AppTextStyles.eyebrow.copyWith(letterSpacing: 0.8),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          child,
        ],
      ),
    );
  }
}
