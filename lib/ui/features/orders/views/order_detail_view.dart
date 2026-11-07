import 'dart:async';
import 'dart:ui' as ui;

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
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_info_banner.dart';
import '../../../core/widgets/app_offline_banner.dart';
import '../../../core/widgets/app_section_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';
import '../providers/orders_provider.dart';
import '../providers/orders_state.dart';
import '../utils/order_money.dart';
import '../widgets/order_call_button.dart';
import '../widgets/pickup_sheet.dart';
import '../widgets/reject_order_sheet.dart';

class OrderDetailView extends ConsumerWidget {
  final String orderId;

  const OrderDetailView({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ordersProvider);
    final order = _findOrder(state, orderId);

    if (order == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const AppAppBar(title: 'Order detail'),
        body: AppErrorState(
          title: 'Order not found',
          description: 'This order is no longer available.',
          onRetry: () => ref.read(ordersProvider.notifier).refresh(),
        ),
      );
    }

    final notifier = ref.read(ordersProvider.notifier);
    final actionBar = _actionBar(context, ref, state, order, notifier);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: _orderLabel(order),
        actions: [
          Center(child: AppStatusBadge.status(order.rawStatus ?? 'unknown')),
          const SizedBox(width: AppSpacing.screenPadding),
        ],
      ),
      bottomNavigationBar: actionBar,
      body: Column(
        children: [
          if (state.isOffline)
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.sm,
                AppSpacing.screenPadding,
                0,
              ),
              child: AppOfflineBanner(),
            )
          else if (state.isStale)
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.sm,
                AppSpacing.screenPadding,
                0,
              ),
              child: AppInfoBanner(
                message: 'This order may be out of date. Pull to refresh.',
                icon: Icons.sync_problem_outlined,
                tone: AppInfoBannerTone.info,
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              onRefresh: () async {
                final error = await notifier.refresh();
                if (error != null && context.mounted) {
                  AppSnackbar.showError(context, error);
                }
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.md,
                  AppSpacing.screenPadding,
                  AppSpacing.xxl,
                ),
                children: [
                  _headerCard(order),
                  const SizedBox(height: AppSpacing.md),
                  _customerCard(order),
                  if (_specialInstructions(order) != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    AppInfoBanner(
                      prominent: true,
                      title: 'Special instructions',
                      message: '"${_specialInstructions(order)}"',
                      icon: Icons.edit_note_outlined,
                      tone: AppInfoBannerTone.warning,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  _itemsCard(order),
                  const SizedBox(height: AppSpacing.md),
                  _earningsCard(order),
                  ..._driverSection(order),
                  if (_reason(order) != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    AppInfoBanner(
                      message: _reason(order)!,
                      icon: Icons.info_outline,
                      tone: AppInfoBannerTone.error,
                    ),
                  ],
                  if (order.status == OrderStatus.placed &&
                      order.acceptanceExpiresAt != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _ResponseCountdown(expiresAt: order.acceptanceExpiresAt!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCard(OrderModel order) {
    final payment = _paymentLabel(order);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          const Icon(
            Icons.schedule_outlined,
            size: AppIconSize.sm,
            color: AppColors.primaryText,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Placed ${AppFormat.timeAgo(order.createdAt)} · '
              '${AppFormat.dayMonth(order.createdAt)} · '
              '${AppFormat.time12(order.createdAt)}',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          if (payment != null) ...[
            const SizedBox(width: AppSpacing.sm),
            AppStatusBadge(
              label: payment,
              fg: AppColors.infoText,
              bg: AppColors.infoBg,
            ),
          ],
        ],
      ),
    );
  }

  Widget _customerCard(OrderModel order) {
    final name = order.customer?.name?.trim();
    final phone = order.customer?.phone?.trim();
    final address = _addressText(order.deliveryAddress);

    return AppSectionCard(
      eyebrow: 'Customer details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name == null || name.isEmpty ? 'Customer' : name,
                      style: AppTextStyles.title,
                    ),
                    if (phone != null && phone.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(phone, style: AppTextStyles.bodySecondary),
                    ],
                  ],
                ),
              ),
              if (phone != null && phone.isNotEmpty)
                OrderCallButton(phone: phone, semanticLabel: 'Call customer'),
            ],
          ),
          if (address != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on,
                  size: AppIconSize.xs,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _itemsCard(OrderModel order) {
    final items = order.items ?? const <OrderItem>[];
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order items (${items.length})', style: AppTextStyles.h2),
          if (items.isEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text('No items', style: AppTextStyles.bodySecondary),
          ] else
            for (var i = 0; i < items.length; i++) ...[
              const SizedBox(height: AppSpacing.md),
              _itemRow(items[i]),
              if (i < items.length - 1) ...[
                const SizedBox(height: AppSpacing.md),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.divider,
                ),
              ],
            ],
        ],
      ),
    );
  }

  Widget _itemRow(OrderItem item) {
    final quantity = item.quantity ?? 1;
    final name = item.name?.trim();
    final note = item.specialInstructions?.trim();
    final amount = item.itemTotal ?? ((item.price ?? 0) * quantity);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$quantity×',
          style: AppTextStyles.cardTitle.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name == null || name.isEmpty ? 'Item' : name,
                style: AppTextStyles.cardTitle,
              ),
              if (note != null && note.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Note: $note',
                  style: AppTextStyles.bodySecondary.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          AppFormat.currency(amount),
          style: AppTextStyles.cardTitle.copyWith(
            fontFeatures: const [ui.FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Widget _earningsCard(OrderModel order) {
    final money = orderMoney(order);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Earnings breakdown', style: AppTextStyles.h2),
              const Spacer(),
              Text('Restaurant payout', style: AppTextStyles.bodySecondary),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _moneyRow('Food subtotal', AppFormat.currency(money.subtotal)),
          const SizedBox(height: AppSpacing.sm),
          _moneyRow(
            'Commission (${_rateLabel(money.commissionRate)}%)',
            '−${AppFormat.currency(money.commissionAmount)}',
            valueColor: AppColors.errorText,
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: AppRadius.rSm,
            ),
            child: Row(
              children: [
                Text('Your payout', style: AppTextStyles.price),
                const Spacer(),
                Text(
                  AppFormat.currency(money.payout),
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Delivery and customer fees are not included in your payout.',
            style: AppTextStyles.bodySecondary,
          ),
        ],
      ),
    );
  }

  Widget _moneyRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTextStyles.body)),
        Text(
          value,
          style: AppTextStyles.price.copyWith(
            color: valueColor,
            fontFeatures: const [ui.FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  List<Widget> _driverSection(OrderModel order) {
    final driver = order.driver;
    final driverName = driver?.name?.trim();
    final driverPhone = driver?.phone?.trim();
    final hasDriver =
        (driverName != null && driverName.isNotEmpty) ||
        (driverPhone != null && driverPhone.isNotEmpty);

    final widgets = <Widget>[];
    if (isDriverWaiting(order)) {
      widgets.add(const SizedBox(height: AppSpacing.md));
      widgets.add(
        AppInfoBanner(
          message: driverName == null || driverName.isEmpty
              ? 'Driver is waiting'
              : 'Driver is waiting · $driverName',
          icon: Icons.two_wheeler_outlined,
          tone: AppInfoBannerTone.warning,
        ),
      );
    }

    if (hasDriver) {
      widgets.add(const SizedBox(height: AppSpacing.md));
      widgets.add(
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              const AppIconBubble.row(
                icon: Icons.delivery_dining_outlined,
                bg: AppColors.infoBg,
                fg: AppColors.infoText,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverName == null || driverName.isEmpty
                          ? 'Driver'
                          : driverName,
                      style: AppTextStyles.title,
                    ),
                    if (driverPhone != null && driverPhone.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(driverPhone, style: AppTextStyles.bodySecondary),
                    ],
                  ],
                ),
              ),
              if (driverPhone != null && driverPhone.isNotEmpty)
                OrderCallButton(
                  phone: driverPhone,
                  semanticLabel: 'Call driver',
                ),
            ],
          ),
        ),
      );
    } else if (_showsNoDriver(order)) {
      widgets.add(const SizedBox(height: AppSpacing.md));
      widgets.add(
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.infoBg,
            borderRadius: AppRadius.rSm,
            border: Border.all(
              color: AppColors.infoText.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const AppIconBubble.row(
                icon: Icons.hourglass_empty,
                bg: AppColors.surface,
                fg: AppColors.infoText,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No driver assigned yet',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.infoText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'A driver is searched after you accept.',
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

    return widgets;
  }

  bool _showsNoDriver(OrderModel order) {
    return order.status == OrderStatus.placed ||
        order.status == OrderStatus.confirmed ||
        order.status == OrderStatus.preparing ||
        order.status == OrderStatus.ready;
  }

  String? _paymentLabel(OrderModel order) {
    final raw = order.paymentMethod?.trim();
    if (raw == null || raw.isEmpty) return null;
    final method = raw.toLowerCase();
    if (method == 'cash') return 'Cash';
    if (method == 'payment_link') {
      final status = order.paymentStatus?.trim();
      if (status == null || status.isEmpty) return 'Online';
      if (status.toLowerCase() == 'paid') return 'Paid online';
      return 'Online · $status';
    }
    return raw;
  }

  String? _specialInstructions(OrderModel order) {
    final text = order.specialInstructions?.trim();
    return text == null || text.isEmpty ? null : text;
  }

  String? _reason(OrderModel order) {
    final cancellation = order.cancellationReason?.trim();
    if (cancellation != null && cancellation.isNotEmpty) return cancellation;
    final rejection = order.rejectionReason?.trim();
    if (rejection != null && rejection.isNotEmpty) return rejection;
    return null;
  }

  String? _addressText(OrderAddress? address) {
    if (address == null) return null;
    final full = address.fullAddress?.trim();
    if (full != null && full.isNotEmpty) return full;
    final parts = [
      address.street?.trim(),
      address.city?.trim(),
      address.postcode?.trim(),
    ].whereType<String>().where((part) => part.isNotEmpty).toList();
    if (parts.isNotEmpty) return parts.join(', ');
    final label = address.label?.trim();
    return label == null || label.isEmpty ? null : label;
  }

  String _rateLabel(double rate) {
    return rate == rate.roundToDouble()
        ? '${rate.toInt()}'
        : rate.toStringAsFixed(1);
  }

  OrderModel? _findOrder(OrdersState state, String id) {
    for (final order in state.activeOrders) {
      if (order.id == id) return order;
    }
    for (final page in state.history.values) {
      for (final order in page.orders) {
        if (order.id == id) return order;
      }
    }
    return null;
  }

  String _orderLabel(OrderModel order) {
    final number = order.orderNumber?.trim();
    if (number == null || number.isEmpty) return '#—';
    return number.startsWith('#') ? number : '#$number';
  }

  Widget? _actionBar(
    BuildContext context,
    WidgetRef ref,
    OrdersState state,
    OrderModel order,
    OrdersNotifier notifier,
  ) {
    final busy = state.inFlightIds.contains(order.id);
    final canAct = !state.isStale && !state.isOffline && !busy;

    final Widget? content;
    if (order.status == OrderStatus.placed) {
      content = Row(
        children: [
          Expanded(
            flex: 35,
            child: AppOutlinedButton(
              label: 'Reject',
              icon: Icons.close,
              onPressed: canAct ? () => _reject(context, ref, order) : null,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            flex: 65,
            child: AppPrimaryButton(
              label: 'Accept order',
              icon: Icons.check_circle,
              isLoading: busy,
              onPressed: canAct
                  ? () => _run(context, () => notifier.accept(order.id!))
                  : null,
            ),
          ),
        ],
      );
    } else if (order.status == OrderStatus.confirmed) {
      content = AppPrimaryButton(
        label: 'Start preparing',
        icon: Icons.restaurant_outlined,
        isLoading: busy,
        onPressed: canAct
            ? () => _run(context, () => notifier.startPreparing(order.id!))
            : null,
      );
    } else if (order.status == OrderStatus.preparing) {
      content = AppPrimaryButton(
        label: 'Mark as ready',
        icon: Icons.room_service_outlined,
        isLoading: busy,
        onPressed: canAct
            ? () => _run(context, () => notifier.markReady(order.id!))
            : null,
      );
    } else if (canVerifyPickup(order)) {
      content = AppPrimaryButton(
        label: 'Verify pickup code',
        icon: Icons.pin_outlined,
        isLoading: busy,
        onPressed: canAct ? () => _verifyPickup(context, ref, order) : null,
      );
    } else {
      content = null;
    }

    if (content == null) return null;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: content,
        ),
      ),
    );
  }

  Future<void> _run(
    BuildContext context,
    Future<String?> Function() action,
  ) async {
    final error = await action();
    if (!context.mounted || error == null) return;
    AppSnackbar.showError(context, error);
  }

  Future<void> _reject(
    BuildContext context,
    WidgetRef ref,
    OrderModel order,
  ) async {
    final id = order.id;
    if (id == null) return;
    final rejected = await showAppSheet<bool>(
      context: context,
      title: 'Reject this order?',
      builder: (_) => RejectOrderSheet(
        onReject: (reason) =>
            ref.read(ordersProvider.notifier).reject(id, reason),
      ),
    );
    if (!context.mounted || rejected != true) return;
    Navigator.of(context).pop();
  }

  Future<void> _verifyPickup(
    BuildContext context,
    WidgetRef ref,
    OrderModel order,
  ) async {
    final id = order.id;
    if (id == null) return;
    final verified = await showVerifyPickupSheet(
      context: context,
      onVerify: (code) =>
          ref.read(ordersProvider.notifier).verifyPickup(id, code),
    );
    if (!context.mounted || verified != true) return;
    AppSnackbar.showSuccess(context, 'Pickup verified');
  }
}

