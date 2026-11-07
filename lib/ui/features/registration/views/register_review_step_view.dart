import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_info_banner.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../providers/registration_provider.dart';
import '../widgets/address_map_preview.dart';
import '../widgets/registration_footer.dart';

class RegisterReviewStepView extends ConsumerStatefulWidget {
  const RegisterReviewStepView({super.key});

  @override
  ConsumerState<RegisterReviewStepView> createState() =>
      _RegisterReviewStepViewState();
}

class _RegisterReviewStepViewState
    extends ConsumerState<RegisterReviewStepView> {
  bool _acceptedTerms = false;

  String _formatAmount(double value) => '£${value.toStringAsFixed(2)}';

  Future<void> _submit() async {
    if (!_acceptedTerms) {
      AppSnackbar.showError(
        context,
        'Accept the terms and privacy policy to continue.',
      );
      return;
    }
    final message = await ref.read(registrationProvider.notifier).submit();
    if (!mounted || message == null) return;
    AppSnackbar.showError(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationProvider);
    final draft = state.draft;

    if (state.submitted) {
      return const _SubmittedView();
    }

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
                Text('Review your details', style: AppTextStyles.h1),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Check everything looks right for your Milton Keynes storefront before final submission.',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: AppSpacing.xl),
                _ReviewCard(
                  title: 'Restaurant',
                  icon: Icons.storefront_outlined,
                  onEdit: () =>
                      ref.read(registrationProvider.notifier).goToStep(1),
                  rows: [
                    _ReviewRow(label: 'Name', value: draft.name),
                    _ReviewRow(label: 'Phone', value: draft.displayPhone),
                    _ReviewRow(label: 'Email', value: draft.email),
                    _ReviewRow(
                      label: 'Cuisine',
                      value: draft.cuisines.join(', '),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _ReviewCard(
                  title: 'Location',
                  icon: Icons.location_on_outlined,
                  onEdit: () =>
                      ref.read(registrationProvider.notifier).goToStep(2),
                  rows: [
                    _ReviewRow(
                      label: 'Operating address',
                      value: [
                        draft.street,
                        draft.city,
                        draft.postcode,
                      ].where((part) => part.trim().isNotEmpty).join(', '),
                      stacked: true,
                    ),
                  ],
                  footer: ClipRRect(
                    borderRadius: AppRadius.rXs,
                    child: AddressMapPreview(
                      latitude: draft.latitude,
                      longitude: draft.longitude,
                      height: 120,
                      postcode: draft.postcode,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _ReviewCard(
                  title: 'Pricing and timing',
                  icon: Icons.schedule_outlined,
                  onEdit: () =>
                      ref.read(registrationProvider.notifier).goToStep(3),
                  rows: [
                    _ReviewRow(
                      label: 'Minimum order',
                      value: _formatAmount(draft.minimumOrder),
                    ),
                    _ReviewRow(
                      label: 'Preparation time',
                      value: '${draft.preparationTime} min',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const AppInfoBanner(
                  title: 'Next requirement',
                  message:
                      'Next step: upload your compliance documents. Your restaurant is reviewed once all required documents are in.',
                  tone: AppInfoBannerTone.info,
                  icon: Icons.info_outline,
                ),
                const SizedBox(height: AppSpacing.lg),
                _TermsRow(
                  value: _acceptedTerms,
                  onChanged: (value) =>
                      setState(() => _acceptedTerms = value),
                ),
              ],
            ),
          ),
        ),
        RegistrationFooter(
          label: 'Submit for approval',
          isLoading: state.isSubmitting,
          onPressed: _acceptedTerms && !state.isSubmitting ? _submit : null,
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onEdit;
  final List<_ReviewRow> rows;
  final Widget? footer;

  const _ReviewCard({
    required this.title,
    required this.icon,
    required this.onEdit,
    required this.rows,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppIconSize.sm, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(title, style: AppTextStyles.cardTitle),
              ),
              TextButton(
                onPressed: onEdit,
                child: Text(
                  'Edit',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.md),
          for (var index = 0; index < rows.length; index++) ...[
            rows[index],
            if (index < rows.length - 1)
              const SizedBox(height: AppSpacing.sm),
          ],
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.md),
            footer!,
          ],
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  final bool stacked;

  const _ReviewRow({
    required this.label,
    required this.value,
    this.stacked = false,
  });

  @override
  Widget build(BuildContext context) {
    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: AppTextStyles.body),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(label, style: AppTextStyles.bodySecondary),
        ),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _TermsRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _TermsRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: AppRadius.rXs,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: value,
                onChanged: (next) => onChanged(next ?? false),
                activeColor: AppColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text:
                      'I confirm these details are correct and agree to the ',
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
                style: AppTextStyles.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmittedView extends StatelessWidget {
  const _SubmittedView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPaddingAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: AppIconSize.xl,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Application submitted',
              textAlign: TextAlign.center,
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "We're reviewing your restaurant. You'll get access as soon as it's approved.",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ],
        ),
      ),
    );
  }
}
