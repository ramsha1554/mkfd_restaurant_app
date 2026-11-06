import 'package:flutter/material.dart';

import '../../../core/animations/app_curves.dart';
import '../../../core/animations/app_durations.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AppLiveBadge extends StatefulWidget {
  final bool isLive;

  const AppLiveBadge({super.key, this.isLive = true});

  @override
  State<AppLiveBadge> createState() => _AppLiveBadgeState();
}

class _AppLiveBadgeState extends State<AppLiveBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.pulse,
    );
    _opacity = Tween<double>(begin: 0.35, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: AppCurves.state),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduce != _reduceMotion) {
      _reduceMotion = reduce;
      if (reduce) {
        _controller.stop();
        _controller.value = 1;
      }
    }
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant AppLiveBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  void _syncAnimation() {
    if (widget.isLive && !_reduceMotion) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else {
      if (_controller.isAnimating) _controller.stop();
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final live = widget.isLive;
    final background = live ? AppColors.successBg : AppColors.cardBackground;
    final foreground = live ? AppColors.successText : AppColors.textHint;
    final border = live
        ? AppColors.successText.withValues(alpha: 0.2)
        : AppColors.cardBorder;

    final dot = Container(
      width: AppSpacing.sm,
      height: AppSpacing.sm,
      decoration: BoxDecoration(
        color: live ? AppColors.success : AppColors.textHint,
        shape: BoxShape.circle,
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.rPill,
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (live && !_reduceMotion)
            FadeTransition(opacity: _opacity, child: dot)
          else
            dot,
          const SizedBox(width: AppSpacing.xs),
          Text(
            live ? 'Live' : 'Offline',
            style: AppTextStyles.caption.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
