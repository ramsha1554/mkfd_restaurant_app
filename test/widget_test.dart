import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/core/constants/app_config.dart';
import 'package:mk_food_restaurant/core/utils/app_format.dart';
import 'package:mk_food_restaurant/ui/features/auth/providers/auth_state.dart';
import 'package:mk_food_restaurant/ui/features/auth/views/welcome_view.dart';

void main() {
  test('AuthState copyWith clears nullable fields', () {
    const s = AuthState(
      status: AuthStatus.authenticating,
      errorMessage: 'oops',
      phone: '+447700900000',
    );
    final cleared = s.copyWith(clearError: true, clearPhone: true);
    expect(cleared.errorMessage, isNull);
    expect(cleared.phone, isNull);
    expect(cleared.status, AuthStatus.authenticating);
  });

  test('AppFormat currency uses £ and en_GB', () {
    expect(AppFormat.currency(12.5), '£12.50');
    expect(AppFormat.currency(null), '£0.00');
  });

  test('AppConfig base URL is defined', () {
    expect(AppConfig.apiBaseUrl, isNotEmpty);
    expect(AppConfig.apiBaseUrl, contains('api/v1'));
  });

  testWidgets('Welcome shows branding', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeView()));
    expect(find.text('MK Foods'), findsOneWidget);
    expect(find.text('Restaurant'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
  });
}
