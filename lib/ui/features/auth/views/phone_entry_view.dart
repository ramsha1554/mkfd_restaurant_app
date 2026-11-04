import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/animations/app_animations.dart';
import '../../../../core/utils/navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';
import '../widgets/country_selector.dart';
import 'otp_view.dart';

class PhoneEntryView extends ConsumerStatefulWidget {
  const PhoneEntryView({super.key});

  @override
  ConsumerState<PhoneEntryView> createState() => _PhoneEntryViewState();
}

class _PhoneEntryViewState extends ConsumerState<PhoneEntryView> {
  CountryCode _country = kCountryCodes.firstWhere(
    (c) => c.name == 'United Kingdom',
    orElse: () => kCountryCodes.first,
  );
  final _phoneCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    final digits = _phoneCtrl.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      AppSnackbar.showError(context, 'Please enter your phone number');
      return;
    }
    if (!_isValidPhone(digits)) {
      AppSnackbar.showError(context, 'Please enter a valid mobile number');
      return;
    }
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

  void _openCountryPicker() {
    showAppSheet(
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: CountrySelector(
          selected: _country,
          onSelected: (c) {
            setState(() => _country = c);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    ref.listen(authProvider, (prev, next) {
      if (next.errorMessage != null && next.errorMessage != prev?.errorMessage) {
        AppSnackbar.showError(context, next.errorMessage!);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.cardBorder, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/MK-Tour-Logo.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AppSlideIn(
                      direction: AxisDirection.up,
                      delay: const Duration(milliseconds: 200),
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.h1,
                          children: [
                            const TextSpan(text: 'Your restaurant,\n'),
                            TextSpan(
                              text: 'right in your pocket',
                              style: AppTextStyles.h1.copyWith(color: AppColors.primaryText),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Log in or sign up to manage your orders',
                      style: AppTextStyles.bodySecondary,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      height: 340,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: AppRadius.rLg,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/images/rm.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: AppColors.primaryLight),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Welcome back!', style: AppTextStyles.h1),
                        const SizedBox(height: 4),
                        Text(
                          'Enter your mobile number to log in',
                          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: AppRadius.rMd,
                            border: Border.all(color: AppColors.borderStrong, width: 1),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: _openCountryPicker,
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    children: [
                                      Text(_country.flag, style: const TextStyle(fontSize: 20)),
                                      const SizedBox(width: 6),
                                      Text(
                                        _country.dialCode,
                                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.textSecondary),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 28,
                                color: AppColors.cardBorder,
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.phone_outlined, size: 20, color: AppColors.textSecondary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneCtrl,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.done,
                                  style: AppTextStyles.body,
                                  decoration: InputDecoration(
                                    hintText: 'Mobile number',
                                    hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                    filled: false,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onFieldSubmitted: (_) => _submit(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppPrimaryButton(
                          label: 'Continue',
                          trailingIcon: true,
                          icon: Icons.arrow_forward,
                          isLoading: auth.isLoading,
                          onPressed: auth.isLoading ? null : _submit,
                        ),
                        const SizedBox(height: 16),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppTextStyles.bodySecondary,
                            children: [
                              const TextSpan(text: 'By continuing, you agree to our '),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: AppTextStyles.bodySecondary.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {},
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: AppTextStyles.bodySecondary.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {},
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
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
