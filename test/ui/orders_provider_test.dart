import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/core/error/app_error.dart';
import 'package:mk_food_restaurant/data/models/pagination_meta.dart';
import 'package:mk_food_restaurant/ui/features/orders/models/order_filter.dart';
import 'package:mk_food_restaurant/ui/features/orders/providers/orders_provider.dart';
import 'package:mk_food_restaurant/ui/features/orders/providers/orders_state.dart';

import '../support/order_fixtures.dart';

void main() {
  late FakeOrderRepository repo;
  late OrdersNotifier notifier;

  setUp(() {
    repo = FakeOrderRepository();
    notifier = OrdersNotifier(repo);
  });

  tearDown(() {
    notifier.dispose();
  });

  Future<void> load() => notifier.setRestaurantId('restaurant-1');

  test('loads active orders and the All page', () async {
    repo.setPage(
      status: 'placed',
      orders: [
        orderFixture(
          id: 'new-1',
          status: 'placed',
          createdAt: '2026-11-06T10:00:00.000Z',
        ),
      ],
    );
    repo.setPage(
      status: 'ready',
      orders: [
        orderFixture(
          id: 'ready-1',
          status: 'ready',
          createdAt: '2026-11-05T10:00:00.000Z',
        ),
      ],
    );
    repo.setPage(
      orders: [orderFixture(id: 'done-1', status: 'delivered')],
      pagination: const PaginationMeta(
        page: 1,
        limit: 25,
        total: 40,
        hasNextPage: true,
      ),
    );

    await load();

    expect(notifier.state.status, OrdersLoadStatus.loaded);
    expect(notifier.state.activeOrders, hasLength(2));
    expect(notifier.state.activeOrders.first.id, 'new-1');
    expect(notifier.state.countFor(OrderFilter.newOrders), 1);
    expect(notifier.state.countFor(OrderFilter.ready), 1);
    expect(notifier.state.history[OrderFilter.all]?.isLoaded, isTrue);
    expect(notifier.state.countFor(OrderFilter.all), 40);
  });

  test('marks a count as truncated when a status has another page', () async {
    repo.setPage(
      status: 'placed',
      orders: [orderFixture(id: 'new-1', status: 'placed')],
      pagination: const PaginationMeta(
        page: 1,
        limit: 50,
        total: 80,
        hasNextPage: true,
      ),
    );

    await load();

    expect(notifier.state.isTruncated(OrderFilter.newOrders), isTrue);
    expect(notifier.state.isTruncated(OrderFilter.preparing), isFalse);
  });

  test('loads history when a history filter is selected', () async {
    repo.setPage(
      status: 'delivered',
      orders: [orderFixture(id: 'done-1', status: 'delivered')],
    );

    await load();
    await notifier.selectFilter(OrderFilter.delivered);

    expect(notifier.state.filter, OrderFilter.delivered);
    expect(notifier.state.history[OrderFilter.delivered]?.isLoaded, isTrue);
    expect(
      notifier.state.history[OrderFilter.delivered]?.orders.single.id,
      'done-1',
    );
  });

  test('loadMore appends the next history page', () async {
    repo.setPage(
      orders: [orderFixture(id: 'a', status: 'delivered')],
      pagination: const PaginationMeta(
        page: 1,
        limit: 25,
        total: 2,
        hasNextPage: true,
      ),
    );
    repo.setPage(
      page: 2,
      orders: [orderFixture(id: 'b', status: 'cancelled')],
      pagination: const PaginationMeta(
        page: 2,
        limit: 25,
        total: 2,
        hasNextPage: false,
      ),
    );

    await load();
    await notifier.selectFilter(OrderFilter.all);
    expect(notifier.state.canLoadMore, isTrue);

    await notifier.loadMore();

    expect(notifier.state.history[OrderFilter.all]?.orders, hasLength(2));
    expect(notifier.state.canLoadMore, isFalse);
  });

  test('accept moves the order to its next status', () async {
    repo.setPage(
      status: 'placed',
      orders: [orderFixture(id: 'new-1', status: 'placed')],
    );
    await load();

    repo.actionResult = orderFixture(id: 'new-1', status: 'confirmed');
    final error = await notifier.accept('new-1');

    expect(error, isNull);
    expect(repo.confirmCalls, 1);
    expect(notifier.state.activeOrders.single.rawStatus, 'confirmed');
    expect(notifier.state.inFlightIds, isEmpty);
  });

  test(
    'action failure returns the exact API message and unlocks the card',
    () async {
      repo.setPage(
        status: 'placed',
        orders: [orderFixture(id: 'new-1', status: 'placed')],
      );
      await load();

      repo.actionError = const ApiException(
        statusCode: 400,
        message: 'Cannot confirm order in its current state',
      );
      final error = await notifier.accept('new-1');

      expect(error, 'Cannot confirm order in its current state');
      expect(notifier.state.inFlightIds, isEmpty);
      expect(notifier.state.activeOrders.single.rawStatus, 'placed');
    },
  );

  test('only one action per order can be in flight', () async {
    repo.setPage(
      status: 'placed',
      orders: [orderFixture(id: 'new-1', status: 'placed')],
    );
    await load();

    repo.actionResult = orderFixture(id: 'new-1', status: 'confirmed');
    repo.actionGate = Completer<void>();

    final first = notifier.accept('new-1');
    expect(notifier.state.inFlightIds, contains('new-1'));

    final second = await notifier.accept('new-1');
    expect(second, isNull);
    expect(repo.confirmCalls, 1);

    repo.actionGate!.complete();
    await first;
  });

  test('keeps known orders and marks stale when a refresh fails', () async {
    repo.setPage(
      status: 'placed',
      orders: [orderFixture(id: 'new-1', status: 'placed')],
    );
    await load();
    expect(notifier.state.isStale, isFalse);

    repo.fetchError = const NetworkException('offline');
    await notifier.refreshActive();

    expect(notifier.state.activeOrders, hasLength(1));
    expect(notifier.state.isStale, isTrue);

    repo.fetchError = null;
    await notifier.refreshActive();

    expect(notifier.state.isStale, isFalse);
  });

  test('reject removes the order and updates cancelled history', () async {
    repo.setPage(
      status: 'placed',
      orders: [orderFixture(id: 'new-1', status: 'placed')],
    );
    await load();

    repo.setPage(status: 'cancelled', orders: const []);
    repo.setPage(status: 'rejected', orders: const []);
    await notifier.selectFilter(OrderFilter.cancelled);

    repo.actionResult = orderFixture(id: 'new-1', status: 'rejected');
    repo.setPage(status: 'rejected', orders: [repo.actionResult!]);

    final error = await notifier.reject('new-1', 'Too busy');

    expect(error, isNull);
    expect(repo.lastRejectReason, 'Too busy');
    expect(notifier.state.activeOrders, isEmpty);
    expect(
      notifier.state.history[OrderFilter.cancelled]?.orders.any(
        (order) => order.id == 'new-1',
      ),
      isTrue,
    );
  });

  test(
    'verifyPickup submits the driver code and applies the response',
    () async {
      repo.setPage(
        status: 'ready',
        orders: [orderFixture(id: 'ready-1', status: 'ready')],
      );
      await load();

      repo.actionResult = orderFixture(id: 'ready-1', status: 'picked_up');
      final error = await notifier.verifyPickup('ready-1', '4321');

      expect(error, isNull);
      expect(repo.verifyPickupCalls, 1);
      expect(repo.lastPickupCode, '4321');
      expect(notifier.state.activeOrders.single.rawStatus, 'picked_up');
      expect(notifier.state.inFlightIds, isEmpty);
    },
  );

  test(
    'verifyPickup refreshes active orders when no order is returned',
    () async {
      repo.setPage(
        status: 'ready',
        orders: [orderFixture(id: 'ready-1', status: 'ready')],
      );
      await load();

      repo.setPage(status: 'ready', orders: const []);
      repo.setPage(
        status: 'picked_up',
        orders: [orderFixture(id: 'ready-1', status: 'on_the_way')],
      );
      final fetchesBefore = repo.fetchCalls;

      final error = await notifier.verifyPickup('ready-1', '0000');

      expect(error, isNull);
      expect(repo.fetchCalls, greaterThan(fetchesBefore));
      expect(notifier.state.activeOrders.single.rawStatus, 'on_the_way');
    },
  );

  test(
    'verifyPickup returns the exact API message and keeps the order',
    () async {
      repo.setPage(
        status: 'ready',
        orders: [orderFixture(id: 'ready-1', status: 'ready')],
      );
      await load();

      repo.actionError = const ApiException(
        statusCode: 400,
        message: 'Invalid pickup code',
      );
      final error = await notifier.verifyPickup('ready-1', '1111');

      expect(error, 'Invalid pickup code');
      expect(notifier.state.activeOrders.single.rawStatus, 'ready');
      expect(notifier.state.inFlightIds, isEmpty);
    },
  );

  test('only one verifyPickup can be in flight per order', () async {
    repo.setPage(
      status: 'ready',
      orders: [orderFixture(id: 'ready-1', status: 'ready')],
    );
    await load();

    repo.actionResult = orderFixture(id: 'ready-1', status: 'picked_up');
    repo.actionGate = Completer<void>();

    final first = notifier.verifyPickup('ready-1', '4321');
    expect(notifier.state.inFlightIds, contains('ready-1'));

    final second = await notifier.verifyPickup('ready-1', '9999');
    expect(second, isNull);
    expect(repo.verifyPickupCalls, 1);

    repo.actionGate!.complete();
    await first;
    expect(notifier.state.inFlightIds, isEmpty);
  });
}
