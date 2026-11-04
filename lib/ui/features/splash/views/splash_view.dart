import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/animations/app_animations.dart';
import '../../../../core/animations/app_durations.dart';
import '../../../../core/utils/navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/auth_state.dart';
import '../../auth/views/signed_in_view.dart';
import '../../auth/views/welcome_view.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(AppDurations.slowest + AppDurations.medium);
    if (!mounted) return;
    await ref.read(authProvider.notifier).restoreSession();
    if (!mounted) return;

    final auth = ref.read(authProvider);
    await Future<void>.delayed(AppDurations.fast);
    if (!mounted) return;

    if (auth.status == AuthStatus.authenticated) {
      Navigator.of(context).pushAndRemoveUntil(
        slideRightFadeRoute(const SignedInView()),
        (r) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        slideRightFadeRoute(const WelcomeView()),
        (r) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (prev, next) {
      if (prev?.status == AuthStatus.authenticated &&
          next.status == AuthStatus.unauthenticated) {
        navigatorKey.currentState?.pushAndRemoveUntil(
          slideRightFadeRoute(const WelcomeView()),
          (r) => false,
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AppFadeIn(
          duration: const Duration(milliseconds: 600),
          child: Image.asset(
            'assets/images/MK-Tour-Logo.png',
            width: 96,
            height: 96,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
