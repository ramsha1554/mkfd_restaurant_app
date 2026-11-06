import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Text styles per MK Foods UI standards.
abstract final class AppTextStyles {
  static const String _headingFont = 'BricolageGrotesque';
  static const String _bodyFont = 'DM Sans';

  static TextStyle get _headingBase => const TextStyle(
        fontFamily: _headingFont,
        fontFamilyFallback: ['DM Sans'],
        fontVariations: [FontVariation('wght', 700)],
        color: AppColors.textPrimary,
      );

  static TextStyle get _bodyBase => const TextStyle(
        fontFamily: _bodyFont,
        color: AppColors.textPrimary,
      );

  /// 28pt — display / large hero numbers
  static TextStyle get display => _headingBase.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.4,
      );

  /// 22pt — screen title
  static TextStyle get h1 => _headingBase.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.7,
      );

  /// 18pt — section title / card title
  static TextStyle get h2 => _headingBase.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -0.5,
      );

  /// 16pt — title
  static TextStyle get title => _headingBase.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -0.1,
      );

  /// 16pt — card title
  static TextStyle get cardTitle => _bodyBase.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -0.4,
      );

  /// 14pt — body
  static TextStyle get body => _bodyBase.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: -0.35,
      );

  /// 12pt — body secondary
  static TextStyle get bodySecondary => _bodyBase.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: -0.2,
        color: AppColors.textSecondary,
      );

  /// 12pt — caption
  static TextStyle get caption => _bodyBase.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: -0.2,
        color: AppColors.textSecondary,
      );

  /// 14pt — price
  static TextStyle get price => _bodyBase.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.35,
      );

  /// 14pt — price accent
  static TextStyle get priceAccent => _bodyBase.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.35,
        color: AppColors.primary,
      );

  /// 11pt — eyebrow
  static TextStyle get eyebrow => _bodyBase.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
        color: AppColors.textSecondary,
      );

  /// 11pt — badge
  static TextStyle get badge => _bodyBase.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
      );

  /// 12pt — section label
  static TextStyle get sectionLabel => _bodyBase.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      );

  /// 16pt — button
  static TextStyle get button => _bodyBase.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0,
      );

  /// 18pt — price large
  static TextStyle get priceLarge => _bodyBase.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: 0,
      );

  /// 22pt — otp digit
  static TextStyle get otpDigit => _bodyBase.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.7,
      );

  const AppTextStyles._();
}
