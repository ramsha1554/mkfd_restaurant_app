import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/animations/app_durations.dart';
import '../../../../core/utils/app_format.dart';
import '../../../../data/models/order.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_info_banner.dart';
import '../../../core/widgets/app_offline_banner.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/secondary_button.dart';
import '../../shell/providers/restaurant_provider.dart';
import '../../shell/providers/shell_provider.dart';
import '../../shell/widgets/store_controls_card.dart';
import '../models/order_filter.dart';
import '../providers/orders_provider.dart';
import '../providers/orders_state.dart';
import '../widgets/app_order_card.dart';
import '../widgets/order_filter_bar.dart';
import '../widgets/reject_order_sheet.dart';

class OrdersTabView extends ConsumerStatefulWidget {
  const OrdersTabView({super.key});

  @override
  ConsumerState<OrdersTabView> createState() => _OrdersTabViewState();
}

class _OrdersTabViewState extends ConsumerState<OrdersTabView>
    with WidgetsBindingObserver {
  Timer? _pollTimer;
  ProviderSubscription<int>? _shellSubscription;
  bool _visible = true;
  bool _foreground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _visible = ref.read(shellProvider).index == 0;
    _shellSubscription = ref.listenManual<int>(
      shellProvider.select((state) => state.index),
      (previous, next) {
        final visible = next == 0;
        if (visible == _visible) return;
        _visible = visible;
        _syncPolling();
        if (visible && _foreground) {
          ref.read(ordersProvider.notifier).refresh();
          ref.read(restaurantProvider.notifier).load(silent: true);
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncPolling());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _shellSubscription?.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final foreground = state == AppLifecycleState.resumed;
    if (foreground == _foreground) return;
    _foreground = foreground;
    _syncPolling();
    if (foreground && _visible) {
      ref.read(ordersProvider.notifier).refresh();
    }
  }

  void _syncPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
    if (!_visible || !_foreground) return;
    _pollTimer = Timer.periodic(AppDurations.poll, (_) {
      if (!mounted) return;
      ref.read(ordersProvider.notifier).refreshActive();
    });
  }

  Future<void> _refresh() async {
    final results = await Future.wait<String?>([
      ref.read(ordersProvider.notifier).refresh(),
      ref.read(restaurantProvider.notifier).load(silent: true),
    ]);
    if (!mounted) return;
    final errors = results.whereType<String>();
    if (errors.isNotEmpty) {
      AppSnackbar.showError(context, errors.first);
    }
  }

  Future<void> _run(Future<String?> Function() action) async {
    final error = await action();
    if (!mounted || error == null) return;
    AppSnackbar.showError(context, error);
  }

  Future<void> _reject(OrderModel order) async {
    final id = order.id;
    if (id == null || ref.read(ordersProvider).isOffline) return;
    await showAppSheet<bool>(
      context: context,
      title: 'Reject this order?',
      builder: (_) => RejectOrderSheet(
        onReject: (reason) =>
            ref.read(ordersProvider.notifier).reject(id, reason),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final restaurantState = ref.watch(restaurantProvider);
    final restaurant = restaurantState.restaurant;
    final state = ref.watch(ordersProvider);
    final notifier = ref.read(ordersProvider.notifier);

    if (restaurant == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const AppAppBar(title: 'Orders'),
        body: const Center(child: AppLoading()),
      );
    }

    final city = restaurant.address?.city?.trim();
    final offline = state.isOffline;
    final page = state.filter.isHistory
        ? state.historyFor(state.filter)
        : const OrdersHistoryPage();
    final orders = state.filter.isActive
        ? state.activeOrders.where(state.filter.matches).toList()
        : page.orders;
    final loading = state.filter.isActive
        ? state.status == OrdersLoadStatus.loading && state.activeOrders.isEmpty
        : page.isLoading && page.orders.isEmpty;
    final errorMessage = state.filter.isActive
        ? (state.status == OrdersLoadStatus.error && state.activeOrders.isEmpty
            ? state.errorMessage
            : null)
        : (page.errorMessage != null && page.orders.isEmpty
            ? page.errorMessage
            : null);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'Orders'),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
            top: AppSpacing.sm,
            bottom: AppSpacing.xxl,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (restaurant.name?.isNotEmpty == true)
                    Text(restaurant.name!, style: AppTextStyles.h2),
                  if (city?.isNotEmpty == true) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(city!, style: AppTextStyles.bodySecondary),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  const StoreControlsCard(),
                  if (offline) ...[
                    const SizedBox(height: AppSpacing.md),
                    const AppOfflineBanner(),
                  ] else if (state.isStale) ...[
                    const SizedBox(height: AppSpacing.md),
                    const AppInfoBanner(
                      message: 'Some orders may be out of date. Pull to refresh.',
                      icon: Icons.sync_problem_outlined,
                      tone: AppInfoBannerTone.info,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
            OrderFilterBar(
              state: state,
              onSelected: notifier.selectFilter,
            ),
            const SizedBox(height: AppSpacing.md),
            if (loading)
              ..._skeletons()
            else if (errorMessage != null)
              AppErrorState(
                title: 'Could not load orders',
                description: errorMessage,
                onRetry: () => notifier.refresh(),
              )
            else if (orders.isEmpty)
              AppEmptyState(
                icon: Icons.receipt_long_outlined,
                title: state.filter == OrderFilter.all
                    ? 'No orders yet'
                    : 'No ${state.filter.label.toLowerCase()} orders',
                message: state.filter.isActive
                    ? 'New orders will appear here as they arrive.'
                    : 'Completed orders will appear here.',
              )
            else
              for (final order in orders)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    0,
                    AppSpacing.screenPadding,
                    AppSpacing.md,
                  ),
                  child: AppOrderCard(
                    order: order,
                    busy: state.inFlightIds.contains(order.id),
                    enabled: !offline,
                    onAccept: order.id == null
                        ? null
                        : () => _run(() => notifier.accept(order.id!)),
                    onReject:
                        order.id == null ? null : () => _reject(order),
                    onStartPreparing: order.id == null
                        ? null
                        : () =>
                            _run(() => notifier.startPreparing(order.id!)),
                    onMarkReady: order.id == null
                        ? null
                        : () => _run(() => notifier.markReady(order.id!)),
                  ),
                ),
            if (!loading &&
                errorMessage == null &&
                orders.isNotEmpty &&
                (state.filter == OrderFilter.all ||
                    state.filter == OrderFilter.delivered) &&
                page.hasMore)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: AppOutlinedButton(
                  label: 'Load more',
                  isLoading: page.isLoadingMore,
                  onPressed: offline || page.isLoadingMore
                      ? null
                      : () => _run(notifier.loadMore),
                ),
              ),
            if (!loading && orders.isNotEmpty && state.lastUpdated != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.sync,
                      size: AppIconSize.xs,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Last updated '
                      '${AppFormat.timeAgo(state.lastUpdated?.toIso8601String())}',
                      style: AppTextStyles.bodySecondary,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _skeletons() {
    return List.generate(3, (index) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          0,
          AppSpacing.screenPadding,
          AppSpacing.md,
        ),
        child: SkeletonCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  SkeletonText(height: 16, width: 110),
                  Spacer(),
                  SkeletonBox(
                    height: 22,
                    width: 86,
                    borderRadius: AppRadius.rSm,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const SkeletonText(height: 14, width: 150),
              const SizedBox(height: AppSpacing.sm),
              const SkeletonText(height: 12),
              const SizedBox(height: AppSpacing.xs),
              const SkeletonText(height: 12, width: 210),
              const SizedBox(height: AppSpacing.md),
              const SkeletonText(height: 14, width: 120),
            ],
          ),
        ),
      );
    });
  }
}
