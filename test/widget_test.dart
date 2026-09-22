import 'package:flutter_test/flutter_test.dart';
import 'package:mk_food_restaurant/main.dart';

void main() {
  testWidgets('App boots to splash', (tester) async {
    await tester.pumpWidget(const MKRestaurantApp());
    expect(find.text('MK Foods'), findsOneWidget);
    expect(find.text('Restaurant'), findsOneWidget);
  });
}
