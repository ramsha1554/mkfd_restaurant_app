import '../../../../data/models/user.dart';

enum AuthStatus {
  initial,
  unauthenticated,
  authenticating,
  authenticated,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? phone;
  final String? countryCode;
  final bool isLoading;
  final String? errorMessage;
  final String? debugOtp;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.phone,
    this.countryCode,
    this.isLoading = false,
    this.errorMessage,
    this.debugOtp,
  });

  const AuthState.initial() : this(status: AuthStatus.initial);

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? phone,
    String? countryCode,
    bool? isLoading,
    String? errorMessage,
    String? debugOtp,
    bool clearUser = false,
    bool clearPhone = false,
    bool clearCountryCode = false,
    bool clearError = false,
    bool clearDebugOtp = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      phone: clearPhone ? null : (phone ?? this.phone),
      countryCode: clearCountryCode
          ? null
          : (countryCode ?? this.countryCode),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      debugOtp: clearDebugOtp ? null : (debugOtp ?? this.debugOtp),
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isInitial => status == AuthStatus.initial;

  @override
  String toString() =>
      'AuthState(status: $status, phone: $phone, countryCode: $countryCode, loading: $isLoading, error: $errorMessage, user: $user, debugOtp: $debugOtp)';
}
