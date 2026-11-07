import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final bool isRequired;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final bool readOnly;
  final bool locked;
  final bool hasError;
  final bool showValidCheck;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  const AppTextField({
    super.key,
    this.label,
    this.isRequired = false,
    this.hintText,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.readOnly = false,
    this.locked = false,
    this.hasError = false,
    this.showValidCheck = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveReadOnly = locked || readOnly;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            isRequired ? '$label *' : label!,
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          onTap: onTap,
          onEditingComplete: onEditingComplete,
          readOnly: effectiveReadOnly,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          style: locked
              ? AppTextStyles.body.copyWith(color: AppColors.textSecondary)
              : AppTextStyles.body,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            prefixIcon: _buildPrefix(),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            suffixIcon: _buildSuffix(),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            filled: true,
            fillColor:
                locked ? AppColors.cardBackground : AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: _border(
              hasError ? AppColors.error : _enabledBorderColor,
            ),
            enabledBorder: _border(
              hasError ? AppColors.error : _enabledBorderColor,
            ),
            focusedBorder: _border(
              hasError
                  ? AppColors.error
                  : (locked ? AppColors.cardBorder : AppColors.primary),
              width: 1.5,
            ),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error, width: 1.5),
          ),
        ),
      ],
    );
  }

  Color get _enabledBorderColor =>
      locked ? AppColors.cardBorder : AppColors.borderStrong;

  Widget? _buildPrefix() {
    if (prefix != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 12, right: 8),
        child: prefix,
      );
    }
    if (prefixIcon != null) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: IconTheme(
          data: const IconThemeData(size: 20, color: AppColors.textSecondary),
          child: prefixIcon!,
        ),
      );
    }
    return null;
  }

  Widget? _buildSuffix() {
    if (suffix != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 8, right: 12),
        child: suffix,
      );
    }
    if (suffixIcon != null) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: IconTheme(
          data: const IconThemeData(size: 20, color: AppColors.textSecondary),
          child: suffixIcon!,
        ),
      );
    }
    if (locked) {
      return const Padding(
        padding: EdgeInsets.only(left: 8, right: 12),
        child: Icon(
          Icons.lock_outline,
          size: 20,
          color: AppColors.textSecondary,
        ),
      );
    }
    if (showValidCheck) {
      return const Padding(
        padding: EdgeInsets.only(left: 8, right: 12),
        child: Icon(Icons.check_circle, size: 18, color: AppColors.primary),
      );
    }
    return null;
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: AppRadius.rMd,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
