import 'package:flutter/material.dart';

/// Single spacing scale. No raw `EdgeInsets` numeric literal is allowed
/// outside this file (except inside this file).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Screen edge padding — 20 to 24 as per design system.
  static const double screenPadding = 20;

  static const EdgeInsets screenPaddingAll = EdgeInsets.all(screenPadding);
  static const EdgeInsets screenPaddingH = EdgeInsets.symmetric(
    horizontal: screenPadding,
  );
  static const EdgeInsets screenPaddingV = EdgeInsets.symmetric(
    vertical: screenPadding,
  );

  static const EdgeInsets xsAll = EdgeInsets.all(xs);
  static const EdgeInsets smAll = EdgeInsets.all(sm);
  static const EdgeInsets mdAll = EdgeInsets.all(md);
  static const EdgeInsets lgAll = EdgeInsets.all(lg);
  static const EdgeInsets xlAll = EdgeInsets.all(xl);
  static const EdgeInsets xxlAll = EdgeInsets.all(xxl);

  static const EdgeInsets xsH = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets smH = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets mdH = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets lgH = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets xlH = EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets xsV = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets smV = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets mdV = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets lgV = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets xlV = EdgeInsets.symmetric(vertical: xl);

  static const SizedBox gapXs = SizedBox(width: xs, height: xs);
  static const SizedBox gapSm = SizedBox(width: sm, height: sm);
  static const SizedBox gapMd = SizedBox(width: md, height: md);
  static const SizedBox gapLg = SizedBox(width: lg, height: lg);
  static const SizedBox gapXl = SizedBox(width: xl, height: xl);
  static const SizedBox gapXxl = SizedBox(width: xxl, height: xxl);

  static const SizedBox gapHxs = SizedBox(width: xs);
  static const SizedBox gapHsm = SizedBox(width: sm);
  static const SizedBox gapHmd = SizedBox(width: md);
  static const SizedBox gapHlg = SizedBox(width: lg);
  static const SizedBox gapHxl = SizedBox(width: xl);
  static const SizedBox gapHxxl = SizedBox(width: xxl);

  static const SizedBox gapVxs = SizedBox(height: xs);
  static const SizedBox gapVsm = SizedBox(height: sm);
  static const SizedBox gapVmd = SizedBox(height: md);
  static const SizedBox gapVlg = SizedBox(height: lg);
  static const SizedBox gapVxl = SizedBox(height: xl);
  static const SizedBox gapVxxl = SizedBox(height: xxl);

  const AppSpacing._();
}
