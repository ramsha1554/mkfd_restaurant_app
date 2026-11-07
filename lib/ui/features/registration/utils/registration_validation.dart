import '../../../../core/utils/uk_postcode.dart';

const List<String> kSuggestedCuisines = [
  'Indian',
  'Curry',
  'Italian',
  'Chinese',
  'Pizza',
  'Burgers',
  'Desserts',
  'Vegetarian',
  'Thai',
  'Mexican',
];

String? validateRestaurantName(String value) {
  if (value.trim().isEmpty) return 'Enter your restaurant name.';
  if (value.trim().length < 2) return 'Restaurant name is too short.';
  return null;
}

String normaliseNationalPhone(String dialCode, String value) {
  final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
  final codeDigits = dialCode.replaceAll(RegExp(r'[^0-9]'), '');
  var national = digits;
  if (codeDigits.isNotEmpty && national.startsWith(codeDigits)) {
    national = national.substring(codeDigits.length);
  }
  if (dialCode == '+44' && national.startsWith('0')) {
    national = national.substring(1);
  }
  return national;
}

String toE164Phone(String dialCode, String value) {
  return '$dialCode${normaliseNationalPhone(dialCode, value)}';
}

bool isValidPhone(String dialCode, String value) {
  final national = normaliseNationalPhone(dialCode, value);
  if (dialCode == '+44') return RegExp(r'^7\d{9}$').hasMatch(national);
  return national.length >= 7 && national.length <= 12;
}

String? validatePhone(String dialCode, String value) {
  if (value.trim().isEmpty) return 'Enter your phone number.';
  if (!isValidPhone(dialCode, value)) {
    return 'Enter a valid phone number.';
  }
  return null;
}

String? validateEmail(String value) {
  final email = value.trim();
  if (email.isEmpty) return 'Enter your email address.';
  final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!pattern.hasMatch(email)) return 'Enter a valid email address.';
  return null;
}

String? validateCuisines(List<String> cuisines) {
  if (cuisines.isEmpty) return 'Select at least one cuisine type.';
  return null;
}

String? validateStreet(String value) {
  if (value.trim().isEmpty) return 'Enter your street address.';
  return null;
}

String? validateCity(String value) {
  if (value.trim().isEmpty) return 'Enter your city.';
  return null;
}

String? validatePostcode(String value) {
  final postcode = value.trim();
  if (postcode.isEmpty) return 'Enter your postcode.';
  if (!isValidUkPostcode(postcode)) return 'Enter a valid UK postcode.';
  return null;
}

String? validateCoordinates(double? latitude, double? longitude) {
  if (latitude == null || longitude == null) {
    return 'Set your exact location on the map.';
  }
  return null;
}

String? validateMinimumOrder(double value) {
  if (value < 0) return 'Minimum order cannot be negative.';
  return null;
}

String? validatePreparationTime(int value) {
  if (value < 5 || value > 60) {
    return 'Preparation time must be between 5 and 60 minutes.';
  }
  return null;
}
