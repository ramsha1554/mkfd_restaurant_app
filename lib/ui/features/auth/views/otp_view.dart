import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';
import '../widgets/otp_fields.dart';
import 'signed_in_view.dart';

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
      AppSnackbar.showError(context, 'Enter the 6-digit code');
      return;
    }
    final ok = await ref
        .read(authProvider.notifier)
        .verifyOtp(phone: widget.phone, code: _code);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushAndRemoveUntil(
        slideRightFadeRoute(const SignedInView()),
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
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPaddingAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Enter code', style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'We sent a 6-digit code to ${widget.phone}',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSpacing.sm),
       
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Wrong number? ',
                    style: AppTextStyles.bodySmall,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          'Change number',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              OtpFields(
                enabled: !auth.isLoading,
                onChanged: (v) => setState(() => _code = v),
                onCompleted: (v) {
                  setState(() => _code = v);
                  _verify();
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _canResend
                        ? 'Didn\'t receive the code?'
                        : 'Resend in 00:${_seconds.toString().padLeft(2, '0')}',
                    style: AppTextStyles.bodySmall,
                  ),
                  if (_canResend) ...[
                    const SizedBox(width: AppSpacing.sm),
                    GestureDetector(
                      onTap: auth.isLoading ? null : _resend,
                      child: Text(
                        'Resend',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Verify',
                isLoading: auth.isLoading,
                onPressed: _code.length == 6 && !auth.isLoading ? _verify : null,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
