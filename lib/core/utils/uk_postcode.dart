/// UK postcode helpers shared by the registration form and the geocoding
/// service. Pure functions only — no network access.
final RegExp _ukPostcodePattern = RegExp(
  r'^[A-Z]{1,2}\d[A-Z\d]?\s*\d[A-Z]{2}$',
  caseSensitive: false,
);

bool isValidUkPostcode(String value) {
  return _ukPostcodePattern.hasMatch(value.trim());
}

/// Uppercases and inserts the single space before the final three characters.
String normaliseUkPostcode(String value) {
  final compact = value.replaceAll(RegExp(r'\s+'), '').toUpperCase();
  if (compact.length < 5) return compact;
  return '${compact.substring(0, compact.length - 3)} '
      '${compact.substring(compact.length - 3)}';
}
