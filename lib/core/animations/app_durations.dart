/// Single duration scale. No raw `Duration(milliseconds: …)` outside this file.
abstract final class AppDurations {
  /// 100ms — micro feedback, icon state change.
  static const Duration fastest = Duration(milliseconds: 100);

  /// 200ms — quick entrances, chip toggle, button press.
  static const Duration fast = Duration(milliseconds: 200);

  /// 300ms — standard transition, page slide, bottom sheet.
  static const Duration medium = Duration(milliseconds: 300);

  /// 450ms — large panel slide, staggered list entrance.
  static const Duration slow = Duration(milliseconds: 450);

  /// 600ms — skeleton-to-content cross-fade, max allowed for any
  /// standard interaction (see spec §5 Motion).
  static const Duration slowest = Duration(milliseconds: 600);

  /// 120ms — OTP field resize animation.
  static const Duration quick = Duration(milliseconds: 120);

  /// 250ms — short entrance delay.
  static const Duration short = Duration(milliseconds: 250);

  /// 800ms — repeating pulse animation (blinking cursor).
  static const Duration pulse = Duration(milliseconds: 800);

  /// 1300ms — skeleton/shimmer cycle.
  static const Duration shimmer = Duration(milliseconds: 1300);

  /// 3900ms — snackbar auto-dismiss.
  static const Duration snackbar = Duration(milliseconds: 3900);

  /// 15000ms — HTTP request timeout.
  static const Duration timeout = Duration(milliseconds: 15000);

  /// 1000ms — order acceptance countdown tick.
  static const Duration countdown = Duration(seconds: 1);

  /// 30000ms — active orders background refresh.
  static const Duration poll = Duration(seconds: 30);

  const AppDurations._();
}
