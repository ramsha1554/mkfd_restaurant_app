import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// 6-digit OTP input — six boxes, auto-focus, paste support.
class OtpFields extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const OtpFields({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<OtpFields> createState() => _OtpFieldsState();
}

class _OtpFieldsState extends State<OtpFields> {
  final List<TextEditingController> _ctrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  String get _code => _ctrls.map((c) => c.text).join();

  void _onChanged(String v, int i) {
    if (!widget.enabled) return;
    if (v.length == 1 && i < 5) {
      _nodes[i + 1].requestFocus();
    } else if (v.isEmpty && i > 0) {
      _nodes[i - 1].requestFocus();
    }
    widget.onChanged?.call(_code);
    if (_code.length == 6 && !_code.contains(RegExp(r'[^0-9]'))) {
      widget.onCompleted(_code);
    }
  }

  void _onPaste(String pasted) {
    final digits = pasted.replaceAll(RegExp(r'[^0-9]'), '').split('');
    for (var i = 0; i < 6 && i < digits.length; i++) {
      _ctrls[i].text = digits[i];
    }
    if (digits.length == 6) widget.onCompleted(_code);
    setState(() {});
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (i) {
        return SizedBox(
          width: 48,
          child: TextField(
            controller: _ctrls[i],
            focusNode: _nodes[i],
            enabled: widget.enabled,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: AppTextStyles.title,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: AppSpacing.mdAll,
              border: const OutlineInputBorder(
                borderRadius: AppRadius.rSm,
                borderSide: BorderSide(color: AppColors.cardBorder),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: AppRadius.rSm,
                borderSide: BorderSide(color: AppColors.cardBorder),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: AppRadius.rSm,
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
            onChanged: (v) {
              if (v.length > 1) {
                _onPaste(v);
                return;
              }
              _onChanged(v, i);
            },
          ),
        );
      }),
    );
  }
}
