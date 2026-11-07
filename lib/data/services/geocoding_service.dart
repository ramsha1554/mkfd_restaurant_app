import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/animations/app_durations.dart';
import '../../core/error/app_error.dart';
import '../../core/utils/app_log.dart';
import '../../core/utils/uk_postcode.dart';

enum PostcodeLookupStatus { success, invalidFormat, notFound, failed }

class AddressSuggestion {
  final String label;
  final String? street;
  final String? city;
  final String? postcode;
  final double latitude;
  final double longitude;

  const AddressSuggestion({
    required this.label,
    this.street,
    this.city,
    this.postcode,
    required this.latitude,
    required this.longitude,
  });
}

class PostcodeLookupResult {
  final PostcodeLookupStatus status;
  final String? postcode;
  final String? city;
  final String? country;
  final double? latitude;
  final double? longitude;

  const PostcodeLookupResult({
    required this.status,
    this.postcode,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
  });

  bool get isSuccess => status == PostcodeLookupStatus.success;
}

abstract class GeocodingService {
  Future<List<AddressSuggestion>> searchAddresses(String query);

  Future<AddressSuggestion?> reverseAddress(double latitude, double longitude);

  Future<PostcodeLookupResult> lookupPostcode(String postcode);
}

/// Address lookup against Photon and postcodes.io.
///
/// Uses its own plain [Dio] on purpose: these are unauthenticated third-party
/// services and must never receive the owner's access token.
class ApiGeocodingService implements GeocodingService {
  static const String _photonBaseUrl = 'https://photon.komoot.io';
  static const String _postcodeBaseUrl = 'https://api.postcodes.io';
  static const String _bbox = '-8.65,49.9,1.77,60.86';

  final Dio _photon;
  final Dio _postcode;

  ApiGeocodingService({Dio? photon, Dio? postcode})
      : _photon = photon ??
            Dio(
              BaseOptions(
                baseUrl: _photonBaseUrl,
                connectTimeout: AppDurations.geocoding,
                receiveTimeout: AppDurations.geocoding,
                sendTimeout: AppDurations.geocoding,
                headers: {
                  'Accept': 'application/json',
                  'User-Agent':
                      'MKFoodsRestaurant/1.0 (restaurant onboarding address lookup)',
                },
              ),
            ),
        _postcode = postcode ??
            Dio(
              BaseOptions(
                baseUrl: _postcodeBaseUrl,
                connectTimeout: AppDurations.postcodeLookup,
                receiveTimeout: AppDurations.postcodeLookup,
                sendTimeout: AppDurations.postcodeLookup,
                headers: {
                  'Accept': 'application/json',
                  'User-Agent':
                      'MKFoodsRestaurant/1.0 (restaurant onboarding address lookup)',
                },
              ),
            );

