import 'package:flutter/material.dart';

/// Single icon-size scale. No second icon package without approval;
/// `_outlined` variants preferred.
abstract final class AppIconSize {
  static const double xs = 16;
  static const double sm = 20;
  static const double md = 24;
  static const double lg = 28;
  static const double xl = 32;

  const AppIconSize._();
}

/// Convenience helper to create consistently-sized icons.
class AppIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final String? semanticLabel;

  const AppIcon(
    this.icon, {
    super.key,
    this.size = AppIconSize.md,
    this.color,
    this.semanticLabel,
  });

  const AppIcon.xs(
    this.icon, {
    super.key,
    this.color,
    this.semanticLabel,
  }) : size = AppIconSize.xs;

  const AppIcon.sm(
    this.icon, {
    super.key,
    this.color,
    this.semanticLabel,
  }) : size = AppIconSize.sm;

  const AppIcon.lg(
    this.icon, {
    super.key,
    this.color,
    this.semanticLabel,
  }) : size = AppIconSize.lg;

  const AppIcon.xl(
    this.icon, {
    super.key,
    this.color,
    this.semanticLabel,
  }) : size = AppIconSize.xl;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: color,
      semanticLabel: semanticLabel,
    );
  }
}
