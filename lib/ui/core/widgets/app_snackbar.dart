import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class AppSnackbar {
  static OverlayEntry? _entry;
  static Timer? _timer;

  static void show(
    BuildContext context,
    String message, {
    String? title,
    IconData? icon,
    Color? iconBg,
    Color? iconFg,
    Duration duration = const Duration(milliseconds: 3900),
  }) {
    final overlay = Overlay.of(context);
    _timer?.cancel();
    _entry?.remove();
    _entry = null;

    final meta = (title: title, icon: icon, iconBg: iconBg, iconFg: iconFg);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        return _Toast(
          message: message,
          title: meta.title,
          icon: meta.icon,
          iconBg: meta.iconBg,
          iconFg: meta.iconFg,
          duration: duration,
          onDismiss: () {
            _timer?.cancel();
            entry.remove();
            if (_entry == entry) _entry = null;
          },
        );
      },
    );
    _entry = entry;
    overlay.insert(entry);
    _timer = Timer(duration, () {
      _entry?.remove();
      if (_entry == entry) _entry = null;
      _entry = null;
    });
  }

  static void showSuccess(BuildContext context, String message, {String? title}) {
    show(
      context,
      message,
      title: title ?? 'Success',
      icon: Icons.check_circle,
      iconBg: AppColors.successBg,
      iconFg: AppColors.successText,
    );
  }

  static void showError(BuildContext context, String message, {String? title}) {
    show(
      context,
      message,
      title: title ?? 'Error',
      icon: Icons.error,
      iconBg: AppColors.errorBg,
      iconFg: AppColors.errorText,
    );
  }

  static void showInfo(BuildContext context, String message, {String? title}) {
    show(
      context,
      message,
      title: title ?? 'Info',
      icon: Icons.info,
      iconBg: AppColors.infoBg,
      iconFg: AppColors.infoText,
    );
  }

  static void showWarning(BuildContext context, String message, {String? title}) {
    show(
      context,
      message,
      title: title ?? 'Warning',
      icon: Icons.warning_amber,
      iconBg: AppColors.warningBg,
      iconFg: AppColors.warningText,
    );
  }
}

class _Toast extends StatefulWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final Color? iconBg;
  final Color? iconFg;
  final Duration duration;
  final VoidCallback onDismiss;

  const _Toast({
    required this.message,
    this.title,
    this.icon,
    this.iconBg,
    this.iconFg,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top + 12;
    final icon = widget.icon ?? Icons.info;
    final iconBg = widget.iconBg ?? AppColors.infoBg;
    final iconFg = widget.iconFg ?? AppColors.infoText;
    final title = widget.title ?? 'Info';

    return Positioned(
      top: top,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _offset,
          child: Dismissible(
            key: const ValueKey('app_toast'),
            direction: DismissDirection.up,
            onDismissed: (_) => widget.onDismiss(),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.rXxl,
                border: Border.all(color: AppColors.cardBorder, width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 20, color: iconFg),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(title, style: AppTextStyles.cardTitle),
                        const SizedBox(height: 2),
                        Text(
                          widget.message,
                          style: AppTextStyles.bodySecondary,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onDismiss,
                    icon: const Icon(Icons.close, size: 16, color: AppColors.textSecondary),
                    splashRadius: 16,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
