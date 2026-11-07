import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/domain/models/restaurant_registration.dart';

RestaurantRegistrationDraft _draft({String email = ''}) {
  return RestaurantRegistrationDraft(
    name: 'Spice Garden',
    description: 'Family-run Indian kitchen.',
    cuisineTypes: const ['Indian', 'Curry'],
    phone: '07123456789',
    email: email,
    street: '14 Silbury Boulevard',
    city: 'Milton Keynes',
    postcode: 'MK9 3QA',
    latitude: 52.0406,
    longitude: -0.7594,
    minimumOrder: 10,
    preparationTime: 30,
  );
}

void main() {
  test('builds the POST /restaurants payload without a delivery fee', () {
    final json = _draft(email: 'hello@spicegarden.co.uk').toJson();

    expect(json.containsKey('deliveryFee'), isFalse);
    expect(json['name'], 'Spice Garden');
    expect(json['cuisineType'], ['Indian', 'Curry']);
    expect(json['phone'], '07123456789');
    expect(json['email'], 'hello@spicegarden.co.uk');
    expect(json['longitude'], -0.7594);
    expect(json['latitude'], 52.0406);
    expect(json['minimumOrder'], 10);
    expect(json['preparationTime'], 30);

    final address = json['address'] as Map<String, dynamic>;
    expect(address['street'], '14 Silbury Boulevard');
    expect(address['city'], 'Milton Keynes');
    expect(address['postcode'], 'MK9 3QA');
    expect(address['country'], 'UK');
  });

  test('sends an empty email when none was entered', () {
    expect(_draft().toJson()['email'], '');
  });

  test('defaults opening hours to Monday to Saturday and closes Sunday', () {
    final hours = _draft().toJson()['operatingHours'] as Map<String, dynamic>;

    expect(hours.keys, [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ]);
    expect(hours['monday'], {'isOpen': true, 'open': '09:00', 'close': '22:00'});
    expect(hours['saturday'], {
      'isOpen': true,
      'open': '09:00',
      'close': '22:00',
    });
    expect(hours['sunday'], {
      'isOpen': false,
      'open': '09:00',
      'close': '22:00',
    });
  });
}
