import 'package:flutter/material.dart';

/// Single radius scale. No raw `BorderRadius.circular` numeric literal is
/// allowed outside this file.
abstract final class AppRadius {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;

  /// Pill — reserved for filter chips only, never buttons.
  static const double pill = 999;

  static const BorderRadius rXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius rSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius rMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius rLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius rXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius rPill = BorderRadius.all(Radius.circular(pill));

  static const Radius cXs = Radius.circular(xs);
  static const Radius cSm = Radius.circular(sm);
  static const Radius cMd = Radius.circular(md);
  static const Radius cLg = Radius.circular(lg);
  static const Radius cXl = Radius.circular(xl);
  static const Radius cPill = Radius.circular(pill);

  const AppRadius._();
}
