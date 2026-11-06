import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../providers/phone_launcher_provider.dart';

class OrderCallButton extends ConsumerWidget {
  final String? phone;
  final double size;
  final String semanticLabel;

  const OrderCallButton({
    super.key,
    required this.phone,
    this.size = 48,
    this.semanticLabel = 'Call',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final number = phone?.trim();
    if (number == null || number.isEmpty) return const SizedBox.shrink();

    return Semantics(
      button: true,
      label: semanticLabel,
      child: SizedBox(
        width: size,
        height: size,
        child: Material(
          color: AppColors.cardBackground,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () async {
              final opened = await ref.read(phoneLauncherProvider).call(number);
              if (!context.mounted || opened) return;
              AppSnackbar.showError(context, 'Could not open the phone app');
            },
            child: Center(
              child: Icon(
                Icons.call,
                size: size >= 48 ? AppIconSize.sm : AppIconSize.xs,
                color: AppColors.primaryText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
