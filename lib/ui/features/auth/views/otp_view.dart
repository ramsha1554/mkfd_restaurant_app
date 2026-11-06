import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../shell/views/restaurant_gate_view.dart';
import '../providers/auth_provider.dart';
import '../widgets/otp_code_field.dart';

class OtpView extends ConsumerStatefulWidget {
  final String phone;

  const OtpView({super.key, required this.phone});

  @override
  ConsumerState<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends ConsumerState<OtpView> {
  String _code = '';
  Timer? _timer;
  int _seconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _canResend = false;
    _seconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        t.cancel();
        setState(() => _canResend = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _resend() async {
    await ref.read(authProvider.notifier).requestOtp(phone: widget.phone);
    if (!mounted) return;
    final state = ref.read(authProvider);
    if (state.errorMessage != null) {
      AppSnackbar.showError(context, state.errorMessage!);
      return;
    }
    AppSnackbar.showSuccess(context, 'Code resent');
    _startTimer();
  }

  Future<void> _verify() async {
    if (_code.length != 6) {
      AppSnackbar.showError(context, 'Please enter the 6-digit code');
      return;
    }
    final ok = await ref
        .read(authProvider.notifier)
        .verifyOtp(phone: widget.phone, code: _code);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushAndRemoveUntil(
        slideRightFadeRoute(const RestaurantGateView()),
        (r) => false,
      );
    } else {
      final err = ref.read(authProvider).errorMessage;
      if (err != null) AppSnackbar.showError(context, err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    ref.listen(authProvider, (prev, next) {
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        AppSnackbar.showError(context, next.errorMessage!);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorder, width: 1),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, size: 24, color: AppColors.textPrimary),
                    splashRadius: 24,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Verify your number',
                style: AppTextStyles.h1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "We've sent a 6-digit code to",
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.phone, style: AppTextStyles.cardTitle),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      'Change ›',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Enter the 6-digit code',
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              OtpCodeField(
                enabled: !auth.isLoading,
                onChanged: (v) => setState(() => _code = v),
                onCompleted: (v) {
                  setState(() => _code = v);
                  _verify();
                },
              ),
              const SizedBox(height: 24),
              AppPrimaryButton(
                label: 'Verify OTP',
                isLoading: auth.isLoading,
                onPressed: auth.isLoading ? null : _verify,
              ),
              const SizedBox(height: 16),
              Center(
                child: _canResend
                    ? GestureDetector(
                        onTap: _resend,
                        child: Text(
                          'Resend code',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    : Text(
                        "Didn't receive the code? Resend in 0:${_seconds.toString().padLeft(2, '0')}",
                        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                      ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outlined, size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Your information is secure with us. We never share your details with anyone.',
                      style: AppTextStyles.bodySecondary,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
