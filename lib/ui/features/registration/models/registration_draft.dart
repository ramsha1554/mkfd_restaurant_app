import '../../../../core/utils/uk_postcode.dart';
import '../../../../domain/models/restaurant_registration.dart';
import '../utils/registration_validation.dart';

class RegistrationDraft {
  final String name;
  final String dialCode;
  final String phone;
  final String email;
  final List<String> cuisines;
  final String description;
  final String street;
  final String city;
  final String postcode;
  final double? latitude;
  final double? longitude;
  final double minimumOrder;
  final int preparationTime;

  const RegistrationDraft({
    this.name = '',
    this.dialCode = '+44',
    this.phone = '',
    this.email = '',
    this.cuisines = const [],
    this.description = '',
    this.street = '',
    this.city = 'Milton Keynes',
    this.postcode = '',
    this.latitude,
    this.longitude,
    this.minimumOrder = 0,
    this.preparationTime = 30,
  });

  bool get hasCoordinates => latitude != null && longitude != null;

  String get fullPhone => toE164Phone(dialCode, phone);

  String get displayPhone =>
      phone.trim().isEmpty ? dialCode : '$dialCode $phone';

  RegistrationDraft copyWith({
    String? name,
    String? dialCode,
    String? phone,
    String? email,
    List<String>? cuisines,
    String? description,
    String? street,
    String? city,
    String? postcode,
    double? latitude,
    double? longitude,
    double? minimumOrder,
    int? preparationTime,
    bool clearCoordinates = false,
  }) {
    return RegistrationDraft(
      name: name ?? this.name,
      dialCode: dialCode ?? this.dialCode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      cuisines: cuisines ?? this.cuisines,
      description: description ?? this.description,
      street: street ?? this.street,
      city: city ?? this.city,
      postcode: postcode ?? this.postcode,
      latitude: clearCoordinates ? null : (latitude ?? this.latitude),
      longitude: clearCoordinates ? null : (longitude ?? this.longitude),
      minimumOrder: minimumOrder ?? this.minimumOrder,
      preparationTime: preparationTime ?? this.preparationTime,
    );
  }

  RestaurantRegistrationDraft toRequest() {
    if (latitude == null || longitude == null) {
      throw StateError('Coordinates are required before submitting.');
    }
    return RestaurantRegistrationDraft(
      name: name.trim(),
      description: description.trim(),
      cuisineTypes: List.unmodifiable(
        cuisines.map((c) => c.trim()).where((c) => c.isNotEmpty),
      ),
      phone: fullPhone,
      email: email.trim(),
      street: street.trim(),
      city: city.trim(),
      postcode: normaliseUkPostcode(postcode),
      latitude: latitude!,
      longitude: longitude!,
      minimumOrder: minimumOrder,
      preparationTime: preparationTime,
    );
  }
}
