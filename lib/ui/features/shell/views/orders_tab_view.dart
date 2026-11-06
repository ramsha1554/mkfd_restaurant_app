import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_states.dart';
import '../providers/restaurant_provider.dart';
import '../widgets/store_controls_card.dart';

class OrdersTabView extends ConsumerWidget {
  const OrdersTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(restaurantProvider);
    final restaurant = state.restaurant;

    if (restaurant == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const AppAppBar(title: 'Orders'),
        body: const Center(child: AppLoading()),
      );
    }

    final city = restaurant.address?.city?.trim();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'Orders'),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          final error =
              await ref.read(restaurantProvider.notifier).load(silent: true);
          if (error != null && context.mounted) {
            AppSnackbar.showError(context, error);
          }
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.sm,
            AppSpacing.screenPadding,
            AppSpacing.xxl,
          ),
          children: [
            if (restaurant.name?.isNotEmpty == true)
              Text(restaurant.name!, style: AppTextStyles.h2),
            if (city?.isNotEmpty == true) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(city!, style: AppTextStyles.bodySecondary),
            ],
            const SizedBox(height: AppSpacing.md),
            const StoreControlsCard(),
            const SizedBox(height: AppSpacing.xl),
            const AppEmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'Orders will appear here',
            ),
          ],
        ),
      ),
    );
  }
}
