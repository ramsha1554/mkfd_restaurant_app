import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/constants/app_config.dart';
import '../../core/error/app_error.dart';
import '../../core/utils/app_log.dart';
import '../services/auth_storage_service.dart';
import 'api_endpoints.dart';

class ApiClient {
  final Dio _dio;
  final AuthStorageService _storage;

  Future<void> Function()? onSessionExpired;

  Completer<bool>? _refreshCompleter;

  ApiClient(this._storage, {this.onSessionExpired})
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.apiBaseUrl,
            connectTimeout: const Duration(milliseconds: 15000),
            receiveTimeout: const Duration(milliseconds: 15000),
            sendTimeout: const Duration(milliseconds: 15000),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
          ),
        ) {
    _dio.interceptors.add(_LoggingInterceptor());
    _dio.interceptors.add(_AuthInterceptor(
      dio: _dio,
      storage: _storage,
      getRefreshCompleter: () => _refreshCompleter,
      setRefreshCompleter: (c) => _refreshCompleter = c,
      onSessionExpired: () async {
        if (onSessionExpired != null) await onSessionExpired!.call();
      },
    ));
  }

  Dio get dio => _dio;


  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      return _unwrap(res);
    } on DioException catch (e, s) {
      throw _mapDio(e, s);
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _unwrap(res);
    } on DioException catch (e, s) {
      throw _mapDio(e, s);
    }
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _unwrap(res);
    } on DioException catch (e, s) {
      throw _mapDio(e, s);
    }
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final res = await _dio.delete<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _unwrap(res);
    } on DioException catch (e, s) {
      throw _mapDio(e, s);
    }
  }

  Future<Map<String, dynamic>> uploadFile(
    String path,
    String fieldName,
    File file, [
    Map<String, dynamic> extraFields = const {},
  ]) async {
    try {
      final form = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(file.path),
        ...extraFields,
      });
      final res = await _dio.post<Map<String, dynamic>>(path, data: form);
      return _unwrap(res);
    } on DioException catch (e, s) {
      throw _mapDio(e, s);
    }
  }

  Map<String, dynamic> _unwrap(Response<Map<String, dynamic>> res) {
    final data = res.data;
    if (data == null) {
      if (res.statusCode != null &&
          res.statusCode! >= 200 &&
          res.statusCode! < 300) {
        return <String, dynamic>{'success': true, 'message': '', 'data': null};
      }
      throw ApiException(
        statusCode: res.statusCode,
        message: res.statusMessage ?? 'Empty response',
      );
    }
    final success = data['success'] as bool? ?? false;
    if (!success) {
      throw ApiException(
        statusCode: res.statusCode,
        message: (data['message'] as String?)?.trim().isNotEmpty == true
            ? data['message'] as String
            : 'Request failed',
        status: data['status'] as String?,
      );
    }
    return data;
  }

  Exception _mapDio(DioException e, StackTrace s) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      AppLog.e('API', 'ApiClient', 'timeout', e, s);
      return NetworkException('Connection timed out');
    }
    if (e.type == DioExceptionType.connectionError ||
        e.error is SocketException) {
      AppLog.e('API', 'ApiClient', 'connectionError', e, s);
      return NetworkException('No internet connection');
    }
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final msg = data['message'] as String?;
      final status = data['status'] as String?;
      if (msg != null && msg.trim().isNotEmpty) {
        AppLog.e('API', 'ApiClient', 'apiError ${e.response?.statusCode}: $msg', e, s);
        return ApiException(
          statusCode: e.response?.statusCode,
          message: msg,
          status: status,
        );
      }
    }
    if (e.response != null) {
      final code = e.response!.statusCode;
      final msg = e.response!.statusMessage ?? e.message ?? 'Request failed';
      AppLog.e('API', 'ApiClient', 'http $code: $msg', e, s);
      return ApiException(statusCode: code, message: msg);
    }
    AppLog.e('API', 'ApiClient', e.message ?? 'Unknown error', e, s);
    return NetworkException(e.message ?? 'Network error');
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLog.d('API', 'req', '${options.method} ${options.baseUrl}${options.path}',
        _safeData(options.data));
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLog.d('API', 'res',
        '${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLog.w('API', 'err',
        '${err.response?.statusCode} ${err.requestOptions.path} ${err.message}');
    handler.next(err);
  }

  Object? _safeData(Object? data) {
    if (data is Map) {
      final copy = Map<String, dynamic>.from(data);
      if (copy.containsKey('code')) copy['code'] = '***';
      if (copy.containsKey('refreshToken')) copy['refreshToken'] = '***';
      if (copy.containsKey('token')) copy['token'] = '***';
      return copy;
    }
    return data;
  }
}

