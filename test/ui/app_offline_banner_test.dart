import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/ui/core/widgets/app_offline_banner.dart';

void main() {
  testWidgets('explains that actions are locked while offline', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AppOfflineBanner()),
      ),
    );

    expect(find.text("You're offline"), findsOneWidget);
    expect(
      find.text(
        'Showing last known orders. Actions are locked until '
        'the connection returns.',
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
  });
}
