import 'package:flutter/material.dart';

/// Single source of truth for every colour used in the app.
/// No hex literal [Color(0x...)] is allowed outside this file.
abstract final class AppColors {
  // Primary
  static const Color primary = Color(0xFFD33E11);
  static const Color primaryDark = Color(0xFFA92F0B);
  static const Color primaryLight = Color(0xFFFFE9DE);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFFA92F0B);
  static const Color secondary = Color(0xFFFFB74D);
  static const Color onSecondary = Color(0xFF1E1B18);

  // Semantic
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFD81B3C);
  static const Color info = Color(0xFF2F80ED);
  static const Color warning = Color(0xFFA66900);
  static const Color rating = Color(0xFFFFB400);
  static const Color onError = Color(0xFFFFFFFF);

  // Semantic text/bg
  static const Color successText = Color(0xFF1B5E20);
  static const Color errorText = Color(0xFFA8112B);
  static const Color warningText = Color(0xFF6B4300);
  static const Color infoText = Color(0xFF1556A8);
  static const Color successBg = Color(0xFFE6F4E7);
  static const Color errorBg = Color(0xFFFDEAEE);
  static const Color warningBg = Color(0xFFFFF4D6);
  static const Color infoBg = Color(0xFFE8F1FD);

  // Text
  static const Color textPrimary = Color(0xFF1E1B18);
  static const Color textSecondary = Color(0xFF6A615A);
  static const Color textHint = Color(0xFF9A9189);

  // Surfaces
  static const Color background = Color(0xFFFFFBF5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFEBDFD3);
  static const Color cardBackground = Color(0xFFF4EFE9);
  static const Color shadow = Color(0xFFD9CCC0);
  static const Color borderStrong = Color(0xFF8F867E);
  static const Color divider = Color(0xFFF0E6DB);
  static const Color scrim = Color(0x8C1E1B18);

  /// Returns (label, fg, bg) status meta per MK Foods standard.
  static ({String label, Color fg, Color bg}) statusMeta(String status) {
    final s = status.toLowerCase().replace('_', '');
    return switch (s) {
      'placed' => (label: 'Order Placed', fg: warningText, bg: warningBg),
      'confirmed' => (label: 'Confirmed', fg: infoText, bg: infoBg),
      'preparing' => (label: 'Preparing', fg: infoText, bg: infoBg),
      'ready' => (label: 'Ready', fg: successText, bg: successBg),
      'delivered' => (label: 'Delivered', fg: successText, bg: successBg),
      'pickedup' => (label: 'Picked Up', fg: primaryText, bg: surface),
      'ontheway' => (label: 'On the Way', fg: primaryText, bg: surface),
      'arrivedatrestaurant' => (label: 'Driver at restaurant', fg: primaryText, bg: surface),
      'driverwaiting' => (label: 'Driver waiting', fg: warningText, bg: warningBg),
      'pendingpayment' => (label: 'Awaiting Payment', fg: infoText, bg: infoBg),
      'rejected' => (label: 'Rejected', fg: errorText, bg: errorBg),
      'cancelled' => (label: 'Cancelled', fg: errorText, bg: errorBg),
      'expired' => (label: 'Expired', fg: errorText, bg: errorBg),
      'failed' => (label: 'Failed', fg: errorText, bg: errorBg),
      _ => (label: status, fg: textSecondary, bg: cardBackground),
    };
  }

  const AppColors._();
}

  const AppColors._();
}
