import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_info_banner.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../providers/registration_provider.dart';
import '../utils/registration_validation.dart';
import '../widgets/registration_footer.dart';

class RegisterPricingStepView extends ConsumerStatefulWidget {
  const RegisterPricingStepView({super.key});

  @override
  ConsumerState<RegisterPricingStepView> createState() =>
      _RegisterPricingStepViewState();
}

class _RegisterPricingStepViewState
    extends ConsumerState<RegisterPricingStepView> {
  static const List<double> _quickAmounts = [0, 10, 15, 20];

  late final TextEditingController _minimumOrderController;
  bool _minimumOrderError = false;

  @override
  void initState() {
    super.initState();
    _minimumOrderController = TextEditingController(
      text: _formatAmount(ref.read(registrationProvider).draft.minimumOrder),
    );
  }

  @override
  void dispose() {
    _minimumOrderController.dispose();
    super.dispose();
  }

  String _formatAmount(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }

  void _sync(TextEditingController controller, double value) {
    final text = _formatAmount(value);
    if (controller.text == text) return;
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _setMinimumOrder(double value) {
    ref.read(registrationProvider.notifier).setMinimumOrder(value);
    if (_minimumOrderError) setState(() => _minimumOrderError = false);
  }

  void _continue() {
    final notifier = ref.read(registrationProvider.notifier);
    final parsed = double.tryParse(_minimumOrderController.text.trim());
    if (parsed == null || validateMinimumOrder(parsed) != null) {
      setState(() => _minimumOrderError = true);
      AppSnackbar.showError(context, 'Enter a valid minimum order amount.');
      return;
    }
    notifier.setMinimumOrder(parsed);

    final message = notifier.validateStepThree();
    if (message != null) {
      AppSnackbar.showError(context, message);
      return;
    }
    notifier.nextStep();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(registrationProvider, (previous, next) {
      if (previous?.draft.minimumOrder != next.draft.minimumOrder) {
        _sync(_minimumOrderController, next.draft.minimumOrder);
      }
    });

    final state = ref.watch(registrationProvider);
    final draft = state.draft;
    final preparation = draft.preparationTime.clamp(5, 120).toInt();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              0,
              AppSpacing.screenPadding,
              AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Set your order rules', style: AppTextStyles.h1),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'You can change these any time from your store settings.',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Minimum order', style: AppTextStyles.bodySecondary),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  hintText: '0',
                  controller: _minimumOrderController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.done,
                  hasError: _minimumOrderError,
                  prefix: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: AppRadius.rXs,
                    ),
                    child: Text(
                      '£',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d{0,3}(\.\d{0,2})?'),
                    ),
                  ],
                  onChanged: (value) {
                    final parsed = double.tryParse(value.trim());
                    if (parsed == null) return;
                    _setMinimumOrder(parsed);
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Orders below this amount cannot check out.',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final amount in _quickAmounts)
                      AppFilterChip(
                        label: amount == 0
                            ? 'No minimum'
                            : '£${_formatAmount(amount)}',
                        selected: draft.minimumOrder == amount,
                        onTap: () => _setMinimumOrder(amount),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text('Preparation time', style: AppTextStyles.bodySecondary),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: AppRadius.rSm,
                      ),
                      child: Text(
                        '$preparation min',
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Average time to prepare an order before pickup or delivery.',
                        style: AppTextStyles.caption,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.cardBorder,
                    thumbColor: AppColors.primary,
                    overlayColor: AppColors.primary.withValues(alpha: 0.12),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: preparation.toDouble(),
                    min: 5,
                    max: 120,
                    divisions: 23,
                    label: '$preparation min',
                    onChanged: (value) {
                      final stepped =
                          ((value / 5).round() * 5).clamp(5, 120).toInt();
                      ref
                          .read(registrationProvider.notifier)
                          .setPreparationTime(stepped);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('5 min', style: AppTextStyles.caption),
                      Text('120 min', style: AppTextStyles.caption),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                const AppInfoBanner(
                  title: 'Collection and delivery hours',
                  message:
                      'New restaurants start with Mon–Sat 09:00–22:00 and Sunday closed. You can update these after approval.',
                  tone: AppInfoBannerTone.info,
                  icon: Icons.schedule_outlined,
                  prominent: true,
                ),
              ],
            ),
          ),
        ),
        RegistrationFooter(label: 'Continue', onPressed: _continue),
      ],
    );
  }
}
