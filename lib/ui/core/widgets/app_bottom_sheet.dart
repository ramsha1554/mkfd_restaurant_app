import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

Future<T?> showAppSheet<T>({
  required BuildContext context,
  String? title,
  required WidgetBuilder builder,
  bool showClose = false,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: AppColors.surface,
    barrierColor: AppColors.scrim,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;
      final paddingBottom = MediaQuery.of(context).padding.bottom;
      return Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              if (title != null || showClose) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      if (title != null)
                        Expanded(
                          child: Text(title!, style: AppTextStyles.h2),
                        )
                      else
                        const Spacer(),
                      if (showClose)
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                          splashRadius: 20,
                        ),
                    ],
                  ),
                ),
              ],
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24, 12, 24, 16 + paddingBottom),
                  child: builder(context),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

typedef AppBottomSheet = Widget;
