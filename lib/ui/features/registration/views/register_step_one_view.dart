import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../providers/registration_provider.dart';
import '../utils/registration_validation.dart';
import '../widgets/registration_footer.dart';

class RegisterStepOneView extends ConsumerStatefulWidget {
  final VoidCallback onLogout;

  const RegisterStepOneView({super.key, required this.onLogout});

  @override
  ConsumerState<RegisterStepOneView> createState() =>
      _RegisterStepOneViewState();
}

class _RegisterStepOneViewState extends ConsumerState<RegisterStepOneView> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _descriptionController;
  final TextEditingController _cuisineController = TextEditingController();

  bool _nameError = false;
  bool _phoneError = false;
  bool _emailError = false;
  bool _cuisineError = false;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(registrationProvider).draft;
    _nameController = TextEditingController(text: draft.name);
    _phoneController = TextEditingController(text: draft.phone);
    _emailController = TextEditingController(text: draft.email);
    _descriptionController = TextEditingController(text: draft.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _cuisineController.dispose();
    super.dispose();
  }

  void _addCuisine() {
    final value = _cuisineController.text.trim();
    if (value.isEmpty) return;
    ref.read(registrationProvider.notifier).addCuisine(value);
    _cuisineController.clear();
    if (_cuisineError) setState(() => _cuisineError = false);
  }

  void _continue() {
    final notifier = ref.read(registrationProvider.notifier);
    final draft = ref.read(registrationProvider).draft;

    final nameError = validateRestaurantName(draft.name);
    final phoneError = validatePhone(draft.phone);
    final emailError = validateEmail(draft.email);
    final cuisineError = validateCuisines(draft.cuisines);

    setState(() {
      _nameError = nameError != null;
      _phoneError = phoneError != null;
      _emailError = emailError != null;
      _cuisineError = cuisineError != null;
    });

    final message = notifier.validateStepOne();
    if (message != null) {
      AppSnackbar.showError(context, message);
      return;
    }
    notifier.nextStep();
  }

  Future<void> _confirmLogout() async {
    final leave = await showAppConfirmDialog(
      context: context,
      title: 'Log out?',
      message:
          'You can finish setting up your restaurant after signing in again.',
      confirmLabel: 'Log out',
      cancelLabel: 'Keep editing',
      isDestructive: true,
      icon: Icons.logout_outlined,
    );
    if (leave == true) widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationProvider);
    final draft = state.draft;
    final suggestions = kSuggestedCuisines
        .where(
          (suggestion) => !draft.cuisines.any(
            (cuisine) =>
                cuisine.toLowerCase() == suggestion.toLowerCase(),
          ),
        )
        .take(8)
        .toList();

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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tell us about your restaurant',
                            style: AppTextStyles.h1,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'This is what customers will see on your storefront.',
                            style: AppTextStyles.bodySecondary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: AppRadius.rSm,
                      ),
                      child: const Icon(
                        Icons.storefront_outlined,
                        size: AppIconSize.md,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  label: 'Restaurant name',
                  isRequired: true,
                  hintText: 'e.g. Milton Feast Bar',
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  hasError: _nameError,
                  showValidCheck: validateRestaurantName(draft.name) == null,
                  onChanged: (value) {
                    ref.read(registrationProvider.notifier).setName(value);
                    if (_nameError) setState(() => _nameError = false);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Phone',
                  isRequired: true,
                  hintText: '07123 456789',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  hasError: _phoneError,
                  showValidCheck: isValidUkPhone(draft.phone),
                  prefix: _UkPhonePrefix(),
                  onChanged: (value) {
                    ref.read(registrationProvider.notifier).setPhone(value);
                    if (_phoneError) setState(() => _phoneError = false);
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const AppIcon.xs(
                      Icons.info_outline,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        'Customers and drivers may call this number.',
                        style: AppTextStyles.caption,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Email',
                  isRequired: true,
                  hintText: 'store@example.co.uk',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  hasError: _emailError,
                  showValidCheck: validateEmail(draft.email) == null,
                  onChanged: (value) {
                    ref.read(registrationProvider.notifier).setEmail(value);
                    if (_emailError) setState(() => _emailError = false);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Text('Cuisine types', style: AppTextStyles.bodySecondary),
                    const Spacer(),
                    Text(
                      '${draft.cuisines.length} selected',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (draft.cuisines.isNotEmpty) ...[
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final cuisine in draft.cuisines)
                        AppFilterChip(
                          label: cuisine,
                          selected: true,
                          trailingIcon: Icons.close,
                          onTrailingTap: () => ref
                              .read(registrationProvider.notifier)
                              .removeCuisine(cuisine),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                AppTextField(
                  hintText: 'Add a cuisine',
                  controller: _cuisineController,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                  hasError: _cuisineError,
                  onSubmitted: (_) => _addCuisine(),
                  suffix: IconButton(
                    onPressed: _addCuisine,
                    tooltip: 'Add cuisine tag',
                    icon: const Icon(Icons.add),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ),
                if (suggestions.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Suggestions',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final suggestion in suggestions)
                        AppFilterChip(
                          label: suggestion,
                          selected: false,
                          onTap: () {
                            ref
                                .read(registrationProvider.notifier)
                                .addCuisine(suggestion);
                          },
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Description',
                  hintText: 'Tell customers about your food',
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 4,
                  maxLines: 4,
                  inputFormatters: [LengthLimitingTextInputFormatter(200)],
                  onChanged: (value) => ref
                      .read(registrationProvider.notifier)
                      .setDescription(value),
                ),
              ],
            ),
          ),
        ),
        RegistrationFooter(
          label: 'Continue',
          onPressed: _continue,
          extra: TextButton(
            onPressed: _confirmLogout,
            child: Text(
              'Log out',
              style: AppTextStyles.button.copyWith(
                color: AppColors.primaryText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UkPhonePrefix extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.rXs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🇬🇧'),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '+44',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
