import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../providers/shell_provider.dart';
import 'earnings_tab_view.dart';
import 'menu_tab_view.dart';
import 'more_tab_view.dart';
import 'orders_tab_view.dart';

const List<AppBottomNavItem> shellNavItems = [
  AppBottomNavItem(icon: Icons.receipt_long_outlined, label: 'Orders'),
  AppBottomNavItem(icon: Icons.restaurant_menu_outlined, label: 'Menu'),
  AppBottomNavItem(icon: Icons.payments_outlined, label: 'Earnings'),
  AppBottomNavItem(icon: Icons.more_horiz, label: 'More'),
];

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(shellProvider).index;
    final notifier = ref.read(shellProvider.notifier);

    return PopScope(
      canPop: index == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && index != 0) notifier.select(0);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: index,
          children: const [
            OrdersTabView(),
            MenuTabView(),
            EarningsTabView(),
            MoreTabView(),
          ],
        ),
        bottomNavigationBar: AppBottomNav(
          items: shellNavItems,
          currentIndex: index,
          onTap: notifier.select,
        ),
      ),
    );
  }
}
