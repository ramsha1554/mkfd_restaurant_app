import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../../core/utils/navigation.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/secondary_button.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/views/welcome_view.dart';
import '../providers/restaurant_provider.dart';
import '../providers/restaurant_state.dart';
import '../providers/shell_provider.dart';
import 'app_shell.dart';

class RestaurantGateView extends ConsumerStatefulWidget {
  const RestaurantGateView({super.key});

  @override
  ConsumerState<RestaurantGateView> createState() =>
      _RestaurantGateViewState();
}

class _RestaurantGateViewState extends ConsumerState<RestaurantGateView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      ref.read(restaurantProvider.notifier).load();
    });
  }

  Future<void> _logout() async {
    ref.invalidate(restaurantProvider);
    ref.invalidate(shellProvider);
    await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      slideRightFadeRoute(const WelcomeView()),
      (r) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantProvider);

    switch (state.status) {
      case RestaurantLoadStatus.loading:
        return const _SkeletonShell();
      case RestaurantLoadStatus.error:
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Center(
              child: AppErrorState(
                description: state.errorMessage,
                onRetry: () =>
                    ref.read(restaurantProvider.notifier).load(),
              ),
            ),
          ),
        );
      case RestaurantLoadStatus.none:
        return _StatusPlaceholder(
          icon: Icons.storefront_outlined,
          title: 'Set up your restaurant',
          message:
              'Registration is coming soon in this app. Use the web dashboard for now.',
          onLogout: _logout,
        );
      case RestaurantLoadStatus.loaded:
        if (state.restaurant != null && state.isApproved) {
          return const AppShell();
        }
        final status =
            state.restaurant?.status?.trim().toLowerCase() ?? '';
        if (status == 'pending') {
          return _StatusPlaceholder(
            icon: Icons.hourglass_empty,
            title: 'Approval pending',
            message:
                'Your restaurant is awaiting approval. Use the web dashboard for updates.',
            onLogout: _logout,
          );
        }
        if (status == 'rejected') {
          return _StatusPlaceholder(
            icon: Icons.cancel_outlined,
            title: 'Restaurant rejected',
            message:
                'Your restaurant application was not approved. Please contact support or use the web dashboard.',
            onLogout: _logout,
          );
        }
        return _StatusPlaceholder(
          icon: Icons.info_outline,
          title: 'Awaiting approval',
          message:
              'Your restaurant is not approved yet. Use the web dashboard for updates.',
          onLogout: _logout,
        );
    }
  }
}

class _StatusPlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Future<void> Function() onLogout;

  const _StatusPlaceholder({
    required this.icon,
    required this.title,
    required this.message,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPaddingAll,
          child: Column(
            children: [
              Expanded(
                child: AppEmptyState(
                  icon: icon,
                  title: title,
                  message: message,
                ),
              ),
              AppOutlinedButton(
                label: 'Log out',
                onPressed: onLogout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonShell extends StatelessWidget {
  const _SkeletonShell();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'Orders'),
      body: AppSkeleton(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.sm,
            AppSpacing.screenPadding,
            AppSpacing.xxl,
          ),
          children: [
            const SkeletonText(height: 24, width: 160),
            const SizedBox(height: AppSpacing.sm),
            const SkeletonText(height: 12, width: 120),
            const SizedBox(height: AppSpacing.md),
            SkeletonCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SkeletonText(height: 14, width: 90),
                        const SizedBox(height: AppSpacing.sm),
                        const SkeletonText(height: 12, width: 60),
                      ],
                    ),
                  ),
                  const SkeletonBox(
                    height: 24,
                    width: 44,
                    borderRadius: AppRadius.rPill,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SkeletonCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonText(height: 16, width: 120),
                  SizedBox(height: AppSpacing.sm),
                  SkeletonText(),
                  SizedBox(height: AppSpacing.xs),
                  SkeletonText(width: 200),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        items: shellNavItems,
        currentIndex: 0,
        onTap: (_) {},
      ),
    );
  }
}
