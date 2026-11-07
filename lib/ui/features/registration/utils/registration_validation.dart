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

String normaliseUkPhone(String value) {
  var digits = value.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.startsWith('44') && digits.length > 10) {
    digits = '0${digits.substring(2)}';
  } else if (digits.isNotEmpty &&
      !digits.startsWith('0') &&
      (digits.length == 10 || digits.length == 11)) {
    digits = '0$digits';
  }
  return digits;
}

bool isValidUkPhone(String value) {
  return RegExp(r'^0\d{9,10}$').hasMatch(normaliseUkPhone(value));
}

String? validatePhone(String value) {
  if (value.trim().isEmpty) return 'Enter your phone number.';
  if (!isValidUkPhone(value)) return 'Enter a valid UK phone number.';
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
  if (value < 5 || value > 180) {
    return 'Preparation time must be between 5 and 180 minutes.';
  }
  return null;
}
