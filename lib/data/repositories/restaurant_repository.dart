import '../../core/error/app_error.dart';
import '../../core/utils/app_log.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../models/restaurant.dart';

class RestaurantRepository {
  final ApiClient _client;

  RestaurantRepository(this._client);

  Future<RestaurantModel?> getMyRestaurant() async {
    try {
      final envelope = await _client.get(ApiEndpoints.myRestaurant);
      return _restaurantFrom(envelope['data']);
    } on ApiException catch (e, s) {
      if (e.statusCode == 404) {
        AppLog.i('STORE', 'getMyRestaurant', 'no restaurant yet');
        return null;
      }
      AppLog.e('STORE', 'getMyRestaurant', 'failed', e, s);
      rethrow;
    } catch (e, s) {
      AppLog.e('STORE', 'getMyRestaurant', 'failed', e, s);
      rethrow;
    }
  }

  Future<RestaurantModel?> updateStatus(
    String id, {
    bool? isOpen,
    bool? isBusy,
  }) async {
    final body = <String, dynamic>{
      if (isOpen != null) 'isOpen': isOpen,
      if (isBusy != null) 'isBusy': isBusy,
    };
    final envelope = await _client.patch(
      ApiEndpoints.restaurantStatus(id),
      data: body,
    );
    return _restaurantFrom(envelope['data']);
  }

  RestaurantModel? _restaurantFrom(Object? raw) {
    var map = _asMap(raw);
    if (map == null) return null;

    final nested = _asMap(map['data']);
    if (nested != null) map = nested;

    if (!map.containsKey('_id') &&
        !map.containsKey('id') &&
        !map.containsKey('name')) {
      return null;
    }
    return RestaurantModel.fromJson(map);
  }

  Map<String, dynamic>? _asMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}
