import '../../../../data/models/order.dart';

class OrderMoney {
  final double subtotal;
  final double commissionRate;
  final double commissionAmount;
  final double payout;

  const OrderMoney({
    required this.subtotal,
    required this.commissionRate,
    required this.commissionAmount,
    required this.payout,
  });
}

OrderMoney orderMoney(OrderModel order) {
  final itemSubtotal = order.items?.fold<double>(
        0,
        (sum, item) {
          final line = item.itemTotal ??
              ((item.price ?? 0) * (item.quantity ?? 0));
          return sum + line;
        },
      ) ??
      0;

  final subtotal =
      order.subtotal ?? (itemSubtotal > 0 ? itemSubtotal : (order.total ?? 0));
  final rate = order.commissionRate ?? 15;
  final commission =
      order.commissionAmount ?? order.platformFee ?? subtotal * rate / 100;
  final payout = order.restaurantPayout ??
      (subtotal - commission > 0 ? subtotal - commission : 0);

  return OrderMoney(
    subtotal: subtotal,
    commissionRate: rate,
    commissionAmount: commission,
    payout: payout,
  );
}

bool isDriverWaiting(OrderModel order) {
  return order.status == OrderStatus.arrivedAtRestaurant ||
      order.driverWaiting == true ||
      (order.status == OrderStatus.ready && order.driverArrived == true);
}

bool canVerifyPickup(OrderModel order) {
  return order.status == OrderStatus.ready ||
      order.status == OrderStatus.arrivedAtRestaurant ||
      order.driverWaiting == true;
}