class _ResponseCountdown extends StatefulWidget {
  final String expiresAt;

  const _ResponseCountdown({required this.expiresAt});

  @override
  State<_ResponseCountdown> createState() => _ResponseCountdownState();
}

class _ResponseCountdownState extends State<_ResponseCountdown> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _remaining = _remainingFor(widget.expiresAt);
    if (_remaining > Duration.zero) {
      _timer = Timer.periodic(AppDurations.countdown, (_) {
        final remaining = _remainingFor(widget.expiresAt);
        if (!mounted) return;
        setState(() => _remaining = remaining);
        if (remaining <= Duration.zero) {
          _timer?.cancel();
          _timer = null;
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expired = _remaining <= Duration.zero;
    final message = expired
        ? 'Time to respond has run out'
        : 'Respond within ${_format(_remaining)}';
    return AppInfoBanner(
      message: message,
      icon: Icons.timer_outlined,
      tone: AppInfoBannerTone.warning,
    );
  }

  Duration _remainingFor(String iso) {
    final expiry = DateTime.tryParse(iso)?.toLocal();
    if (expiry == null) return Duration.zero;
    final remaining = expiry.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  String _format(Duration remaining) {
    final seconds = remaining.inSeconds;
    final minutes = seconds ~/ 60;
    final rest = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${rest.toString().padLeft(2, '0')}';
  }
}
