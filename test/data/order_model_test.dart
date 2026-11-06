import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/data/models/order.dart';
import 'package:mk_food_restaurant/ui/features/orders/models/order_filter.dart';
import 'package:mk_food_restaurant/ui/features/orders/utils/order_money.dart';

import '../support/order_fixtures.dart';

List<OrderModel> _sampleOrders() {
  final raw = jsonDecode(
    File('docs/api_samples/orders_list.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final data = raw['data'] as List<dynamic>;
  return data
      .cast<Map<String, dynamic>>()
      .map(OrderModel.fromJson)
      .toList(growable: false);
}

void main() {
  group('OrderModel.fromJson', () {
    test('parses the real orders sample', () {
      final orders = _sampleOrders();

      expect(orders, hasLength(5));
      final delivered = orders.first;
      expect(delivered.id, '6aed95c6f379a819300c05c9');
      expect(delivered.orderNumber, 'MK-261106-0003');
      expect(delivered.status, OrderStatus.delivered);
      expect(delivered.rawStatus, 'delivered');
      expect(delivered.customer?.name, 'Sample Customer');
      expect(delivered.customer?.phone, '+447700900101');
      expect(delivered.driver?.name, 'Sample Driver');
      expect(delivered.items, hasLength(1));
      expect(delivered.items!.first.name, 'Chole Bhature');
      expect(delivered.items!.first.menuItemId, '6ad8a877ad0773c64bb35f59');
      expect(delivered.items!.first.itemTotal, 4.33);
      expect(delivered.subtotal, 4.33);
      expect(delivered.total, 11.33);
      expect(delivered.paymentMethod, 'cash');
      expect(delivered.deliveryAddress?.label, 'Home');
      expect(delivered.deliveryAddress?.fullAddress, contains('Madni Gate'));
      expect(delivered.specialInstructions, isNull);
      expect(delivered.statusHistory, hasLength(8));
    });

    test('parses mixed statuses without inventing missing values', () {
      final orders = _sampleOrders();

      expect(orders[2].status, OrderStatus.confirmed);
      expect(orders[2].driver, isNull);
      expect(orders[3].status, OrderStatus.cancelled);
      expect(orders[3].cancellationReason, 'Payment window expired');
      expect(orders[3].total, 24.8);
    });

    test('falls back to unknown and keeps the raw status', () {
      final order = OrderModel.fromJson({
        '_id': 'o1',
        'status': 'teleported',
      });

      expect(order.status, OrderStatus.unknown);
      expect(order.rawStatus, 'teleported');
    });

    test('normalises alternate field names', () {
      final order = OrderModel.fromJson({
        'id': 'alt-1',
        'status': 'placed',
        'totalAmount': 20,
        'notes': 'Ring the bell',
        'user': {'phone': '+447700900999'},
        'driver': 'driver-1',
        'driverName': 'Ali',
        'items': [
          {
            'menuItem': {'_id': 'm1', 'name': 'Wrap'},
            'price': 5,
            'quantity': 2,
          },
        ],
        'commissionRate': 10,
        'commissionAmount': 2,
        'restaurantPayout': 18,
        'deliveryAddress': '1 Sample Road',
      });

      expect(order.id, 'alt-1');
      expect(order.total, 20);
      expect(order.specialInstructions, 'Ring the bell');
      expect(order.customer?.phone, '+447700900999');
      expect(order.driver?.id, 'driver-1');
      expect(order.driver?.name, 'Ali');
      expect(order.items!.first.menuItemId, 'm1');
      expect(order.items!.first.name, 'Wrap');
      expect(order.items!.first.itemTotal, 10);
      expect(order.deliveryAddress?.fullAddress, '1 Sample Road');

      final money = orderMoney(order);
      expect(money.subtotal, 10);
      expect(money.commissionRate, 10);
      expect(money.commissionAmount, 2);
      expect(money.payout, 18);
    });

    test('does not expose pickup codes or idempotency keys', () {
      final order = OrderModel.fromJson(_sampleOrders().first.toJson());
      final json = order.toJson();

      expect(json.containsKey('pickupCode'), isFalse);
      expect(json.containsKey('idempotencyKey'), isFalse);
    });
  });

  group('order money', () {
    test('uses subtotal and commission defaults', () {
      final order = orderFixture(id: 'o1', status: 'delivered', subtotal: 20)
          .copyWith(platformFee: 3);

      final money = orderMoney(order);
      expect(money.subtotal, 20);
      expect(money.commissionRate, 15);
      expect(money.commissionAmount, 3);
      expect(money.payout, 17);
    });

    test('derives subtotal from items when the field is missing', () {
      final order = OrderModel(
        id: 'o2',
        status: OrderStatus.delivered,
        items: const [
          OrderItem(price: 4, quantity: 2),
          OrderItem(price: 2, quantity: 1, itemTotal: 2),
        ],
      );

      final money = orderMoney(order);
      expect(money.subtotal, 10);
      expect(money.commissionAmount, 1.5);
      expect(money.payout, 8.5);
    });

    test('never returns a negative payout', () {
      final order = orderFixture(id: 'o3', status: 'delivered', subtotal: 5)
          .copyWith(commissionAmount: 8);

      expect(orderMoney(order).payout, 0);
    });
  });

  group('driver flags', () {
    test('driver waiting when arrived or waiting is set', () {
      final arrived = orderFixture(id: 'a', status: 'arrived_at_restaurant');
      final readyArrived = orderFixture(id: 'b', status: 'ready')
          .copyWith(driverArrived: true);
      final confirmed = orderFixture(id: 'c', status: 'confirmed');

      expect(isDriverWaiting(arrived), isTrue);
      expect(isDriverWaiting(readyArrived), isTrue);
      expect(isDriverWaiting(confirmed), isFalse);
    });

    test('can verify pickup for ready and arrived states', () {
      expect(canVerifyPickup(orderFixture(id: 'a', status: 'ready')), isTrue);
      expect(
        canVerifyPickup(
          orderFixture(id: 'b', status: 'arrived_at_restaurant'),
        ),
        isTrue,
      );
      expect(canVerifyPickup(orderFixture(id: 'c', status: 'preparing')), isFalse);
    });
  });

  group('order filters', () {
    test('maps active statuses and matches orders', () {
      expect(OrderFilter.newOrders.activeStatuses, ['placed']);
      expect(OrderFilter.preparing.activeStatuses, ['confirmed', 'preparing']);
      expect(OrderFilter.ready.activeStatuses, ['ready', 'arrived_at_restaurant']);
      expect(OrderFilter.pickedUp.activeStatuses, ['picked_up', 'on_the_way']);
      expect(OrderFilter.cancelled.historyStatuses, ['cancelled', 'rejected']);

      expect(
        OrderFilter.newOrders.matches(
          orderFixture(id: 'o1', status: 'placed'),
        ),
        isTrue,
      );
      expect(
        OrderFilter.newOrders.matches(
          orderFixture(id: 'o2', status: 'preparing'),
        ),
        isFalse,
      );
      expect(OrderFilter.all.matches(orderFixture(id: 'o3', status: 'expired')),
          isTrue);
      expect(
        OrderFilter.cancelled.matches(
          orderFixture(id: 'o4', status: 'rejected'),
        ),
        isTrue,
      );
    });
  });
}
