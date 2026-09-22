import 'package:flutter/material.dart';

/// Single source of truth for every colour used in the app.
/// No hex literal [Color(0x...)] is allowed outside this file.
abstract final class AppColors {
  // Primary — brand orange
  static const Color primary = Color(0xFFF7941D);
  static const Color primaryDark = Color(0xFFD87D0E);
  static const Color primaryLight = Color(0xFFFFF5E9);

  // Semantic
  static const Color success = Color(0xFF58CC02);
  static const Color error = Color(0xFFE23744);
  static const Color info = Color(0xFF1CB0F6);
  static const Color warning = Color(0xFFF57C00);
  static const Color rating = Color(0xFFFFC200);

  // Text
  static const Color textPrimary = Color(0xFF3C3C3C);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Surfaces
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE5E5E5);
  static const Color cardFill = Color(0xFFF7F7F7);
  static const Color divider = Color(0xFFE0E0E0);

  // Status mapping — share everywhere a status badge appears.
  // placed = warning, confirmed/preparing = info, ready/delivered = success,
  // picked_up/on_the_way = primary, rejected/cancelled = error.
  static Color statusColor(String status) {
    final s = status.toLowerCase();
    return switch (s) {
      'placed' => warning,
      'confirmed' || 'preparing' => info,
      'ready' || 'delivered' => success,
      'picked_up' || 'on_the_way' || 'picked-up' => primary,
      'rejected' || 'cancelled' => error,
      _ => textSecondary,
    };
  }

  const AppColors._();
}
