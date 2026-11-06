import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/data/models/order.dart';
import 'package:mk_food_restaurant/ui/features/orders/providers/orders_provider.dart';
import 'package:mk_food_restaurant/ui/features/orders/providers/phone_launcher_provider.dart';
import 'package:mk_food_restaurant/ui/features/orders/views/order_detail_view.dart';

import '../support/fake_phone_launcher.dart';
import '../support/order_fixtures.dart';

void main() {
  Future<FakeOrderRepository> pumpDetail(
    WidgetTester tester, {
    required OrderModel order,
    FakePhoneLauncher? launcher,
  }) async {
    tester.view.physicalSize = const Size(800, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final repo = FakeOrderRepository();
    repo.setPage(status: order.rawStatus, orders: [order]);
    repo.setPage(orders: [order]);
    final notifier = OrdersNotifier(repo);
    await notifier.setRestaurantId('restaurant-1');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ordersProvider.overrideWith((ref) => notifier),
          if (launcher != null)
            phoneLauncherProvider.overrideWithValue(launcher),
        ],
        child: MaterialApp(home: OrderDetailView(orderId: order.id!)),
      ),
    );
    await tester.pump();
    return repo;
  }

  testWidgets('shows customer, items, special instructions and earnings', (
    tester,
  ) async {
    await pumpDetail(
      tester,
      order: orderFixture(
        id: 'MK-1',
        status: 'confirmed',
        customerName: 'Aisha Khan',
        customerPhone: '+44 7700 900123',
        deliveryAddress: const OrderAddress(
          fullAddress: '14 Silbury Boulevard, Milton Keynes',
        ),
        specialInstructions: 'No onions please.',
        paymentMethod: 'cash',
        subtotal: 20,
        commissionRate: 15,
        items: const [
          OrderItem(
            name: 'Chicken Tikka Masala',
            price: 9,
            quantity: 2,
            itemTotal: 18,
            specialInstructions: 'Extra spicy',
          ),
        ],
      ),
    );

    expect(find.text('#MK-1'), findsOneWidget);
    expect(find.text('Cash'), findsOneWidget);
    expect(find.text('Aisha Khan'), findsOneWidget);
    expect(find.text('+44 7700 900123'), findsOneWidget);
    expect(find.text('14 Silbury Boulevard, Milton Keynes'), findsOneWidget);
    expect(find.text('Special instructions'), findsOneWidget);
    expect(find.text('"No onions please."'), findsOneWidget);
    expect(find.text('Order items (1)'), findsOneWidget);
    expect(find.text('2×'), findsOneWidget);
    expect(find.text('Chicken Tikka Masala'), findsOneWidget);
    expect(find.text('Note: Extra spicy'), findsOneWidget);
    expect(find.text('£18.00'), findsOneWidget);
    expect(find.text('£20.00'), findsOneWidget);
    expect(find.text('Commission (15%)'), findsOneWidget);
    expect(find.text('−£3.00'), findsOneWidget);
    expect(find.text('£17.00'), findsOneWidget);
  });

  testWidgets('hides special instructions when empty', (tester) async {
    await pumpDetail(
      tester,
      order: orderFixture(id: 'MK-2', status: 'confirmed'),
    );

    expect(find.text('Special instructions'), findsNothing);
  });

  testWidgets('maps payment link status to a badge', (tester) async {
    await pumpDetail(
      tester,
      order: orderFixture(
        id: 'MK-3',
        status: 'confirmed',
        paymentMethod: 'payment_link',
        paymentStatus: 'paid',
      ),
    );

    expect(find.text('Paid online'), findsOneWidget);
  });

  testWidgets('shows an unpaid payment link status', (tester) async {
    await pumpDetail(
      tester,
      order: orderFixture(
        id: 'MK-4',
        status: 'confirmed',
        paymentMethod: 'payment_link',
        paymentStatus: 'pending',
      ),
    );

    expect(find.text('Online · pending'), findsOneWidget);
  });

  testWidgets('shows the raw unknown payment method', (tester) async {
    await pumpDetail(
      tester,
      order: orderFixture(
        id: 'MK-5',
        status: 'confirmed',
        paymentMethod: 'voucher',
      ),
    );

    expect(find.text('voucher'), findsOneWidget);
  });

  testWidgets('shows the no-driver panel for an order without a driver', (
    tester,
  ) async {
    await pumpDetail(
      tester,
      order: orderFixture(id: 'MK-6', status: 'placed'),
    );

    expect(find.text('No driver assigned yet'), findsOneWidget);
    expect(find.text('A driver is searched after you accept.'), findsOneWidget);
  });

  testWidgets('shows the driver and waiting banner', (tester) async {
    await pumpDetail(
      tester,
      order: orderFixture(
        id: 'MK-7',
        status: 'ready',
        driverName: 'Ali',
        driverPhone: '+44 7700 900201',
        driverWaiting: true,
      ),
    );

    expect(find.text('Ali'), findsOneWidget);
    expect(find.text('+44 7700 900201'), findsOneWidget);
    expect(find.text('Driver is waiting · Ali'), findsOneWidget);
    expect(find.text('No driver assigned yet'), findsNothing);
  });

  testWidgets('hides the no-driver panel for a cancelled order', (
    tester,
  ) async {
    await pumpDetail(
      tester,
      order: orderFixture(id: 'MK-8', status: 'cancelled'),
    );

    expect(find.text('No driver assigned yet'), findsNothing);
  });

  testWidgets('calls the customer phone', (tester) async {
    final launcher = FakePhoneLauncher();
    await pumpDetail(
      tester,
      launcher: launcher,
      order: orderFixture(
        id: 'MK-9',
        status: 'confirmed',
        customerPhone: '+44 7700 900123',
      ),
    );

    await tester.tap(find.byIcon(Icons.call));
    await tester.pump();

    expect(launcher.calls, ['+44 7700 900123']);
  });

  testWidgets('shows an error when the phone app cannot open', (tester) async {
    final launcher = FakePhoneLauncher()..result = false;
    await pumpDetail(
      tester,
      launcher: launcher,
      order: orderFixture(
        id: 'MK-10',
        status: 'confirmed',
        customerPhone: '+44 7700 900123',
      ),
    );

    await tester.tap(find.byIcon(Icons.call));
    await tester.pump();

    expect(find.text('Could not open the phone app'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('shows the acceptance countdown while time remains', (
    tester,
  ) async {
    await pumpDetail(
      tester,
      order: orderFixture(
        id: 'MK-11',
        status: 'placed',
        acceptanceExpiresAt: DateTime.now()
            .add(const Duration(minutes: 1, seconds: 5))
            .toUtc()
            .toIso8601String(),
      ),
    );

    expect(find.textContaining('Respond within'), findsOneWidget);
  });

  testWidgets('shows the expired acceptance message', (tester) async {
    await pumpDetail(
      tester,
      order: orderFixture(
        id: 'MK-12',
        status: 'placed',
        acceptanceExpiresAt: DateTime.now()
            .subtract(const Duration(minutes: 1))
            .toUtc()
            .toIso8601String(),
      ),
    );

    expect(find.text('Time to respond has run out'), findsOneWidget);
  });

  testWidgets('does not show a countdown without an expiry', (tester) async {
    await pumpDetail(
      tester,
      order: orderFixture(id: 'MK-13', status: 'placed'),
    );

    expect(find.textContaining('Respond within'), findsNothing);
    expect(find.text('Time to respond has run out'), findsNothing);
  });

  testWidgets('shows not found and retries the list', (tester) async {
    final repo = FakeOrderRepository();
    final notifier = OrdersNotifier(repo);
    await notifier.setRestaurantId('restaurant-1');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [ordersProvider.overrideWith((ref) => notifier)],
        child: const MaterialApp(home: OrderDetailView(orderId: 'missing')),
      ),
    );
    await tester.pump();

    expect(find.text('Order not found'), findsOneWidget);
    final fetchesBefore = repo.fetchCalls;
    await tester.tap(find.text('Retry'));
    await tester.pump();

    expect(repo.fetchCalls, greaterThan(fetchesBefore));
  });
}
