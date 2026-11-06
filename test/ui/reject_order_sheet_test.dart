import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/ui/core/widgets/app_bottom_sheet.dart';
import 'package:mk_food_restaurant/ui/features/orders/widgets/reject_order_sheet.dart';

void main() {
  testWidgets('requires a reason and submits chip plus details', (tester) async {
    String? received;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () {
                  showAppSheet<bool>(
                    context: context,
                    title: 'Reject this order?',
                    builder: (_) => RejectOrderSheet(
                      onReject: (reason) async {
                        received = reason;
                        return null;
                      },
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Reject this order?'), findsOneWidget);
    expect(
      tester
          .widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Reject order'),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(find.text('Too busy'));
    await tester.pump();

    expect(
      tester
          .widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Reject order'),
          )
          .onPressed,
      isNotNull,
    );

    await tester.enterText(
      find.byType(TextFormField),
      'Kitchen at capacity',
    );
    await tester.tap(find.text('Reject order'));
    await tester.pumpAndSettle();

    expect(received, 'Too busy: Kitchen at capacity');
    expect(find.text('Reject this order?'), findsNothing);
  });

  testWidgets('stays open when the action fails', (tester) async {
    String? received;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () {
                  showAppSheet<bool>(
                    context: context,
                    title: 'Reject this order?',
                    builder: (_) => RejectOrderSheet(
                      onReject: (reason) async {
                        received = reason;
                        return 'Cannot reject this order';
                      },
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Other'));
    await tester.pump();
    await tester.tap(find.text('Reject order'));
    await tester.pumpAndSettle();

    expect(received, 'Other');
    expect(find.text('Reject this order?'), findsOneWidget);
    expect(find.text('Cannot reject this order'), findsOneWidget);
    expect(find.text('Reject order'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