class _AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  final AuthStorageService storage;
  final Completer<bool>? Function() getRefreshCompleter;
  final void Function(Completer<bool>?) setRefreshCompleter;
  final Future<void> Function() onSessionExpired;

  static const _excluded = {
    ApiEndpoints.requestOtp,
    ApiEndpoints.verifyOtp,
    ApiEndpoints.refreshToken,
  };

  _AuthInterceptor({
    required this.dio,
    required this.storage,
    required this.getRefreshCompleter,
    required this.setRefreshCompleter,
    required this.onSessionExpired,
  });

  bool _isExcluded(String path) {
    return _excluded.any((e) => path.contains(e));
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isExcluded(options.path)) {
      handler.next(options);
      return;
    }
    final token = await storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final path = err.requestOptions.path;

    if (status != 401 || _isExcluded(path)) {
      handler.next(err);
      return;
    }

    Completer<bool>? completer = getRefreshCompleter();
    if (completer != null) {
      final success = await completer.future;
      if (success) {
        try {
          final token = await storage.getAccessToken();
          final opts = err.requestOptions;
          if (token != null) opts.headers['Authorization'] = 'Bearer $token';
          final res = await dio.fetch<Map<String, dynamic>>(opts);
          handler.resolve(res);
          return;
        } catch (_) {
          handler.next(err);
          return;
        }
      } else {
        handler.next(err);
        return;
      }
    }

    final newCompleter = Completer<bool>();
    setRefreshCompleter(newCompleter);

    try {
      final success = await _refresh();
      newCompleter.complete(success);
      setRefreshCompleter(null);

      if (success) {
        final token = await storage.getAccessToken();
        final opts = err.requestOptions;
        if (token != null) opts.headers['Authorization'] = 'Bearer $token';
        try {
          final res = await dio.fetch<Map<String, dynamic>>(opts);
          handler.resolve(res);
          return;
        } catch (e) {
          if (e is DioException) handler.next(e);
          return;
        }
      } else {
        await storage.clearAll();
        await onSessionExpired();
        handler.next(err);
        return;
      }
    } catch (e) {
      if (!newCompleter.isCompleted) newCompleter.complete(false);
      setRefreshCompleter(null);
      await storage.clearAll();
      await onSessionExpired();
      handler.next(err);
    }
  }

  Future<bool> _refresh() async {
    try {
      final refresh = await storage.getRefreshToken();
      if (refresh == null || refresh.isEmpty) return false;

      final res = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refresh},
      );

      final data = res.data;
      if (data == null) return false;

      Map<String, dynamic>? tokenMap;
      if (data.containsKey('accessToken') || data.containsKey('refreshToken')) {
        tokenMap = data;
      } else if (data['data'] is Map<String, dynamic>) {
        final inner = data['data'] as Map<String, dynamic>;
        if (inner.containsKey('accessToken') || inner.containsKey('refreshToken')) {
          tokenMap = inner;
        } else if (inner['data'] is Map<String, dynamic>) {
          tokenMap = inner['data'] as Map<String, dynamic>;
        }
      }

      final newAccess = tokenMap?['accessToken'] as String? ??
          tokenMap?['access_token'] as String?;
      final newRefresh = tokenMap?['refreshToken'] as String? ??
          tokenMap?['refresh_token'] as String?;

      if (newAccess == null || newAccess.isEmpty) {
        AppLog.w('AUTH', '_refresh', 'no accessToken in response', data);
        return false;
      }

      await storage.saveTokens(
        accessToken: newAccess,
        refreshToken: (newRefresh != null && newRefresh.isNotEmpty)
            ? newRefresh
            : refresh,
      );
      AppLog.i('AUTH', '_refresh', 'token refreshed');
      return true;
    } catch (e, s) {
      AppLog.e('AUTH', '_refresh', 'refresh failed', e, s);
      return false;
    }
  }
}
