// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['_id'] as String?,
      orderNumber: json['orderNumber'] as String?,
      restaurantId: json['restaurantId'] as String?,
      customer: json['customer'] == null
          ? null
          : OrderCustomer.fromJson(json['customer'] as Map<String, dynamic>),
      driver: json['driver'] == null
          ? null
          : OrderDriver.fromJson(json['driver'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble(),
      driverFee: (json['driverFee'] as num?)?.toDouble(),
      platformFee: (json['platformFee'] as num?)?.toDouble(),
      commissionRate: (json['commissionRate'] as num?)?.toDouble(),
      commissionAmount: (json['commissionAmount'] as num?)?.toDouble(),
      restaurantPayout: (json['restaurantPayout'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      paymentMethod: json['paymentMethod'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      status: $enumDecodeNullable(_$OrderStatusEnumMap, json['status']),
      rawStatus: json['rawStatus'] as String?,
      statusHistory: (json['statusHistory'] as List<dynamic>?)
          ?.map((e) => OrderStatusEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      deliveryAddress: json['deliveryAddress'] == null
          ? null
          : OrderAddress.fromJson(
              json['deliveryAddress'] as Map<String, dynamic>,
            ),
      specialInstructions: json['specialInstructions'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      acceptanceExpiresAt: json['acceptanceExpiresAt'] as String?,
      paymentExpiresAt: json['paymentExpiresAt'] as String?,
      estimatedDeliveryTime: json['estimatedDeliveryTime'] as String?,
      actualDeliveryTime: json['actualDeliveryTime'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      driverWaiting: json['driverWaiting'] as bool?,
      driverArrived: json['driverArrived'] as bool?,
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'orderNumber': instance.orderNumber,
      'restaurantId': instance.restaurantId,
      'customer': instance.customer,
      'driver': instance.driver,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'deliveryFee': instance.deliveryFee,
      'driverFee': instance.driverFee,
      'platformFee': instance.platformFee,
      'commissionRate': instance.commissionRate,
      'commissionAmount': instance.commissionAmount,
      'restaurantPayout': instance.restaurantPayout,
      'total': instance.total,
      'paymentMethod': instance.paymentMethod,
      'paymentStatus': instance.paymentStatus,
      'status': _$OrderStatusEnumMap[instance.status],
      'rawStatus': instance.rawStatus,
      'statusHistory': instance.statusHistory,
      'deliveryAddress': instance.deliveryAddress,
      'specialInstructions': instance.specialInstructions,
      'rejectionReason': instance.rejectionReason,
      'cancellationReason': instance.cancellationReason,
      'acceptanceExpiresAt': instance.acceptanceExpiresAt,
      'paymentExpiresAt': instance.paymentExpiresAt,
      'estimatedDeliveryTime': instance.estimatedDeliveryTime,
      'actualDeliveryTime': instance.actualDeliveryTime,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'driverWaiting': instance.driverWaiting,
      'driverArrived': instance.driverArrived,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.placed: 'placed',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.preparing: 'preparing',
  OrderStatus.ready: 'ready',
  OrderStatus.arrivedAtRestaurant: 'arrived_at_restaurant',
  OrderStatus.pickedUp: 'picked_up',
  OrderStatus.onTheWay: 'on_the_way',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
  OrderStatus.rejected: 'rejected',
  OrderStatus.expired: 'expired',
  OrderStatus.failed: 'failed',
  OrderStatus.pendingPayment: 'pending_payment',
  OrderStatus.pending: 'pending',
  OrderStatus.unknown: 'unknown',
};

_$OrderCustomerImpl _$$OrderCustomerImplFromJson(Map<String, dynamic> json) =>
    _$OrderCustomerImpl(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$$OrderCustomerImplToJson(_$OrderCustomerImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
    };

_$OrderDriverImpl _$$OrderDriverImplFromJson(Map<String, dynamic> json) =>
    _$OrderDriverImpl(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$$OrderDriverImplToJson(_$OrderDriverImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
    };

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      menuItemId: json['menuItemId'] as String?,
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num?)?.toInt(),
      itemTotal: (json['itemTotal'] as num?)?.toDouble(),
      specialInstructions: json['specialInstructions'] as String?,
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'menuItemId': instance.menuItemId,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'itemTotal': instance.itemTotal,
      'specialInstructions': instance.specialInstructions,
    };

_$OrderStatusEventImpl _$$OrderStatusEventImplFromJson(
  Map<String, dynamic> json,
) => _$OrderStatusEventImpl(
  status: json['status'] as String?,
  timestamp: json['timestamp'] as String?,
  note: json['note'] as String?,
);

Map<String, dynamic> _$$OrderStatusEventImplToJson(
  _$OrderStatusEventImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'timestamp': instance.timestamp,
  'note': instance.note,
};

_$OrderAddressImpl _$$OrderAddressImplFromJson(Map<String, dynamic> json) =>
    _$OrderAddressImpl(
      label: json['label'] as String?,
      fullAddress: json['fullAddress'] as String?,
      street: json['street'] as String?,
      city: json['city'] as String?,
      postcode: json['postcode'] as String?,
    );

Map<String, dynamic> _$$OrderAddressImplToJson(_$OrderAddressImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'fullAddress': instance.fullAddress,
      'street': instance.street,
      'city': instance.city,
      'postcode': instance.postcode,
    };
