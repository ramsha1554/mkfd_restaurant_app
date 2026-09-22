import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/animations/app_animations.dart';
import '../../../../core/animations/app_durations.dart';
import '../../../../core/utils/navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
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
    await Future<void>.delayed(
        AppDurations.slowest + AppDurations.medium);
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
      backgroundColor: AppColors.surface,
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPaddingAll,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeIn(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.restaurant_rounded,
                    size: 48,
                    color: AppColors.surface,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              SlideIn.fromBottom(
                child: Column(
                  children: [
                    Text(
                      'MK Foods',
                      style: AppTextStyles.display.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Restaurant',
                      style: AppTextStyles.display.copyWith(
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Milton Keynes • Restaurant Owner',
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Preparing your kitchen…',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
