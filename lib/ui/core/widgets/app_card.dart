import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Flat bordered card — 1px border, no shadow
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool dense;
  final Color? borderColor;
  final double borderWidth;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.dense = false,
    this.borderColor,
    this.borderWidth = 1,
  });

  const AppCard.dense({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderColor,
    this.borderWidth = 1,
  }) : dense = true;

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? EdgeInsets.all(dense ? 12 : 16);
    final radius = AppRadius.rMd;
    final container = Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: radius,
        border: Border.all(
          color: borderColor ?? AppColors.cardBorder,
          width: borderWidth,
        ),
      ),
      child: child,
    );

    Widget result = container;
    if (onTap != null) {
      result = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: container,
        ),
      );
    }

    if (margin != null) {
      result = Padding(padding: margin!, child: result);
    }
    return result;
  }
}
