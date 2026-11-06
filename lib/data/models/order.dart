// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

enum OrderStatus {
  @JsonValue('placed')
  placed,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('preparing')
  preparing,
  @JsonValue('ready')
  ready,
  @JsonValue('arrived_at_restaurant')
  arrivedAtRestaurant,
  @JsonValue('picked_up')
  pickedUp,
  @JsonValue('on_the_way')
  onTheWay,
  @JsonValue('delivered')
  delivered,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('rejected')
  rejected,
  @JsonValue('expired')
  expired,
  @JsonValue('failed')
  failed,
  @JsonValue('pending_payment')
  pendingPayment,
  @JsonValue('pending')
  pending,
  @JsonValue('unknown')
  unknown,
}

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    @JsonKey(name: '_id') String? id,
    String? orderNumber,
    String? restaurantId,
    OrderCustomer? customer,
    OrderDriver? driver,
    List<OrderItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? driverFee,
    double? platformFee,
    double? commissionRate,
    double? commissionAmount,
    double? restaurantPayout,
    double? total,
    String? paymentMethod,
    String? paymentStatus,
    OrderStatus? status,
    String? rawStatus,
    List<OrderStatusEvent>? statusHistory,
    OrderAddress? deliveryAddress,
    String? specialInstructions,
    String? rejectionReason,
    String? cancellationReason,
    String? acceptanceExpiresAt,
    String? paymentExpiresAt,
    String? estimatedDeliveryTime,
    String? actualDeliveryTime,
    String? createdAt,
    String? updatedAt,
    bool? driverWaiting,
    bool? driverArrived,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(_normalizeOrder(json));
}

@freezed
class OrderCustomer with _$OrderCustomer {
  const factory OrderCustomer({
    @JsonKey(name: '_id') String? id,
    String? name,
    String? phone,
  }) = _OrderCustomer;

  factory OrderCustomer.fromJson(Map<String, dynamic> json) =>
      _$OrderCustomerFromJson(json);
}

@freezed
class OrderDriver with _$OrderDriver {
  const factory OrderDriver({
    @JsonKey(name: '_id') String? id,
    String? name,
    String? phone,
  }) = _OrderDriver;

  factory OrderDriver.fromJson(Map<String, dynamic> json) =>
      _$OrderDriverFromJson(json);
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    String? menuItemId,
    String? name,
    double? price,
    int? quantity,
    double? itemTotal,
    String? specialInstructions,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

@freezed
class OrderStatusEvent with _$OrderStatusEvent {
  const factory OrderStatusEvent({
    String? status,
    String? timestamp,
    String? note,
  }) = _OrderStatusEvent;

  factory OrderStatusEvent.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusEventFromJson(json);
}

@freezed
class OrderAddress with _$OrderAddress {
  const factory OrderAddress({
    String? label,
    String? fullAddress,
  }) = _OrderAddress;

