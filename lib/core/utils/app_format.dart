import 'package:intl/intl.dart';

/// Centralised formatting — currency always £, dates always `en_GB`.
abstract final class AppFormat {
  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'en_GB',
    symbol: '£',
    decimalDigits: 2,
  );

  static final NumberFormat _currencyCompact = NumberFormat.compactCurrency(
    locale: 'en_GB',
    symbol: '£',
    decimalDigits: 1,
  );

  static final DateFormat _date = DateFormat('dd MMM yyyy', 'en_GB');
  static final DateFormat _dateTime = DateFormat('dd MMM yyyy, HH:mm', 'en_GB');
  static final DateFormat _time = DateFormat('HH:mm', 'en_GB');
  static final DateFormat _dayMonth = DateFormat('d MMM', 'en_GB');
  static final DateFormat _time12 = DateFormat('h:mm a', 'en_GB');

  /// Format a price — always £, e.g. `£12.50`.
  static String currency(num? value) {
    if (value == null) return '£0.00';
    return _currency.format(value);
  }

  static String currencyCompact(num? value) {
    if (value == null) return '£0';
    return _currencyCompact.format(value);
  }

  /// Format ISO-8601 UTC timestamp to local `en_GB` string.
  static String date(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    try {
      final d = DateTime.parse(iso).toLocal();
      return _date.format(d);
    } catch (_) {
      return iso;
    }
  }

  static String dateTime(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    try {
      final d = DateTime.parse(iso).toLocal();
      return _dateTime.format(d);
    } catch (_) {
      return iso;
    }
  }

  static String timeOfDay(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    try {
      final d = DateTime.parse(iso).toLocal();
      return _time.format(d);
    } catch (_) {
      return iso;
    }
  }

  /// Short day and month — e.g. `4 Nov`.
  static String dayMonth(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    try {
      final d = DateTime.parse(iso).toLocal();
      return _dayMonth.format(d);
    } catch (_) {
      return iso;
    }
  }

  /// Local 12-hour time — e.g. `2:15 PM`.
  static String time12(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    try {
      final d = DateTime.parse(iso).toLocal();
      return _time12.format(d);
    } catch (_) {
      return iso;
    }
  }

  static String dateFrom(DateTime d) => _date.format(d);
  static String dateTimeFrom(DateTime d) => _dateTime.format(d);

  /// `HH:mm` for operating hours picker — e.g. "09:00".
  static String hhMm(DateTime d) => _time.format(d);

  /// Parse `HH:mm` string into a [DateTime] on today's date.
  static DateTime? parseHm(String? hm) {
    if (hm == null || hm.isEmpty) return null;
    try {
      final parts = hm.split(':');
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, h, m);
    } catch (_) {
      return null;
    }
  }

  /// Phone formatting — E.164 stored, display as spaced.
  static String phone(String? raw) => raw ?? '—';

  /// Relative time for order cards — e.g. "just now", "3m ago", "2h ago".
  static String timeAgo(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    try {
      final d = DateTime.parse(iso).toLocal();
      final diff = DateTime.now().difference(d);
      if (diff.isNegative || diff.inMinutes < 1) return 'just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return _date.format(d);
    } catch (_) {
      return '—';
    }
  }

  /// First name for compact displays; returns `—` for empty input.
  static String shortName(String? value) {
    final name = value?.trim();
    if (name == null || name.isEmpty) return '—';
    return name.split(RegExp(r'\s+')).first;
  }

  const AppFormat._();
}
