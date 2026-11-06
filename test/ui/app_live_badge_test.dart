import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/ui/core/widgets/app_live_badge.dart';

Widget _wrap(Widget child) {
  return MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  testWidgets('shows Live when connected', (tester) async {
    await tester.pumpWidget(_wrap(const AppLiveBadge(isLive: true)));

    expect(find.text('Live'), findsOneWidget);
    expect(find.text('Offline'), findsNothing);
  });

  testWidgets('shows Offline when disconnected', (tester) async {
    await tester.pumpWidget(_wrap(const AppLiveBadge(isLive: false)));

    expect(find.text('Offline'), findsOneWidget);
    expect(find.text('Live'), findsNothing);
  });
}
