import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../auth/widgets/otp_code_field.dart';

Future<bool?> showVerifyPickupSheet({
  required BuildContext context,
  required Future<String?> Function(String code) onVerify,
}) {
  return showAppSheet<bool>(
    context: context,
    title: 'Verify pickup code',
    builder: (_) => _PickupSheet(onVerify: onVerify),
  );
}

class _PickupSheet extends StatefulWidget {
  final Future<String?> Function(String code) onVerify;

  const _PickupSheet({required this.onVerify});

  @override
  State<_PickupSheet> createState() => _PickupSheetState();
}

class _PickupSheetState extends State<_PickupSheet> {
  String _code = '';
  bool _isSubmitting = false;
  Key _fieldKey = UniqueKey();

  Future<void> _submit() async {
    if (_code.length != 4 || _isSubmitting) return;
    setState(() => _isSubmitting = true);

    final error = await widget.onVerify(_code);
    if (!mounted) return;

    if (error == null) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() {
      _isSubmitting = false;
      _code = '';
      _fieldKey = UniqueKey();
    });
    AppSnackbar.showError(context, error);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Ask the driver for the 4-digit code.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: OtpCodeField(
            key: _fieldKey,
            length: 4,
            enabled: !_isSubmitting,
            onChanged: (value) => setState(() => _code = value),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppPrimaryButton(
          label: 'Verify pickup',
          isLoading: _isSubmitting,
          onPressed: _code.length == 4 && !_isSubmitting ? _submit : null,
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
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
