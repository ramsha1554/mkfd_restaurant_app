import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/ui/features/orders/models/order_filter.dart';
import 'package:mk_food_restaurant/ui/features/orders/providers/orders_state.dart';
import 'package:mk_food_restaurant/ui/features/orders/widgets/order_filter_bar.dart';

import '../support/order_fixtures.dart';

void main() {
  testWidgets('shows live counts and truncation', (tester) async {
    final state = OrdersState(
      activeOrders: [
        orderFixture(id: 'a', status: 'placed'),
        orderFixture(id: 'b', status: 'placed'),
        orderFixture(id: 'c', status: 'ready'),
      ],
      truncatedStatuses: const {'ready'},
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrderFilterBar(
            state: state,
            onSelected: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('New (2)'), findsOneWidget);
    expect(find.text('Ready (1+)'), findsOneWidget);
    expect(find.text('Preparing'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
  });

  testWidgets('notifies the selected filter', (tester) async {
    OrderFilter? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrderFilterBar(
            state: const OrdersState(),
            onSelected: (value) => selected = value,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Ready'));
    expect(selected, OrderFilter.ready);
  });
}
