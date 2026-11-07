import 'package:flutter/material.dart';

import '../../../../core/utils/app_format.dart';
import '../../../../data/models/order.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_info_banner.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';
import '../utils/order_money.dart';
import 'order_call_button.dart';

class AppOrderCard extends StatelessWidget {
  final OrderModel order;
  final bool busy;
  final bool enabled;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onStartPreparing;
  final VoidCallback? onMarkReady;
  final VoidCallback? onVerifyPickup;
  final VoidCallback? onTap;

  const AppOrderCard({
    super.key,
    required this.order,
    this.busy = false,
    this.enabled = true,
    this.onAccept,
    this.onReject,
    this.onStartPreparing,
    this.onMarkReady,
    this.onVerifyPickup,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isNew = order.status == OrderStatus.placed;
    final delivered = order.status == OrderStatus.delivered;
    final money = orderMoney(order);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderColor: isNew ? AppColors.primary : null,
      borderWidth: isNew ? 1.5 : 1,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: AppSpacing.md),
          _customer(),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _itemsSummary(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body,
          ),
          if (order.specialInstructions != null) ...[
            const SizedBox(height: AppSpacing.md),
            AppInfoBanner(
              message: 'Special instructions: ${order.specialInstructions}',
              icon: Icons.edit_note_outlined,
              tone: AppInfoBannerTone.warning,
            ),
          ],
          if (_reason() != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text('Reason: ${_reason()}', style: AppTextStyles.bodySecondary),
          ],
          if (_showsDriverBanner) ...[
            const SizedBox(height: AppSpacing.md),
            _driverBanner(),
          ],
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.md),
          _footer(money: money, delivered: delivered),
          if (_hasActions) ...[
            const SizedBox(height: AppSpacing.md),
            _actions(),
          ],
        ],
      ),
    );
  }

  Widget _header() {
    final number = order.orderNumber?.trim();
    final label = number == null || number.isEmpty
        ? '#—'
        : (number.startsWith('#') ? number : '#$number');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppFormat.timeAgo(order.createdAt),
                style: AppTextStyles.bodySecondary,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        AppStatusBadge.status(order.rawStatus ?? 'unknown'),
      ],
    );
  }

  Widget _customer() {
    final name = order.customer?.name?.trim();
    final parts = name == null || name.isEmpty
        ? const <String>[]
        : name.split(RegExp(r'\s+'));
    final first = parts.isEmpty ? 'Customer' : parts.first;
    final initial = parts.isEmpty
        ? 'C'
        : parts.last.substring(0, 1).toUpperCase();
    final display = parts.length > 1 ? '$first $initial.' : first;

    return Row(
      children: [
        Container(
          width: AppIconSize.md,
          height: AppIconSize.md,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Text(
            (name == null || name.isEmpty ? 'C' : name.substring(0, 1))
                .toUpperCase(),
            style: AppTextStyles.badge.copyWith(color: AppColors.primaryText),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            display,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  String _itemsSummary() {
    final items = order.items;
    if (items == null || items.isEmpty) return 'No items';
    return items
        .map((item) {
          final quantity = item.quantity ?? 1;
          final name = item.name ?? 'Item';
          return '$quantity× $name';
        })
        .join(', ');
  }

  String? _reason() {
    if (order.status != OrderStatus.cancelled &&
        order.status != OrderStatus.rejected) {
      return null;
    }
    return order.cancellationReason ?? order.rejectionReason;
  }

  bool get _showsDriverBanner {
    return order.status == OrderStatus.ready ||
        order.status == OrderStatus.arrivedAtRestaurant;
  }

  Widget _driverBanner() {
    final driver = order.driver?.name?.trim();
    final callButton = _driverCallButton;
    if (isDriverWaiting(order)) {
      return AppInfoBanner(
        message: driver == null || driver.isEmpty
            ? 'Driver is waiting'
            : 'Driver is waiting — $driver',
        icon: Icons.two_wheeler,
        tone: AppInfoBannerTone.warning,
        trailing: callButton,
      );
    }
    if (driver != null && driver.isNotEmpty) {
      return AppInfoBanner(
        message: 'Driver assigned — $driver',
        icon: Icons.delivery_dining_outlined,
        tone: AppInfoBannerTone.info,
        trailing: callButton,
      );
    }
    return const AppInfoBanner(
      message: 'Waiting for a driver to be assigned.',
      icon: Icons.hourglass_empty,
      tone: AppInfoBannerTone.info,
    );
  }

  Widget? get _driverCallButton {
    final phone = order.driver?.phone?.trim();
    if (phone == null || phone.isEmpty) return null;
    return OrderCallButton(
      phone: phone,
      size: 32,
      semanticLabel: 'Call driver',
    );
  }

  Widget _footer({required OrderMoney money, required bool delivered}) {
    return Row(
      children: [
        if (delivered) ...[
          const Icon(
            Icons.check_circle_outline,
            size: AppIconSize.xs,
            color: AppColors.success,
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
        Text(delivered ? 'PAYOUT' : 'SUBTOTAL', style: AppTextStyles.eyebrow),
        const Spacer(),
        Text(
          AppFormat.currency(delivered ? money.payout : money.subtotal),
          style: AppTextStyles.cardTitle.copyWith(
            color: delivered ? AppColors.successText : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  bool get _hasActions {
    return order.status == OrderStatus.placed ||
        order.status == OrderStatus.confirmed ||
        order.status == OrderStatus.preparing ||
        canVerifyPickup(order);
  }

  Widget _actions() {
    if (canVerifyPickup(order)) {
      return AppOutlinedButton(
        label: 'Verify pickup code',
        icon: Icons.pin_outlined,
        height: 44,
        onPressed: enabled && !busy ? onVerifyPickup : null,
      );
    }
    return switch (order.status) {
      OrderStatus.placed => Row(
        children: [
          Expanded(
            flex: 3,
            child: AppPrimaryButton(
              label: 'Accept',
              icon: Icons.check_circle_outline,
              height: 44,
              isLoading: busy,
              onPressed: enabled && !busy ? onAccept : null,
            ),
          ),
          if (onReject != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 2,
              child: AppOutlinedButton(
                label: 'Reject',
                height: 44,
                onPressed: enabled && !busy ? onReject : null,
              ),
            ),
          ],
        ],
      ),
      OrderStatus.confirmed => AppPrimaryButton(
        label: 'Start preparing',
        icon: Icons.restaurant_outlined,
        height: 44,
        isLoading: busy,
        onPressed: enabled && !busy ? onStartPreparing : null,
      ),
      OrderStatus.preparing => AppPrimaryButton(
        label: 'Mark as ready',
        icon: Icons.room_service_outlined,
        height: 44,
        isLoading: busy,
        onPressed: enabled && !busy ? onMarkReady : null,
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
