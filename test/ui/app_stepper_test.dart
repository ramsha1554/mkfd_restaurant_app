import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/ui/core/theme/app_colors.dart';
import 'package:mk_food_restaurant/ui/core/widgets/app_stepper.dart';

void main() {
  testWidgets('shows the current step and phase label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppStepper(step: 2, label: 'Location Details'),
        ),
      ),
    );

    expect(find.text('Step 2 of 4'), findsOneWidget);
    expect(find.text('LOCATION DETAILS'), findsOneWidget);
  });

  testWidgets('fills completed segments only', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppStepper(step: 2, label: 'Location Details'),
        ),
      ),
    );

    BoxDecoration decorationOf(int index) {
      final container = tester.widget<Container>(
        find.byKey(ValueKey('app_stepper_segment_$index')),
      );
      return container.decoration! as BoxDecoration;
    }

    expect(decorationOf(0).color, AppColors.primary);
    expect(decorationOf(1).color, AppColors.primary);
    expect(decorationOf(2).color, AppColors.cardBackground);
    expect(decorationOf(3).color, AppColors.cardBackground);
  });
}
