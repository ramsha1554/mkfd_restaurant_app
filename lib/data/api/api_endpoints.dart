abstract final class ApiEndpoints {
  // Auth
  static const String requestOtp = '/auth/request-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';

  // User
  static const String me = '/users/me';
  static const String updateMe = '/users/me';
  static const String fcmToken = '/users/me/fcm-token';

  // Restaurant
  static const String myRestaurant = '/restaurants/my-restaurant';

  static String restaurantStatus(String id) => '/restaurants/$id/status';

  // Orders
  static String restaurantOrders(String restaurantId) =>
      '/restaurants/$restaurantId/orders';

  static String orderConfirm(String orderId) => '/orders/$orderId/confirm';
  static String orderPreparing(String orderId) => '/orders/$orderId/preparing';
  static String orderReady(String orderId) => '/orders/$orderId/ready';
  static String orderReject(String orderId) => '/orders/$orderId/reject';

  const ApiEndpoints._();
}
