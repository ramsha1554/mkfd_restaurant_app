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

  const AppDurations._();
}