  @override
  Future<List<AddressSuggestion>> searchAddresses(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 3) return const [];
    AppLog.d('GEO', 'searchAddresses', 'lookup', {'chars': trimmed.length});
    try {
      final response = await _photon.get<Map<String, dynamic>>(
        '/api/',
        queryParameters: {
          'q': trimmed,
          'limit': 6,
          'lang': 'en',
          'bbox': _bbox,
        },
      );
      return parseFeatures(response.data?['features']);
    } on DioException catch (e, s) {
      AppLog.e('GEO', 'searchAddresses', 'failed: ${e.type}', e, s);
      throw const NetworkException('Could not search for that address.');
    }
  }

  @override
  Future<AddressSuggestion?> reverseAddress(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await _photon.get<Map<String, dynamic>>(
        '/reverse',
        queryParameters: {
          'lon': longitude,
          'lat': latitude,
          'limit': 1,
          'lang': 'en',
        },
      );
      final features = parseFeatures(
        response.data?['features'],
        allowLoose: true,
      );
      return features.isEmpty ? null : features.first;
    } on DioException catch (e, s) {
      AppLog.e('GEO', 'reverseAddress', 'failed: ${e.type}', e, s);
      return null;
    }
  }

  @override
  Future<PostcodeLookupResult> lookupPostcode(String postcode) async {
    final trimmed = postcode.trim();
    if (!isValidUkPostcode(trimmed)) {
      return const PostcodeLookupResult(
        status: PostcodeLookupStatus.invalidFormat,
      );
    }
    final compact = normaliseUkPostcode(trimmed).replaceAll(' ', '');
    AppLog.d('GEO', 'lookupPostcode', 'lookup');
    try {
      final response = await _postcode.get<Map<String, dynamic>>(
        '/postcodes/$compact',
      );
      return parseResult(response.data);
    } on DioException catch (e, s) {
      if (e.response?.statusCode == 404) {
        AppLog.i('GEO', 'lookupPostcode', 'not found');
        return const PostcodeLookupResult(
          status: PostcodeLookupStatus.notFound,
        );
      }
      AppLog.e('GEO', 'lookupPostcode', 'failed: ${e.type}', e, s);
      return const PostcodeLookupResult(status: PostcodeLookupStatus.failed);
    }
  }

  @visibleForTesting
  static List<AddressSuggestion> parseFeatures(
    Object? features, {
    bool allowLoose = false,
  }) {
    if (features is! List) return const [];
    final results = <AddressSuggestion>[];
    for (final feature in features) {
      final parsed = parseFeature(feature, allowLoose: allowLoose);
      if (parsed != null) results.add(parsed);
    }
    return results;
  }

  @visibleForTesting
  static AddressSuggestion? parseFeature(
    Object? feature, {
    bool allowLoose = false,
  }) {
    final map = _asMap(feature);
    if (map == null) return null;
    final properties = _asMap(map['properties']);
    if (properties == null) return null;

    final rawStreet = _clean(properties['street']);
    final postcode = _clean(properties['postcode']);
    final name = _clean(properties['name']);
    final city = _firstClean([
      properties['city'],
      properties['district'],
      properties['county'],
      properties['state'],
    ]);
    final country = _clean(properties['country']);

    if (!allowLoose && rawStreet == null && postcode == null) return null;

    final street = rawStreet == null
        ? (postcode != null ? name : null)
        : _join([properties['housenumber'], rawStreet]);
    final labelParts = <String?>[
      street ?? name,
      city,
      postcode,
      allowLoose ? null : country,
    ];
    final label = _uniqueJoin(labelParts);
    if (label == null) return null;

    final geometry = _asMap(map['geometry']);
    final coordinates = geometry?['coordinates'];
    if (coordinates is! List || coordinates.length < 2) return null;
    final longitude = _asDouble(coordinates[0]);
    final latitude = _asDouble(coordinates[1]);
    if (latitude == null || longitude == null) return null;

    return AddressSuggestion(
      label: label,
      street: street,
      city: city,
      postcode: postcode,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @visibleForTesting
  static PostcodeLookupResult parseResult(Object? payload) {
    final map = _asMap(payload);
    final result = _asMap(map?['result']);
    if (result == null) {
      return const PostcodeLookupResult(status: PostcodeLookupStatus.failed);
    }
    final latitude = _asDouble(result['latitude']);
    final longitude = _asDouble(result['longitude']);
    final city = _firstClean([result['admin_district'], result['region']]);
    if (latitude == null || longitude == null) {
      return const PostcodeLookupResult(status: PostcodeLookupStatus.failed);
    }
    final postcode = _clean(result['postcode']);
    return PostcodeLookupResult(
      status: PostcodeLookupStatus.success,
      postcode: postcode == null ? null : normaliseUkPostcode(postcode),
      city: city,
      country: _clean(result['country']),
      latitude: latitude,
      longitude: longitude,
    );
  }

  static Map<String, dynamic>? _asMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static String? _clean(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String? _firstClean(List<Object?> values) {
    for (final value in values) {
      final clean = _clean(value);
      if (clean != null) return clean;
    }
    return null;
  }

  static String? _join(List<Object?> values) {
    final parts = <String>[];
    for (final value in values) {
      final clean = _clean(value);
      if (clean != null && !parts.contains(clean)) parts.add(clean);
    }
    return parts.isEmpty ? null : parts.join(' ');
  }

  static String? _uniqueJoin(List<String?> values) {
    final parts = <String>[];
    for (final value in values) {
      final clean = value?.trim();
      if (clean != null && clean.isNotEmpty && !parts.contains(clean)) {
        parts.add(clean);
      }
    }
    return parts.isEmpty ? null : parts.join(', ');
  }

  static double? _asDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
