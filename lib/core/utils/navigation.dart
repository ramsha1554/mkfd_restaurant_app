import 'package:flutter/material.dart';
import '../animations/app_curves.dart';
import '../animations/app_durations.dart';

/// Single global navigator key — plain Navigator, no routing package.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Slide-up + fade — for drilling into a detail screen.
Route<T> slideUpFadeRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: AppDurations.medium,
    reverseTransitionDuration: AppDurations.fast,
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final curved =
          CurvedAnimation(parent: animation, curve: AppCurves.entrance);
      final offset = Tween<Offset>(
        begin: const Offset(0, 0.12),
        end: Offset.zero,
      ).animate(curved);
      final opacity = Tween<double>(begin: 0, end: 1).animate(curved);
      return FadeTransition(
        opacity: opacity,
        child: SlideTransition(position: offset, child: child),
      );
    },
  );
}

/// Slide-in-from-right + fade — for linear flows (auth, onboarding).
Route<T> slideRightFadeRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: AppDurations.medium,
    reverseTransitionDuration: AppDurations.fast,
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final curved =
          CurvedAnimation(parent: animation, curve: AppCurves.entrance);
      final offset = Tween<Offset>(
        begin: const Offset(0.12, 0),
        end: Offset.zero,
      ).animate(curved);
      final opacity = Tween<double>(begin: 0, end: 1).animate(curved);
      return FadeTransition(
        opacity: opacity,
        child: SlideTransition(position: offset, child: child),
      );
    },
  );
}

/// One shared deep-link handler for notification taps (cold start,
/// background resume, foreground tap). In Phase 0 it is a stub that
/// will be wired in Phase 6 to push the order-detail route.
void handleNotificationTap(Map<String, dynamic> data) {
  // Phase 6 will implement: extract orderId/orderNumber and push detail.
  // Keeping the single entry point now satisfies §4's requirement.
}
