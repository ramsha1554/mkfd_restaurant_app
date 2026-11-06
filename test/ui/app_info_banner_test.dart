import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/ui/core/widgets/app_info_banner.dart';

void main() {
  testWidgets('renders the message, icon and trailing action', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppInfoBanner(
            message: 'Special instructions: ring the bell',
            icon: Icons.edit_note_outlined,
            trailing: const Text('View'),
          ),
        ),
      ),
    );

    expect(find.text('Special instructions: ring the bell'), findsOneWidget);
    expect(find.byIcon(Icons.edit_note_outlined), findsOneWidget);
    expect(find.text('View'), findsOneWidget);
  });

  testWidgets('supports every tone', (tester) async {
    for (final tone in AppInfoBannerTone.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppInfoBanner(message: tone.name, tone: tone),
          ),
        ),
      );
      expect(find.text(tone.name), findsOneWidget);
    }
  });
}
