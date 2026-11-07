import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/core/utils/uk_postcode.dart';
import 'package:mk_food_restaurant/data/services/geocoding_service.dart';

Map<String, dynamic> _feature({
  String? name,
  String? street,
  String? houseNumber,
  String? postcode,
  String? city,
  String? district,
  String? country = 'United Kingdom',
  double longitude = -0.7594,
  double latitude = 52.0406,
}) {
  return {
    'type': 'Feature',
    'geometry': {
      'type': 'Point',
      'coordinates': [longitude, latitude],
    },
    'properties': {
      'name': name,
      'street': street,
      'housenumber': houseNumber,
      'postcode': postcode,
      'city': city,
      'district': district,
      'country': country,
    },
  };
}

void main() {
  group('UK postcode helpers', () {
    test('accepts common formats regardless of case or spacing', () {
      expect(isValidUkPostcode('MK9 3QA'), isTrue);
      expect(isValidUkPostcode('mk93qa'), isTrue);
      expect(isValidUkPostcode('SW1A 0AA'), isTrue);
      expect(isValidUkPostcode('M1 1AE'), isTrue);
    });

    test('rejects malformed values', () {
      expect(isValidUkPostcode('MK9'), isFalse);
      expect(isValidUkPostcode('1234'), isFalse);
      expect(isValidUkPostcode(''), isFalse);
    });

    test('normalises to uppercase with one space', () {
      expect(normaliseUkPostcode('mk93qa'), 'MK9 3QA');
      expect(normaliseUkPostcode('  mk9   3qa '), 'MK9 3QA');
    });
  });

  group('Photon parsing', () {
    test('builds a street suggestion with a stable label', () {
      final results = ApiGeocodingService.parseFeatures([
        _feature(
          name: '14 Silbury Boulevard',
          street: 'Silbury Boulevard',
          houseNumber: '14',
          postcode: 'MK9 3QA',
          city: 'Milton Keynes',
        ),
      ]);

      expect(results, hasLength(1));
      final first = results.first;
      expect(first.street, '14 Silbury Boulevard');
      expect(first.city, 'Milton Keynes');
      expect(first.postcode, 'MK9 3QA');
      expect(first.latitude, 52.0406);
      expect(first.longitude, -0.7594);
      expect(
        first.label,
        '14 Silbury Boulevard, Milton Keynes, MK9 3QA, United Kingdom',
      );
    });

    test('drops results with neither street nor postcode', () {
      final results = ApiGeocodingService.parseFeatures([
        _feature(name: 'Milton Keynes', city: 'Milton Keynes'),
        _feature(street: 'Silbury Boulevard', postcode: 'MK9 3QA'),
      ]);

      expect(results, hasLength(1));
      expect(results.first.street, 'Silbury Boulevard');
    });

    test('falls back to district when city is missing', () {
      final results = ApiGeocodingService.parseFeatures([
        _feature(
          street: 'Silbury Boulevard',
          postcode: 'MK9 3QA',
          district: 'Central Milton Keynes',
        ),
      ]);

      expect(results.single.city, 'Central Milton Keynes');
    });

    test('ignores malformed features', () {
      final results = ApiGeocodingService.parseFeatures([
        null,
        {'type': 'Feature'},
        _feature(street: 'Silbury Boulevard'),
      ]);

      expect(results, hasLength(1));
    });
  });

  group('postcodes.io parsing', () {
    test('reads the result payload', () {
      final result = ApiGeocodingService.parseResult({
        'status': 200,
        'result': {
          'postcode': 'MK9 3QA',
          'admin_district': 'Milton Keynes',
          'region': 'South East',
          'country': 'England',
          'latitude': 52.0406,
          'longitude': -0.7594,
        },
      });

      expect(result.status, PostcodeLookupStatus.success);
      expect(result.postcode, 'MK9 3QA');
      expect(result.city, 'Milton Keynes');
      expect(result.country, 'England');
      expect(result.latitude, 52.0406);
      expect(result.longitude, -0.7594);
    });

    test('falls back to region when the district is empty', () {
      final result = ApiGeocodingService.parseResult({
        'result': {
          'postcode': 'MK9 3QA',
          'admin_district': '',
          'region': 'South East',
          'latitude': 52.0406,
          'longitude': -0.7594,
        },
      });

      expect(result.city, 'South East');
    });

    test('fails when coordinates are missing', () {
      final result = ApiGeocodingService.parseResult({
        'result': {'postcode': 'MK9 3QA'},
      });

      expect(result.status, PostcodeLookupStatus.failed);
    });
  });
}
