import '../../core/utils/app_log.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../models/order.dart';
import '../models/pagination_meta.dart';

class OrdersPage {
  final List<OrderModel> orders;
  final PaginationMeta pagination;

  const OrdersPage({required this.orders, required this.pagination});
}

class OrderRepository {
  final ApiClient _client;

  OrderRepository(this._client);

  Future<OrdersPage> fetchOrders({
    required String restaurantId,
    String? status,
    int page = 1,
    int limit = 25,
  }) async {
    try {
      final envelope = await _client.get(
        ApiEndpoints.restaurantOrders(restaurantId),
        queryParameters: {
          if (status != null && status.isNotEmpty) 'status': status,
          'page': page,
          'limit': limit,
        },
      );
      final orders = _parseOrders(envelope['data']);
      return OrdersPage(
        orders: orders,
        pagination: _parsePagination(
          envelope['pagination'],
          page: page,
          limit: limit,
          count: orders.length,
        ),
      );
    } catch (e, s) {
      AppLog.e('ORDER', 'fetchOrders', 'failed', e, s);
      rethrow;
    }
  }

  Future<OrderModel?> confirm(String orderId) =>
      _action(ApiEndpoints.orderConfirm(orderId));

  Future<OrderModel?> markPreparing(String orderId) =>
      _action(ApiEndpoints.orderPreparing(orderId));

  Future<OrderModel?> markReady(String orderId) =>
      _action(ApiEndpoints.orderReady(orderId));

  Future<OrderModel?> reject(String orderId, String reason) =>
      _action(ApiEndpoints.orderReject(orderId), data: {'reason': reason});

  Future<OrderModel?> verifyPickup(String orderId, String pickupCode) =>
      _action(
        ApiEndpoints.orderVerifyPickup(orderId),
        data: {'pickupCode': pickupCode},
      );

  Future<OrderModel?> _action(String path, {Map<String, dynamic>? data}) async {
    try {
      final envelope = await _client.patch(path, data: data);
      return _parseOrder(envelope['data']);
    } catch (e, s) {
      AppLog.e('ORDER', 'action', 'failed', e, s);
      rethrow;
    }
  }

  List<OrderModel> _parseOrders(Object? raw) {
    final list = _asList(raw) ?? _asList(_asMap(raw)?['orders']);
    if (list == null) return const [];
    final orders = <OrderModel>[];
    var skipped = 0;
    for (final item in list) {
      final map = _asMap(item);
      if (map == null) {
        skipped++;
        continue;
      }
      try {
        orders.add(OrderModel.fromJson(map));
      } catch (_) {
        skipped++;
      }
    }
    if (skipped > 0) {
      AppLog.w('ORDER', 'parseOrders', 'skipped invalid orders', {
        'count': skipped,
      });
    }
    return orders;
  }

  OrderModel? _parseOrder(Object? raw) {
    var map = _asMap(raw);
    if (map == null) return null;
    final nested = _asMap(map['data']);
    if (nested != null) map = nested;
    try {
      return OrderModel.fromJson(map);
    } catch (e, s) {
      AppLog.e('ORDER', 'parseOrder', 'failed', e, s);
      return null;
    }
  }

  PaginationMeta _parsePagination(
    Object? raw, {
    required int page,
    required int limit,
    required int count,
  }) {
    final map = _asMap(raw);
    if (map != null) return PaginationMeta.fromJson(map);
    return PaginationMeta(page: page, limit: limit, count: count);
  }

  List<Object?>? _asList(Object? value) {
    if (value is List) return value;
    return null;
  }

  Map<String, dynamic>? _asMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}
