import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_switch_row.dart';
import '../providers/restaurant_provider.dart';

class StoreControlsCard extends ConsumerWidget {
  const StoreControlsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(restaurantProvider);
    final notifier = ref.read(restaurantProvider.notifier);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AppSwitchRow(
                title: 'Store open',
                caption: state.isOpen
                    ? 'Accepting orders'
                    : 'Not accepting orders',
                value: state.isOpen,
                isLocked: state.isUpdatingOpen,
                onChanged: (value) async {
                  if (!value) {
                    final confirmed = await showAppConfirmDialog(
                      context: context,
                      title: 'Close store?',
                      message:
                          "You won't receive new orders until you open again.",
                      confirmLabel: 'Close store',
                      icon: Icons.storefront_outlined,
                    );
                    if (confirmed != true) return;
                  }
                  if (!context.mounted) return;
                  final error = await notifier.setOpen(value);
                  if (error != null && context.mounted) {
                    AppSnackbar.showError(context, error);
                  }
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Container(width: 1, color: AppColors.divider),
            ),
            Expanded(
              child: AppSwitchRow(
                title: 'Busy mode',
                caption: state.isBusy ? 'Busy' : 'Standard prep',
                value: state.isBusy,
                isLocked: state.isUpdatingBusy,
                onChanged: (value) async {
                  final error = await notifier.setBusy(value);
                  if (error != null && context.mounted) {
                    AppSnackbar.showError(context, error);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
