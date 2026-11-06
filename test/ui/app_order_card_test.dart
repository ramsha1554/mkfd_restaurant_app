import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/ui/core/theme/app_colors.dart';
import 'package:mk_food_restaurant/ui/core/widgets/app_card.dart';
import 'package:mk_food_restaurant/ui/features/orders/widgets/app_order_card.dart';

import '../support/order_fixtures.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void main() {
  testWidgets('new order shows accept and reject with a primary border',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        AppOrderCard(
          order: orderFixture(
            id: 'o1',
            status: 'placed',
            customerName: 'Sample Customer',
          ).copyWith(
            orderNumber: 'MK-261106-0001',
            specialInstructions: 'Ring the bell',
          ),
          onAccept: () {},
          onReject: () {},
        ),
      ),
    );

    expect(find.text('#MK-261106-0001'), findsOneWidget);
    expect(find.text('Sample C.'), findsOneWidget);
    expect(find.text('Order Placed'), findsOneWidget);
    expect(find.text('1× Item'), findsOneWidget);
    expect(find.text('Special instructions: Ring the bell'), findsOneWidget);
    expect(find.text('Accept'), findsOneWidget);
    expect(find.text('Reject'), findsOneWidget);
    expect(find.text('£10.00'), findsOneWidget);

    final card = tester.widget<AppCard>(find.byType(AppCard).first);
    expect(card.borderColor, AppColors.primary);
    expect(card.borderWidth, 1.5);
  });

  testWidgets('confirmed and preparing expose their next action',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        AppOrderCard(
          order: orderFixture(id: 'o1', status: 'confirmed'),
          onStartPreparing: () {},
        ),
      ),
    );
    expect(find.text('Start preparing'), findsOneWidget);
    expect(find.text('Accept'), findsNothing);

    await tester.pumpWidget(
      _wrap(
        AppOrderCard(
          order: orderFixture(id: 'o2', status: 'preparing'),
          onMarkReady: () {},
        ),
      ),
    );
    expect(find.text('Mark as ready'), findsOneWidget);
  });

  testWidgets('ready order with a waiting driver shows a warning banner',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        AppOrderCard(
          order: orderFixture(
            id: 'o1',
            status: 'ready',
            driverName: 'Ali',
          ).copyWith(driverArrived: true),
        ),
      ),
    );

    expect(find.text('Driver is waiting — Ali'), findsOneWidget);
    expect(find.text('Accept'), findsNothing);
    expect(find.text('Mark as ready'), findsNothing);
  });

  testWidgets('delivered order shows the payout instead of the subtotal',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        AppOrderCard(
          order: orderFixture(id: 'o1', status: 'delivered', subtotal: 10),
        ),
      ),
    );

    expect(find.text('PAYOUT'), findsOneWidget);
    expect(find.text('£8.50'), findsOneWidget);
    expect(find.text('SUBTOTAL'), findsNothing);
  });

  testWidgets('cancelled order shows the cancellation reason', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AppOrderCard(
          order: orderFixture(id: 'o1', status: 'cancelled').copyWith(
            cancellationReason: 'Payment window expired',
          ),
        ),
      ),
    );

    expect(find.text('Reason: Payment window expired'), findsOneWidget);
    expect(find.text('SUBTOTAL'), findsOneWidget);
    expect(find.text('Accept'), findsNothing);
  });

  testWidgets('offline locks card actions', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AppOrderCard(
          order: orderFixture(id: 'o1', status: 'placed'),
          enabled: false,
          onAccept: () {},
          onReject: () {},
        ),
      ),
    );

    final accept = tester.widget<ElevatedButton>(
      find.ancestor(
        of: find.text('Accept'),
        matching: find.byType(ElevatedButton),
      ),
    );
    final reject = tester.widget<OutlinedButton>(
      find.ancestor(
        of: find.text('Reject'),
        matching: find.byType(OutlinedButton),
      ),
    );

    expect(accept.onPressed, isNull);
    expect(reject.onPressed, isNull);
  });

  testWidgets('busy state replaces the action label with a spinner',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        AppOrderCard(
          order: orderFixture(
            id: 'o1',
            status: 'placed',
          ),
          busy: true,
          onAccept: () {},
        ),
      ),
    );

    expect(find.text('Accept'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
