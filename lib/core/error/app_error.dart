import 'package:dio/dio.dart';

/// Typed exceptions thrown by repositories. UI never sees raw [DioException].
class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final String? status;

  const ApiException({
    this.statusCode,
    required this.message,
    this.status,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

/// Single place that turns any exception into user-facing text.
/// UI must surface errors only via shared state widgets + [AppError.message],
/// never `error.toString()` or raw status codes.
abstract final class AppError {
  static String message(Object error) {
    if (error is ApiException) {
      if (error.message.trim().isNotEmpty) return error.message;
      return _byStatus(error.statusCode);
    }
    if (error is NetworkException) {
      return 'No internet connection. Please check your network and try again.';
    }
    if (error is AuthException) return error.message;
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return 'Connection timed out. Please try again.';
      }
      if (error.type == DioExceptionType.connectionError) {
        return 'Unable to reach the server. Please check your internet.';
      }
      return error.message ?? 'Something went wrong. Please try again.';
    }
    final text = error.toString();
    if (text.contains('SocketException') ||
        text.contains('Failed host lookup')) {
      return 'No internet connection. Please check your network and try again.';
    }
    return 'Something went wrong. Please try again.';
  }

  static String _byStatus(int? code) => switch (code) {
        400 => 'Invalid request. Please check and try again.',
        401 => 'Session expired. Please sign in again.',
        403 => 'Your account has been suspended. Please contact support.',
        404 => 'Not found.',
        409 => 'Conflict. Please refresh and try again.',
        422 => 'Validation failed. Please check your input.',
        429 => 'Too many requests. Please wait a moment.',
        500 => 'Server error. Please try again later.',
        _ => 'Something went wrong. Please try again.',
      };

  const AppError._();
}
