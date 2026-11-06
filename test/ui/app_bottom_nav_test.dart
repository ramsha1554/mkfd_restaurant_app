import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/ui/core/widgets/app_bottom_nav.dart';

const _items = [
  AppBottomNavItem(icon: Icons.receipt_long_outlined, label: 'Orders'),
  AppBottomNavItem(icon: Icons.restaurant_menu_outlined, label: 'Menu'),
  AppBottomNavItem(icon: Icons.payments_outlined, label: 'Earnings'),
  AppBottomNavItem(icon: Icons.more_horiz_outlined, label: 'More'),
];

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  testWidgets('calls onTap with the selected index', (tester) async {
    int? tapped;
    await tester.pumpWidget(
      _wrap(
        AppBottomNav(
          items: _items,
          currentIndex: 0,
          onTap: (index) => tapped = index,
        ),
      ),
    );

    await tester.tap(find.text('Menu'));
    expect(tapped, 1);
  });

  testWidgets('hides a badge when the count is zero', (tester) async {
    const items = [
      AppBottomNavItem(
        icon: Icons.receipt_long_outlined,
        label: 'Orders',
        count: 0,
      ),
      AppBottomNavItem(
        icon: Icons.restaurant_menu_outlined,
        label: 'Menu',
        count: 3,
      ),
    ];

    await tester.pumpWidget(
      _wrap(
        AppBottomNav(
          items: items,
          currentIndex: 0,
          onTap: (_) {},
        ),
      ),
    );

    expect(find.text('0'), findsNothing);
    expect(find.text('3'), findsOneWidget);
  });
}
