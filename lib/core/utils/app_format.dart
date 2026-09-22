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
  static final DateFormat _dateTime =
      DateFormat('dd MMM yyyy, HH:mm', 'en_GB');
  static final DateFormat _time = DateFormat('HH:mm', 'en_GB');

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

  const AppFormat._();
}