  factory OrderAddress.fromJson(Map<String, dynamic> json) =>
      _$OrderAddressFromJson(json);
}

Map<String, dynamic> _normalizeOrder(Map<String, dynamic> json) {
  final statusRaw = _string(json['status']);
  final customer = _normalizeCustomer(json);
  final driver = _normalizeDriver(json);
  final items = _normalizeItems(json['items']);
  final history = _normalizeHistory(json['statusHistory']);
  final address = _normalizeAddress(json['deliveryAddress']);

  return <String, dynamic>{
    '_id': _string(json['_id']) ?? _string(json['id']),
    'orderNumber': _string(json['orderNumber']),
    'restaurantId': _identifier(json['restaurant']),
    'customer': customer,
    'driver': driver,
    'items': items,
    'subtotal': _num(json['subtotal']),
    'deliveryFee': _num(json['deliveryFee']),
    'driverFee': _num(json['driverFee']),
    'platformFee': _num(json['platformFee']),
    'commissionRate': _num(json['commissionRate']),
    'commissionAmount': _num(json['commissionAmount']),
    'restaurantPayout': _num(json['restaurantPayout']),
    'total': _num(json['total']) ?? _num(json['totalAmount']),
    'paymentMethod': _string(json['paymentMethod']),
    'paymentStatus': _string(json['paymentStatus']),
    'status': _statusValue(_parseStatus(statusRaw)),
    'rawStatus': statusRaw,
    'statusHistory': history,
    'deliveryAddress': address,
    'specialInstructions': _firstNonEmpty([
      json['specialInstructions'],
      json['notes'],
      json['cookingInstructions'],
      json['customerNote'],
      json['note'],
    ]),
    'rejectionReason': _string(json['rejectionReason']),
    'cancellationReason': _string(json['cancellationReason']),
    'acceptanceExpiresAt': _string(json['acceptanceExpiresAt']),
    'paymentExpiresAt': _string(json['paymentExpiresAt']),
    'estimatedDeliveryTime': _string(json['estimatedDeliveryTime']),
    'actualDeliveryTime': _string(json['actualDeliveryTime']),
    'createdAt': _string(json['createdAt']),
    'updatedAt': _string(json['updatedAt']),
    'driverWaiting': _bool(json['driverWaiting']),
    'driverArrived': _bool(json['driverArrived']),
  };
}

Map<String, dynamic>? _normalizeCustomer(Map<String, dynamic> json) {
  final user = _asMap(json['user']);
  final raw = _asMap(json['customer']) ?? user;
  final name = _string(raw?['name']) ?? _string(json['customerName']);
  final phone = _string(raw?['phone']) ??
      _string(json['customerPhone']) ??
      _string(user?['phone']);
  final id = _string(raw?['_id']) ?? _string(raw?['id']);
  if (name == null && phone == null && id == null) return null;
  return <String, dynamic>{'_id': id, 'name': name, 'phone': phone};
}

Map<String, dynamic>? _normalizeDriver(Map<String, dynamic> json) {
  final driverRaw = json['driver'];
  Map<String, dynamic>? raw = _asMap(driverRaw);
  if (raw == null && driverRaw is String && driverRaw.trim().isNotEmpty) {
    raw = <String, dynamic>{'_id': driverRaw.trim()};
  }
  final user = _asMap(raw?['user']);
  final id = _string(raw?['_id']) ??
      _string(raw?['id']) ??
      (driverRaw is String ? _string(driverRaw) : null);
  final name = _string(raw?['name']) ??
      _string(user?['name']) ??
      _string(json['driverName']);
  final phone = _string(raw?['phone']) ??
      _string(user?['phone']) ??
      _string(json['driverPhone']);
  if (id == null && name == null && phone == null) return null;
  return <String, dynamic>{'_id': id, 'name': name, 'phone': phone};
}

List<Map<String, dynamic>>? _normalizeItems(Object? value) {
  if (value is! List) return null;
  final items = <Map<String, dynamic>>[];
  for (final raw in value) {
    final item = _asMap(raw);
    if (item == null) continue;
    final menuRaw = item['menuItem'];
    final menu = _asMap(menuRaw);
    final price = _num(item['price']);
    final quantity = _integer(item['quantity']);
    final itemTotal = _num(item['itemTotal']) ??
        (price != null && quantity != null ? price * quantity : null);
    items.add(<String, dynamic>{
      'menuItemId': _identifier(menuRaw) ??
          _string(menu?['_id']) ??
          _string(menu?['id']),
      'name': _string(item['name']) ?? _string(menu?['name']),
      'price': price,
      'quantity': quantity,
      'itemTotal': itemTotal,
      'specialInstructions': _firstNonEmpty([
        item['specialInstructions'],
        item['notes'],
        item['note'],
      ]),
    });
  }
  return items;
}

List<Map<String, dynamic>>? _normalizeHistory(Object? value) {
  if (value is! List) return null;
  final history = <Map<String, dynamic>>[];
  for (final raw in value) {
    final event = _asMap(raw);
    if (event == null) continue;
    history.add(<String, dynamic>{
      'status': _string(event['status']),
      'timestamp': _string(event['timestamp']),
      'note': _string(event['note']),
    });
  }
  return history;
}

Map<String, dynamic>? _normalizeAddress(Object? value) {
  if (value is String) {
    final address = _string(value);
    if (address == null) return null;
    return <String, dynamic>{'label': null, 'fullAddress': address};
  }
  final raw = _asMap(value);
  if (raw == null) return null;
  final label = _string(raw['label']);
  final fullAddress = _string(raw['fullAddress']);
  if (label == null && fullAddress == null) return null;
  return <String, dynamic>{'label': label, 'fullAddress': fullAddress};
}

OrderStatus? _parseStatus(String? raw) {
  if (raw == null) return null;
  return switch (raw.toLowerCase()) {
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
    'pending_payment' => OrderStatus.pendingPayment,
    'pending' => OrderStatus.pending,
    _ => OrderStatus.unknown,
  };
}

String? _statusValue(OrderStatus? status) {
  if (status == null) return null;
  return switch (status) {
    OrderStatus.placed => 'placed',
    OrderStatus.confirmed => 'confirmed',
    OrderStatus.preparing => 'preparing',
    OrderStatus.ready => 'ready',
    OrderStatus.arrivedAtRestaurant => 'arrived_at_restaurant',
    OrderStatus.pickedUp => 'picked_up',
    OrderStatus.onTheWay => 'on_the_way',
    OrderStatus.delivered => 'delivered',
    OrderStatus.cancelled => 'cancelled',
    OrderStatus.rejected => 'rejected',
    OrderStatus.expired => 'expired',
    OrderStatus.failed => 'failed',
    OrderStatus.pendingPayment => 'pending_payment',
    OrderStatus.pending => 'pending',
    OrderStatus.unknown => 'unknown',
  };
}

Map<String, dynamic>? _asMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

String? _identifier(Object? value) {
  if (value is String) return _string(value);
  final map = _asMap(value);
  if (map == null) return null;
  return _string(map['_id']) ?? _string(map['id']);
}

String? _string(Object? value) {
  if (value is String) {
    final text = value.trim();
    return text.isEmpty ? null : text;
  }
  if (value is num || value is bool) return value.toString();
  return null;
}

String? _firstNonEmpty(Iterable<Object?> values) {
  for (final value in values) {
    final text = _string(value);
    if (text != null) return text;
  }
  return null;
}

double? _num(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value.trim());
  return null;
}

int? _integer(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}

bool? _bool(Object? value) {
  if (value is bool) return value;
  if (value is String) {
    final text = value.trim().toLowerCase();
    if (text == 'true') return true;
    if (text == 'false') return false;
  }
  return null;
}
