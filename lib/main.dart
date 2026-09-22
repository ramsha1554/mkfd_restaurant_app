import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/locator.dart';
import 'core/utils/navigation.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/features/auth/providers/auth_provider.dart';
import 'ui/features/auth/providers/auth_state.dart';
import 'ui/features/auth/views/welcome_view.dart';
import 'ui/features/splash/views/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const ProviderScope(child: MKRestaurantApp()));
}

class MKRestaurantApp extends ConsumerWidget {
  const MKRestaurantApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authProvider, (prev, next) {
      final wasAuth = prev?.status == AuthStatus.authenticated;
      final nowUnauth = next.status == AuthStatus.unauthenticated;
      if (wasAuth && nowUnauth) {
        navigatorKey.currentState?.pushAndRemoveUntil(
          slideRightFadeRoute(const WelcomeView()),
          (r) => false,
        );
      }
    });

    return MaterialApp(
      title: 'MK Foods Restaurant',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: AppTheme.light,
      home: const SplashView(),
    );
  }
}
