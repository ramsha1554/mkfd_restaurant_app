import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/ui/core/widgets/app_text_field.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );
}

void main() {
  testWidgets('marks required labels', (tester) async {
    await tester.pumpWidget(
      _wrap(const AppTextField(label: 'Restaurant name', isRequired: true)),
    );

    expect(find.text('Restaurant name *'), findsOneWidget);
  });

  testWidgets('shows the valid check when requested', (tester) async {
    await tester.pumpWidget(
      _wrap(const AppTextField(label: 'Email', showValidCheck: true)),
    );

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('locked fields use a lock and win over the valid check', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const AppTextField(
          label: 'Country',
          locked: true,
          showValidCheck: true,
        ),
      ),
    );

    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNothing);
  });

  testWidgets('renders a custom prefix and suffix', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AppTextField(
          prefix: Text('+44'),
          suffix: Icon(Icons.add),
        ),
      ),
    );

    expect(find.text('+44'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
