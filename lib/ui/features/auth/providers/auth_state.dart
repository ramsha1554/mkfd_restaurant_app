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
  final bool isLoading;
  final String? errorMessage;
  final String? debugOtp;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.phone,
    this.isLoading = false,
    this.errorMessage,
    this.debugOtp,
  });

  const AuthState.initial() : this(status: AuthStatus.initial);

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? phone,
    bool? isLoading,
    String? errorMessage,
    String? debugOtp,
    bool clearUser = false,
    bool clearPhone = false,
    bool clearError = false,
    bool clearDebugOtp = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      phone: clearPhone ? null : (phone ?? this.phone),
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
      'AuthState(status: $status, phone: $phone, loading: $isLoading, error: $errorMessage, user: $user, debugOtp: $debugOtp)';
}
