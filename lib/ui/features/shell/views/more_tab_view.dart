import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/navigation.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/views/welcome_view.dart';
import '../../orders/providers/orders_provider.dart';
import '../providers/restaurant_provider.dart';
import '../providers/shell_provider.dart';

class MoreTabView extends ConsumerWidget {
  const MoreTabView({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: 'Log out?',
      message: 'You will need to sign in again to manage your restaurant.',
      confirmLabel: 'Log out',
      isDestructive: true,
      icon: Icons.logout,
    );
    if (confirmed != true || !context.mounted) return;

    ref.invalidate(restaurantProvider);
    ref.invalidate(ordersProvider);
    ref.invalidate(shellProvider);
    await ref.read(authProvider.notifier).logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      slideRightFadeRoute(const WelcomeView()),
      (r) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'More'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            AppCard(
              padding: EdgeInsets.zero,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: AppRadius.rMd,
                  onTap: () => _logout(context, ref),
                  child: Padding(
                    padding: AppSpacing.lgAll,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          size: AppIconSize.sm,
                          color: AppColors.errorText,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            'Log out',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.errorText,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: AppIconSize.sm,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Version ${AppConfig.appVersion}',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ],
        ),
      ),
    );
  }
}
