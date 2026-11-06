import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../../core/animations/app_durations.dart';

class OtpCodeField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final bool enabled;

  const OtpCodeField({
    super.key,
    required this.onChanged,
    this.onCompleted,
    this.enabled = true,
  });

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _code = '';

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 6) {
      _controller.text = digits.substring(0, 6);
      _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
    } else {
      _controller.text = digits;
      _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
    }
    setState(() {
      _code = _controller.text;
    });
    widget.onChanged(_code);
    if (_code.length == 6) {
      widget.onCompleted?.call(_code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return Semantics(
      label: 'Verification code, ${_code.length} of 6 entered',
      child: GestureDetector(
        onTap: () {
          if (widget.enabled) _focusNode.requestFocus();
        },
        onLongPress: () async {
          final data = await Clipboard.getData(Clipboard.kTextPlain);
          if (data?.text != null) {
            _onChanged(data!.text!);
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 6,
                autofillHints: const [AutofillHints.oneTimeCode],
                onChanged: _onChanged,
                decoration: const InputDecoration(counterText: ''),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 328),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  final hasDigit = i < _code.length;
                  final isFocused = _focusNode.hasFocus && i == _code.length && _code.length < 6;
                  final borderColor = isFocused ? AppColors.primaryText : AppColors.cardBorder;
                  final borderWidth = isFocused ? 2.0 : 1.0;
                  return AnimatedContainer(
                    duration: disableAnimations ? Duration.zero : AppDurations.quick,
                    width: 48,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.rMd,
                      border: Border.all(color: borderColor, width: borderWidth),
                    ),
                    alignment: Alignment.center,
                    child: hasDigit
                        ? Text(_code[i], style: AppTextStyles.otpDigit)
                        : isFocused
                            ? const _BlinkingCursor()
                            : const SizedBox.shrink(),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppDurations.pulse)..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disableAnimations) {
      return Container(width: 2, height: 24, color: AppColors.primary);
    }
    return FadeTransition(
      opacity: _controller,
      child: Container(width: 2, height: 24, color: AppColors.primary),
    );
  }
}
