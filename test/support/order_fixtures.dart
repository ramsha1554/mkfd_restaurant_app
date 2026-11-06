import 'dart:async';

import 'package:mk_food_restaurant/data/models/order.dart';
import 'package:mk_food_restaurant/data/models/pagination_meta.dart';
import 'package:mk_food_restaurant/data/repositories/order_repository.dart';

OrderStatus orderStatusFrom(String status) {
  return switch (status) {
    'placed' => OrderStatus.placed,
    'confirmed' => OrderStatus.confirmed,
    'preparing' => OrderStatus.preparing,
    'ready' => OrderStatus.ready,
    'arrived_at_restaurant' => OrderStatus.arrivedAtRestaurant,
    'picked_up' => OrderStatus.pickedUp,
    'on_the_way' => OrderStatus.onTheWay,
    'delivered' => OrderStatus.delivered,
    'cancelled' => OrderStatus.cancelled,
    'rejected' => OrderStatus.rejected,
    'expired' => OrderStatus.expired,
    'failed' => OrderStatus.failed,
    _ => OrderStatus.unknown,
  };
}

OrderModel orderFixture({
  required String id,
  required String status,
  String? createdAt,
  String? customerName = 'Sample Customer',
  String? customerPhone,
  OrderAddress? deliveryAddress,
  String? driverName,
  String? driverPhone,
  bool? driverWaiting,
  double subtotal = 10,
  double? commissionRate,
  double? commissionAmount,
  String? paymentMethod,
  String? paymentStatus,
  String? specialInstructions,
  String? acceptanceExpiresAt,
  List<OrderItem>? items,
}) {
  return OrderModel(
    id: id,
    orderNumber: id,
    customer: OrderCustomer(name: customerName, phone: customerPhone),
    driver: driverName == null && driverPhone == null
        ? null
        : OrderDriver(name: driverName, phone: driverPhone),
    deliveryAddress: deliveryAddress,
    items:
        items ??
        [
          OrderItem(
            name: 'Item',
            price: subtotal,
            quantity: 1,
            itemTotal: subtotal,
          ),
        ],
    subtotal: subtotal,
    total: subtotal,
    commissionRate: commissionRate,
    commissionAmount: commissionAmount,
    paymentMethod: paymentMethod,
    paymentStatus: paymentStatus,
    specialInstructions: specialInstructions,
    acceptanceExpiresAt: acceptanceExpiresAt,
    status: orderStatusFrom(status),
    rawStatus: status,
    createdAt: createdAt,
    driverWaiting: driverWaiting,
  );
}

class FakeOrderRepository implements OrderRepository {
  final Map<String, OrdersPage> pages = {};
  Object? fetchError;
  Object? actionError;
  OrderModel? actionResult;
  Completer<void>? actionGate;
  int fetchCalls = 0;
  int confirmCalls = 0;
  int verifyPickupCalls = 0;
  String? lastRejectReason;
  String? lastPickupCode;

  String key(String? status, int page) => '${status ?? 'all'}|$page';

  void setPage({
    String? status,
    int page = 1,
    required List<OrderModel> orders,
    PaginationMeta? pagination,
  }) {
    pages[key(status, page)] = OrdersPage(
      orders: orders,
      pagination:
          pagination ??
          PaginationMeta(page: page, limit: 25, total: orders.length),
    );
  }

  @override
  Future<OrdersPage> fetchOrders({
    required String restaurantId,
    String? status,
    int page = 1,
    int limit = 25,
  }) async {
    fetchCalls++;
    final error = fetchError;
    if (error != null) throw error;
    return pages[key(status, page)] ??
        OrdersPage(
          orders: const [],
          pagination: PaginationMeta(page: page, limit: limit, total: 0),
        );
  }

  @override
  Future<OrderModel?> confirm(String orderId) async {
    confirmCalls++;
    return _action();
  }

  @override
  Future<OrderModel?> markPreparing(String orderId) => _action();

  @override
  Future<OrderModel?> markReady(String orderId) => _action();

  @override
  Future<OrderModel?> reject(String orderId, String reason) async {
    lastRejectReason = reason;
    return _action();
  }

  @override
  Future<OrderModel?> verifyPickup(String orderId, String pickupCode) async {
    verifyPickupCalls++;
    lastPickupCode = pickupCode;
    return _action();
  }

  Future<OrderModel?> _action() async {
    final gate = actionGate;
    if (gate != null) await gate.future;
    final error = actionError;
    if (error != null) throw error;
    return actionResult;
  }
}
