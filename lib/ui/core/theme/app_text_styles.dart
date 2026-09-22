import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Exactly seven named text styles using Nunito Sans via google_fonts.
/// No screen may write `TextStyle(fontSize: …)` directly.
abstract final class AppTextStyles {
  static TextStyle get _base => GoogleFonts.nunitoSans(
        color: AppColors.textPrimary,
      );

  /// 28pt — display / large hero numbers
  static TextStyle get display => _base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.2,
        letterSpacing: -0.5,
      );

  /// 22pt — screen title
  static TextStyle get heading => _base.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  /// 18pt — section title / card title
  static TextStyle get title => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.35,
      );

  /// 16pt — body large / button label
  static TextStyle get bodyLarge => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
      );

  /// 14pt — body regular
  static TextStyle get body => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// 13pt — body small / secondary info
  static TextStyle get bodySmall => _base.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: AppColors.textSecondary,
      );

  /// 11pt — eyebrow / badge / caption
  static TextStyle get caption => _base.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: 0.6,
      );

  // Convenience variants — still count as the seven base styles,
  // just colour/weight overrides.

  static TextStyle get displaySecondary => display.copyWith(
        color: AppColors.textSecondary,
      );

  static TextStyle get headingSecondary => heading.copyWith(
        color: AppColors.textSecondary,
      );

  static TextStyle get bodyHint => body.copyWith(
        color: AppColors.textHint,
      );

  static TextStyle get bodySmallHint => bodySmall.copyWith(
        color: AppColors.textHint,
      );

  static TextStyle get captionPrimary => caption.copyWith(
        color: AppColors.primary,
      );

  const AppTextStyles._();
}
