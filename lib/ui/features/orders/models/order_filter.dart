import '../../../../data/models/order.dart';

enum OrderFilter { all, newOrders, preparing, ready, pickedUp, delivered, cancelled }

extension OrderFilterX on OrderFilter {
  String get label => switch (this) {
        OrderFilter.all => 'All',
        OrderFilter.newOrders => 'New',
        OrderFilter.preparing => 'Preparing',
        OrderFilter.ready => 'Ready',
        OrderFilter.pickedUp => 'Picked up',
        OrderFilter.delivered => 'Delivered',
        OrderFilter.cancelled => 'Cancelled',
      };

  bool get isActive =>
      this == OrderFilter.newOrders ||
      this == OrderFilter.preparing ||
      this == OrderFilter.ready ||
      this == OrderFilter.pickedUp;

  bool get isHistory => !isActive;

  List<String> get activeStatuses => switch (this) {
        OrderFilter.newOrders => const ['placed'],
        OrderFilter.preparing => const ['confirmed', 'preparing'],
        OrderFilter.ready => const ['ready', 'arrived_at_restaurant'],
        OrderFilter.pickedUp => const ['picked_up', 'on_the_way'],
        _ => const [],
      };

  List<String> get historyStatuses => switch (this) {
        OrderFilter.delivered => const ['delivered'],
        OrderFilter.cancelled => const ['cancelled', 'rejected'],
        _ => const [],
      };

  bool matches(OrderModel order) {
    if (this == OrderFilter.all) return true;
    final status = order.rawStatus?.toLowerCase();
    if (status == null) return false;
    return isActive
        ? activeStatuses.contains(status)
        : historyStatuses.contains(status);
  }
}

const List<String> kActiveOrderStatuses = [
  'placed',
  'confirmed',
  'preparing',
  'ready',
  'arrived_at_restaurant',
  'picked_up',
  'on_the_way',
];
