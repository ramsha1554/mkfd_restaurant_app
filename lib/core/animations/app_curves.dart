import 'package:flutter/material.dart';

/// Single curve set per §5 Motion.
abstract final class AppCurves {
  /// Ease-out for entrances.
  static const Curve entrance = Curves.easeOut;

  /// Ease-in for exits.
  static const Curve exit = Curves.easeIn;

  /// Ease-in-out for state changes.
  static const Curve state = Curves.easeInOut;

  /// Elastic — reserved for small tactile feedback only.
  static const Curve tactile = Curves.elasticOut;

  /// Decelerate for large panel slides.
  static const Curve panel = Curves.decelerate;

  const AppCurves._();
}
