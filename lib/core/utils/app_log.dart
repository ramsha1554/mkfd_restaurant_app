import 'package:flutter/foundation.dart';

/// Only place allowed to emit a log line. All other `print`/`debugPrint`
/// are forbidden by §10 greps.
abstract final class AppLog {
  static const _tags = {
    'API',
    'AUTH',
    'ORDER',
    'MENU',
    'STORE',
    'DOCS',
    'EARN',
    'NAV',
    'STATE',
    'STORAGE',
    'NOTIF',
    'UI',
    'GEO',
    'APP',
    'SOCKET',
  };

  static void d(
    String tag,
    String context,
    String message, [
    Object? payload,
  ]) {
    _log('DEBUG', tag, context, message, payload, null, null);
  }

  static void i(
    String tag,
    String context,
    String message, [
    Object? payload,
  ]) {
    _log('INFO', tag, context, message, payload, null, null);
  }

  static void w(
    String tag,
    String context,
    String message, [
    Object? payload,
  ]) {
    _log('WARN', tag, context, message, payload, null, null);
  }

  static void e(
    String tag,
    String context,
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? payload,
  ]) {
    _log('ERROR', tag, context, message, payload, error, stackTrace);
  }

  static void f(
    String tag,
    String context,
    String message, [
    Object? error,
    StackTrace? stackTrace,
    Object? payload,
  ]) {
    _log('FATAL', tag, context, message, payload, error, stackTrace);
  }

  static void _log(
    String level,
    String tag,
    String context,
    String message,
    Object? payload,
    Object? error,
    StackTrace? stackTrace,
  ) {
    if (kReleaseMode) return;
    assert(_tags.contains(tag), 'Unknown log tag: $tag. Allowed: $_tags');
    final payloadPart = payload != null ? ' {$payload}' : '';
    final errorPart = error != null ? ' | error: $error' : '';
    final stackPart = stackTrace != null ? '\n$stackTrace' : '';
    // Respect the facade rule: only here may we call debugPrint.
    // ignore: avoid_print
    debugPrint('[$level] [$tag] [$context] → $message$payloadPart$errorPart$stackPart');
  }

  const AppLog._();
}
