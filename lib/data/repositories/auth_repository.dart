import '../../core/error/app_error.dart';
import '../../core/utils/app_log.dart';
import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../models/auth_data.dart';
import '../models/user.dart';
import '../services/auth_storage_service.dart';

class AuthRepository {
  final ApiClient _client;
  final AuthStorageService _storage;

  AuthRepository(this._client, this._storage);

  Future<String?> requestOtp({
    required String phone,
    required String role,
  }) async {
    AppLog.i('AUTH', 'requestOtp', 'requesting OTP', {'phone': phone});
    final envelope = await _client.post(
      ApiEndpoints.requestOtp,
      data: {'phone': phone, 'role': role},
    );
    final data = envelope['data'];
    if (data is Map<String, dynamic>) {
      final code = data['code'] as String? ?? data['otp'] as String?;
      return code;
    }
    return null;
  }

  Future<AuthData> verifyOtp({
    required String phone,
    required String code,
  }) async {
    final envelope = await _client.post(
      ApiEndpoints.verifyOtp,
      data: {'phone': phone, 'code': code},
    );

    final raw = envelope['data'];
    Map<String, dynamic>? dataMap;
    if (raw is Map<String, dynamic>) dataMap = raw;

    if (dataMap == null) {
      throw const ApiException(
        message: 'Invalid verification response',
        statusCode: 200,
      );
    }

    AuthData parsed;
    try {
      parsed = AuthData.fromJson(dataMap);
      if (parsed.accessToken == null) {
        final nested = dataMap['data'];
        if (nested is Map<String, dynamic>) {
          try {
            final alt = AuthData.fromJson(nested);
            if (alt.accessToken != null) parsed = alt;
          } catch (_) {}
        }
      }
    } catch (e, s) {
      AppLog.e('AUTH', 'verifyOtp', 'parse failed', e, s);
      throw const ApiException(message: 'Failed to parse auth response');
    }

    String? access = parsed.accessToken;
    String? refresh = parsed.refreshToken;
    User? user = parsed.user;

    if (access == null) {
      access = dataMap['accessToken'] as String? ??
          dataMap['access_token'] as String? ??
          envelope['accessToken'] as String? ??
          envelope['access_token'] as String?;
      if (access == null && envelope['data'] is Map<String, dynamic>) {
        final envData = envelope['data'] as Map<String, dynamic>;
        access = envData['accessToken'] as String? ??
            envData['access_token'] as String?;
      }
    }
    refresh ??= dataMap['refreshToken'] as String? ??
        dataMap['refresh_token'] as String? ??
        envelope['refreshToken'] as String? ??
        envelope['refresh_token'] as String?;

    if (access == null || access.isEmpty) {
      throw const ApiException(message: 'Missing access token');
    }
    if (refresh == null || refresh.isEmpty) {
      AppLog.w('AUTH', 'verifyOtp', 'refresh token missing');
    }

    await _storage.saveTokens(
      accessToken: access,
      refreshToken: refresh ?? '',
    );

    if (user != null) {
      await _storage.saveUserMeta(
        userId: user.id ?? '',
        phone: user.phone ?? phone,
        isVerified: user.isVerified,
        isNewUser: user.isNewUser,
      );
    } else {
      await _storage.saveUserMeta(userId: '', phone: phone);
    }

    return AuthData(
      user: user,
      accessToken: access,
      refreshToken: refresh,
    );
  }

  Future<String?> refreshToken() async {
    final refresh = await _storage.getRefreshToken();
    if (refresh == null || refresh.isEmpty) return null;

    final envelope = await _client.post(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': refresh},
    );

    final data = envelope['data'];
    Map<String, dynamic>? tokenMap;
    if (envelope.containsKey('accessToken')) {
      tokenMap = envelope;
    } else if (data is Map<String, dynamic>) {
      if (data.containsKey('accessToken') ||
          data.containsKey('access_token')) {
        tokenMap = data;
      } else if (data['data'] is Map<String, dynamic>) {
        tokenMap = data['data'] as Map<String, dynamic>;
      }
    }

    final newAccess = tokenMap?['accessToken'] as String? ??
        tokenMap?['access_token'] as String?;
    final newRefresh = tokenMap?['refreshToken'] as String? ??
        tokenMap?['refresh_token'] as String?;

    if (newAccess == null || newAccess.isEmpty) return null;

    await _storage.saveTokens(
      accessToken: newAccess,
      refreshToken: (newRefresh != null && newRefresh.isNotEmpty)
          ? newRefresh
          : refresh,
    );
    return newAccess;
  }

  Future<void> logout() async {
    try {
      await _client.post(ApiEndpoints.logout);
    } catch (e) {
      AppLog.w('AUTH', 'logout', 'remote logout failed, clearing local', e);
    } finally {
      await _storage.clearAll();
    }
  }

  Future<User?> getMe() async {
    try {
      final envelope = await _client.get(ApiEndpoints.me);
      final raw = envelope['data'];
      if (raw is Map<String, dynamic>) return User.fromJson(raw);
      return null;
    } catch (e, s) {
      AppLog.e('AUTH', 'getMe', 'failed', e, s);
      rethrow;
    }
  }

  Future<String?> getStoredPhone() async => _storage.phone;
  Future<String?> getAccessToken() => _storage.getAccessToken();
}
