import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_chip.dart';
import '../models/order_filter.dart';
import '../providers/orders_state.dart';

class OrderFilterBar extends StatelessWidget {
  final OrdersState state;
  final ValueChanged<OrderFilter> onSelected;

  const OrderFilterBar({
    super.key,
    required this.state,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
      ),
      child: Row(
        children: [
          for (final filter in OrderFilter.values) ...[
            AppFilterChip(
              label: _label(filter),
              selected: state.filter == filter,
              onTap: () => onSelected(filter),
            ),
            if (filter != OrderFilter.values.last)
              const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }

  String _label(OrderFilter filter) {
    final count = state.countFor(filter);
    if (count <= 0) return filter.label;
    final truncated = state.isTruncated(filter);
    final suffix = truncated &&
            filter != OrderFilter.all &&
            filter != OrderFilter.delivered
        ? '+'
        : '';
    return '${filter.label} ($count$suffix)';
  }
}
