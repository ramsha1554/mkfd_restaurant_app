import 'package:flutter/material.dart';
import 'core/di/locator.dart';
import 'core/utils/navigation.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/features/splash/views/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MKRestaurantApp());
}

class MKRestaurantApp extends StatelessWidget {
  const MKRestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MK Foods Restaurant',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: AppTheme.light,
      home: const SplashView(),
    );
  }
}
