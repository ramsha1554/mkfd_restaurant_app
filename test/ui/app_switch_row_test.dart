import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/ui/core/widgets/app_switch_row.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  testWidgets('toggles when tapped', (tester) async {
    var value = false;
    bool? changed;

    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) {
            return AppSwitchRow(
              title: 'Store open',
              caption: 'Accepting orders',
              value: value,
              onChanged: (next) {
                changed = next;
                setState(() => value = next);
              },
            );
          },
        ),
      ),
    );

    await tester.tap(find.byType(AppSwitchRow));
    await tester.pumpAndSettle();

    expect(changed, isTrue);
    expect(value, isTrue);
  });

  testWidgets('does nothing when locked', (tester) async {
    var calls = 0;

    await tester.pumpWidget(
      _wrap(
        AppSwitchRow(
          title: 'Busy mode',
          caption: 'Standard prep',
          value: false,
          isLocked: true,
          onChanged: (_) => calls++,
        ),
      ),
    );

    await tester.tap(find.byType(AppSwitchRow));
    await tester.pumpAndSettle();

    expect(calls, 0);
  });
}
