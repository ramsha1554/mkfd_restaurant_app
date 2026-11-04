import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';
import 'primary_button.dart';

class AppLoading extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;

  const AppLoading({
    super.key,
    this.size = 24,
    this.strokeWidth = 2,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color,
      ),
    );
  }
}

class AppSkeleton extends StatefulWidget {
  final Widget child;
  const AppSkeleton({super.key, required this.child});

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disable = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disable) {
      return widget.child;
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final shift = _controller.value * 2 - 1;
            return LinearGradient(
              begin: Alignment(shift - 1, 0),
              end: Alignment(shift, 0),
              colors: const [
                AppColors.cardBorder,
                AppColors.surface,
                AppColors.cardBorder,
              ],
              stops: const [0.35, 0.5, 0.65],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double height;
  final double? width;
  final BorderRadius? borderRadius;

  const SkeletonBox({
    super.key,
    required this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.cardBorder,
          borderRadius: borderRadius ?? AppRadius.rSm,
        ),
      ),
    );
  }
}

class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.cardBorder,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class SkeletonText extends StatelessWidget {
  final double height;
  final double? width;

  const SkeletonText({
    super.key,
    this.height = 12,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(height: height, width: width);
  }
}

class SkeletonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const SkeletonCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.rLg,
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: child,
    );
  }
}

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              style: AppTextStyles.bodySecondary,
              textAlign: TextAlign.center,
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: AppPrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AppErrorState extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.description,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.h2, textAlign: TextAlign.center),
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(
              description!,
              style: AppTextStyles.bodySecondary,
              textAlign: TextAlign.center,
            ),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            AppPrimaryButton(
              label: 'Retry',
              onPressed: onRetry,
            ),
          ],
        ],
      ),
    );
  }
}

class AppIconBubble extends StatelessWidget {
  final IconData icon;
  final Color? bg;
  final Color? fg;
  final double size;

  const AppIconBubble({
    super.key,
    required this.icon,
    this.bg,
    this.fg,
    this.size = 64,
  });

  const AppIconBubble.row({
    super.key,
    required this.icon,
    this.bg,
    this.fg,
  }) : size = 44;

  @override
  Widget build(BuildContext context) {
    final iconSize = size == 44 ? 20.0 : 32.0;
    final meta = bg == null || fg == null ? AppColors.statusMeta('ready') : null;
    final effectiveBg = bg ?? meta?.bg ?? AppColors.surface;
    final effectiveFg = fg ?? meta?.fg ?? AppColors.primaryText;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: effectiveBg,
        shape: BoxShape.circle,
        border: Border.all(color: effectiveFg, width: 1),
      ),
      child: Icon(icon, size: iconSize, color: effectiveFg),
    );
  }
}
