import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/ui/core/theme/app_colors.dart';
import 'package:mk_food_restaurant/ui/core/widgets/primary_button.dart';

void main() {
  testWidgets('destructive variant uses the error palette', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppPrimaryButton(
            label: 'Reject order',
            destructive: true,
            onPressed: () {},
          ),
        ),
      ),
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(
      button.style?.backgroundColor?.resolve(<WidgetState>{}),
      AppColors.error,
    );
    final label = tester.widget<Text>(find.text('Reject order'));
    expect(label.style?.color, AppColors.onError);
  });

  testWidgets('standard variant keeps the primary palette', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppPrimaryButton(label: 'Accept', onPressed: () {}),
        ),
      ),
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(
      button.style?.backgroundColor?.resolve(<WidgetState>{}),
      AppColors.primary,
    );
  });
}
