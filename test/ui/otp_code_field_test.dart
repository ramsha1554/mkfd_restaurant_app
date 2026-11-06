import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/ui/features/auth/widgets/otp_code_field.dart';

void main() {
  testWidgets('supports a four-digit code', (tester) async {
    String? changed;
    String? completed;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OtpCodeField(
            length: 4,
            onChanged: (value) => changed = value,
            onCompleted: (value) => completed = value,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '1234');
    await tester.pump();

    expect(changed, '1234');
    expect(completed, '1234');
    expect(find.text('1'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('keeps the six-digit default', (tester) async {
    String? completed;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OtpCodeField(
            onChanged: (_) {},
            onCompleted: (value) => completed = value,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '123456');
    await tester.pump();

    expect(completed, '123456');
  });
}
