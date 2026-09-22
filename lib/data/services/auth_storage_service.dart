import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorageService {
  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';
  static const _kUserId = 'user_id';
  static const _kPhone = 'phone';
  static const _kIsVerified = 'is_verified';
  static const _kIsNewUser = 'is_new_user';

  final FlutterSecureStorage _secure;
  final SharedPreferences _prefs;

  AuthStorageService(this._secure, this._prefs);

  Future<String?> getAccessToken() => _secure.read(key: _kAccessToken);
  Future<String?> getRefreshToken() => _secure.read(key: _kRefreshToken);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secure.write(key: _kAccessToken, value: accessToken);
    await _secure.write(key: _kRefreshToken, value: refreshToken);
  }

  Future<void> saveAccessToken(String token) async {
    await _secure.write(key: _kAccessToken, value: token);
  }

  Future<void> clearTokens() async {
    await _secure.delete(key: _kAccessToken);
    await _secure.delete(key: _kRefreshToken);
  }


  String? get userId => _prefs.getString(_kUserId);
  String? get phone => _prefs.getString(_kPhone);
  bool get isVerified => _prefs.getBool(_kIsVerified) ?? false;
  bool get isNewUser => _prefs.getBool(_kIsNewUser) ?? false;

  Future<void> saveUserMeta({
    required String userId,
    required String phone,
    bool? isVerified,
    bool? isNewUser,
  }) async {
    await _prefs.setString(_kUserId, userId);
    await _prefs.setString(_kPhone, phone);
    if (isVerified != null) await _prefs.setBool(_kIsVerified, isVerified);
    if (isNewUser != null) await _prefs.setBool(_kIsNewUser, isNewUser);
  }

  Future<void> clearUserMeta() async {
    await _prefs.remove(_kUserId);
    await _prefs.remove(_kPhone);
    await _prefs.remove(_kIsVerified);
    await _prefs.remove(_kIsNewUser);
  }

  Future<void> clearAll() async {
    await clearTokens();
    await clearUserMeta();
  }

  bool get hasTokensSync => false; // reserved for sync checks; use async getters.
}
