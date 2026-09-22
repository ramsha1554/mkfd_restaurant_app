import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/utils/app_log.dart';
import '../../../../data/api/api_client.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/services/auth_storage_service.dart';
import 'auth_state.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = locator<AuthRepository>();
  final storage = locator<AuthStorageService>();
  return AuthNotifier(repo, storage);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  final AuthStorageService _storage;

  AuthNotifier(this._repo, this._storage)
      : super(const AuthState.initial()) {
    locator<ApiClient>().onSessionExpired = () async {
      AppLog.w('AUTH', 'onSessionExpired', 'session expired — signing out');
      if (!mounted) return;
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        clearError: false,
        isLoading: false,
      );
    };
  }

  Future<void> restoreSession() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final token = await _storage.getAccessToken();
      if (token == null || token.isEmpty) {
        if (!mounted) return;
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
        );
        return;
      }
      final user = await _repo.getMe();
      if (!mounted) return;
      if (user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          phone: user.phone ?? _storage.phone,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          phone: _storage.phone,
          isLoading: false,
        );
      }
      AppLog.i('AUTH', 'restoreSession', 'restored',
          {'phone': state.phone});
    } catch (e, s) {
      AppLog.e('AUTH', 'restoreSession', 'failed', e, s);
      if (!mounted) return;
      final isAuthError = e is ApiException && e.statusCode == 401;
      if (isAuthError) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
          errorMessage: AppError.message(e),
        );
      }
    }
  }

  Future<void> requestOtp({
    required String phone,
    String role = 'customer',
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearDebugOtp: true,
      phone: phone,
    );
    try {
      final code = await _repo.requestOtp(phone: phone, role: role);
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        debugOtp: code,
        status: AuthStatus.authenticating,
      );
      AppLog.i('AUTH', 'requestOtp', 'otp requested');
    } catch (e, s) {
      AppLog.e('AUTH', 'requestOtp', 'failed', e, s);
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppError.message(e),
      );
    }
  }

  Future<bool> verifyOtp({
    required String phone,
    required String code,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final data = await _repo.verifyOtp(phone: phone, code: code);
      if (!mounted) return false;
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: data.user,
        phone: phone,
        isLoading: false,
        clearError: true,
        clearDebugOtp: true,
      );
      AppLog.i('AUTH', 'verifyOtp', 'verified');
      return true;
    } catch (e, s) {
      AppLog.e('AUTH', 'verifyOtp', 'failed', e, s);
      if (!mounted) return false;
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppError.message(e),
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _repo.logout();
    } catch (e) {
      AppLog.w('AUTH', 'logout', 'error', e);
    }
    if (!mounted) return;
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      clearUser: true,
      clearPhone: false,
      clearError: true,
      clearDebugOtp: true,
      isLoading: false,
    );
  }

  Future<void> handleSessionExpired() async {
    await _storage.clearAll();
    if (!mounted) return;
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      clearUser: true,
      isLoading: false,
    );
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(clearError: true);
    }
  }
}
