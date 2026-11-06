import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';

class RejectOrderSheet extends StatefulWidget {
  final Future<String?> Function(String reason) onReject;

  const RejectOrderSheet({super.key, required this.onReject});

  @override
  State<RejectOrderSheet> createState() => _RejectOrderSheetState();
}

class _RejectOrderSheetState extends State<RejectOrderSheet> {
  static const _reasons = [
    'Too busy',
    'Item unavailable',
    'Closing soon',
    'Other',
  ];

  final _details = TextEditingController();
  String? _reason;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final reason = _reason;
    if (reason == null || _isSubmitting) return;

    final details = _details.text.trim();
    final payload = details.isEmpty ? reason : '$reason: $details';

    setState(() => _isSubmitting = true);
    final error = await widget.onReject(payload);
    if (!mounted) return;

    if (error == null) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() => _isSubmitting = false);
    AppSnackbar.showError(context, error);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Choose a reason. The customer will be notified immediately.',
          style: AppTextStyles.bodySecondary,
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final reason in _reasons)
              AppFilterChip(
                label: reason,
                selected: _reason == reason,
                onTap: () => setState(() => _reason = reason),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Add details (optional)', style: AppTextStyles.bodySecondary),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: _details,
          hintText: 'e.g., Kitchen at capacity or out of ingredients',
          maxLines: 3,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppPrimaryButton(
          label: 'Reject order',
          icon: Icons.do_not_disturb_on_outlined,
          destructive: true,
          isLoading: _isSubmitting,
          onPressed: _reason == null || _isSubmitting ? null : _submit,
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryText,
            textStyle: AppTextStyles.button,
          ),
          child: const Text('Keep order & return'),
        ),
      ],
    );
  }
}
