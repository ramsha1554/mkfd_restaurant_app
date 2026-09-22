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

  const ApiEndpoints._();
}
