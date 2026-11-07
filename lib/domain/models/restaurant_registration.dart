/// The exact payload sent to `POST /restaurants`.
///
/// Coordinates are top-level fields and `deliveryFee` is deliberately not
/// included (see `docs/Restaurant.md`).
class RestaurantRegistrationDraft {
  final String name;
  final String description;
  final List<String> cuisineTypes;
  final String phone;
  final String email;
  final String street;
  final String city;
  final String postcode;
  final double latitude;
  final double longitude;
  final double minimumOrder;
  final int preparationTime;

  const RestaurantRegistrationDraft({
    required this.name,
    required this.description,
    required this.cuisineTypes,
    required this.phone,
    required this.email,
    required this.street,
    required this.city,
    required this.postcode,
    required this.latitude,
    required this.longitude,
    required this.minimumOrder,
    required this.preparationTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'cuisineType': cuisineTypes,
      'phone': phone,
      'email': email,
      'address': {
        'street': street,
        'city': city,
        'postcode': postcode,
        'country': 'UK',
      },
      'longitude': longitude,
      'latitude': latitude,
      'minimumOrder': minimumOrder,
      'preparationTime': preparationTime,
      'operatingHours': _operatingHours(),
    };
  }

  Map<String, dynamic> _operatingHours() {
    const weekday = {'isOpen': true, 'open': '09:00', 'close': '22:00'};
    return {
      for (final day in const [
        'monday',
        'tuesday',
        'wednesday',
        'thursday',
        'friday',
        'saturday',
      ])
        day: Map<String, dynamic>.from(weekday),
      'sunday': {'isOpen': false, 'open': '09:00', 'close': '22:00'},
    };
  }
}
