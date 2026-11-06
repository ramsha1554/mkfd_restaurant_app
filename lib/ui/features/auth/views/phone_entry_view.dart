import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/animations/app_animations.dart';
import '../../../../core/utils/navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../providers/auth_provider.dart';
import '../widgets/country_selector.dart';
import 'otp_view.dart';

enum AuthMode { login, signup }

class PhoneEntryView extends ConsumerStatefulWidget {
  final AuthMode initialMode;

  const PhoneEntryView({
    super.key,
    this.initialMode = AuthMode.signup,
  });

  @override
  ConsumerState<PhoneEntryView> createState() => _PhoneEntryViewState();
}

class _PhoneEntryViewState extends ConsumerState<PhoneEntryView> {
  late AuthMode _mode;
  CountryCode _country = kCountryCodes.firstWhere(
    (c) => c.name == 'United Kingdom',
    orElse: () => kCountryCodes.first,
  );
  final _phoneCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  String get _e164 {
    final raw = _phoneCtrl.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
    final stripped = _country.dialCode == '+44' && raw.startsWith('0')
        ? raw.substring(1)
        : raw;
    return '${_country.dialCode}$stripped';
  }

  bool _isValidPhone(String v) {
    final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length >= 7 && digits.length <= 15;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _e164;
    await ref.read(authProvider.notifier).requestOtp(phone: phone);

    if (!mounted) return;
    final state = ref.read(authProvider);
    if (state.errorMessage != null) {
      AppSnackbar.showError(context, state.errorMessage!);
      return;
    }

    Navigator.of(context).push(
      slideRightFadeRoute(OtpView(phone: phone)),
    );
  }

  void _toggleMode() {
    setState(() {
      _mode = _mode == AuthMode.signup ? AuthMode.login : AuthMode.signup;
    });
  }

  String get _heading =>
      _mode == AuthMode.signup ? 'Welcome to MK!' : 'Welcome back';

  String get _subHeading => _mode == AuthMode.signup
      ? 'Enter your mobile number to create your account'
      : 'Enter your phone number to sign in to your account';

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    ref.listen(authProvider, (prev, next) {
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        AppSnackbar.showError(context, next.errorMessage!);
      }
    });

    final safeBottom = MediaQuery.of(context).padding.bottom;

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
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppSpacing.screenPadding,
            right: AppSpacing.screenPadding,
            top: AppSpacing.screenPadding,
            bottom: AppSpacing.xxl + safeBottom,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SlideIn.fromBottom(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_heading, style: AppTextStyles.heading),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        _subHeading,
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                FadeIn(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Phone number *', style: AppTextStyles.bodySmall),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          CountrySelector(
                            selected: _country,
                            onSelected: (c) => setState(() => _country = c),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneCtrl,
                              keyboardType: TextInputType.phone,
                              style: AppTextStyles.bodyLarge,
                              decoration: const InputDecoration(
                                hintText: '7700 900000',
                                filled: true,
                                fillColor: AppColors.surface,
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Required';
                                }
                                if (!_isValidPhone(v)) {
                                  return 'Enter a valid phone number';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => _submit(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'We will send a 6-digit code. Standard rates apply.',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textHint),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                SizedBox(
                  height: 58,
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: auth.isLoading ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.surface,
                      disabledBackgroundColor:
                          AppColors.primary.withValues(alpha: 0.6),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.rSm,
                      ),
                      padding: AppSpacing.mdAll,
                      textStyle: AppTextStyles.bodyLarge
                          .copyWith(color: AppColors.surface),
                    ),
                    child: auth.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.surface,
                            ),
                          )
                        : Text(
                            'Continue',
                            style: AppTextStyles.bodyLarge
                                .copyWith(color: AppColors.surface),
                          ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _buildSwitchText(),
                const SizedBox(height: AppSpacing.xl),
                _buildTermsText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchText() {
    final isSignup = _mode == AuthMode.signup;
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTextStyles.bodySmall,
          children: [
            TextSpan(
              text: isSignup
                  ? 'Already have an account? '
                  : 'Don\'t have an account? ',
              style: AppTextStyles.bodySmall,
            ),
            TextSpan(
              text: isSignup ? 'Log in' : 'Create account',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
              recognizer: TapGestureRecognizer()..onTap = _toggleMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
          height: 1.4,
        ),
        children: [
          const TextSpan(text: 'By continuing, you agree to our '),
          TextSpan(
            text: 'Terms & Conditions',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
