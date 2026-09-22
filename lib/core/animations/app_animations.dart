import 'package:flutter/material.dart';
import 'app_curves.dart';
import 'app_durations.dart';

/// Fade-in wrapper — use everywhere instead of one-off controllers.
class FadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double beginOpacity;

  const FadeIn({
    super.key,
    required this.child,
    this.duration = AppDurations.medium,
    this.curve = AppCurves.entrance,
    this.beginOpacity = 0,
  });

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _opacity = Tween<double>(
      begin: widget.beginOpacity,
      end: 1,
    ).animate(CurvedAnimation(parent: _c, curve: widget.curve));
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacity, child: widget.child);
  }
}

/// Directional slide-in — for list entrances, page elements.
class SlideIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Offset beginOffset;

  const SlideIn({
    super.key,
    required this.child,
    this.duration = AppDurations.medium,
    this.curve = AppCurves.entrance,
    this.beginOffset = const Offset(0, 0.08),
  });

  const SlideIn.fromBottom({
    super.key,
    required this.child,
    this.duration = AppDurations.medium,
    this.curve = AppCurves.entrance,
  }) : beginOffset = const Offset(0, 0.12);

  const SlideIn.fromRight({
    super.key,
    required this.child,
    this.duration = AppDurations.medium,
    this.curve = AppCurves.entrance,
  }) : beginOffset = const Offset(0.12, 0);

  @override
  State<SlideIn> createState() => _SlideInState();
}

class _SlideInState extends State<SlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<Offset> _offset;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _offset = Tween<Offset>(begin: widget.beginOffset, end: Offset.zero)
        .animate(CurvedAnimation(parent: _c, curve: widget.curve));
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _c, curve: widget.curve),
    );
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}

/// Scale-on-tap — wrap every tappable card/button.
class ScaleOnTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;
  final double pressedScale;

  const ScaleOnTap({
    super.key,
    required this.child,
    this.onTap,
    this.duration = AppDurations.fastest,
    this.pressedScale = 0.97,
  });

  @override
  State<ScaleOnTap> createState() => _ScaleOnTapState();
}

class _ScaleOnTapState extends State<ScaleOnTap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _scale = Tween<double>(begin: 1, end: widget.pressedScale).animate(
      CurvedAnimation(parent: _c, curve: AppCurves.state),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.onTap == null) return;
    await _c.forward();
    await _c.reverse();
    widget.onTap!.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _c.forward(),
      onTapUp: (_) => _c.reverse(),
      onTapCancel: () => _c.reverse(),
      onTap: _handleTap,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

/// Staggered entrance — apply to API-loaded list items.
class StaggeredList extends StatelessWidget {
  final List<Widget> children;
  final Duration itemDelay;
  final Duration itemDuration;

  const StaggeredList({
    super.key,
    required this.children,
    this.itemDelay = AppDurations.fastest,
    this.itemDuration = AppDurations.slow,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < children.length; i++)
          _StaggeredItem(
            delay: itemDelay * i,
            duration: itemDuration,
            child: children[i],
          ),
      ],
    );
  }
}

class _StaggeredItem extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const _StaggeredItem({
    required this.child,
    required this.delay,
    required this.duration,
  });

  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<Offset> _offset;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _c, curve: AppCurves.entrance));
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _c, curve: AppCurves.entrance),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}

/// Skeleton-to-content cross-fade — max 600ms.
class SkeletonCrossFade extends StatelessWidget {
  final bool showContent;
  final Widget skeleton;
  final Widget content;
  final Duration duration;

  const SkeletonCrossFade({
    super.key,
    required this.showContent,
    required this.skeleton,
    required this.content,
    this.duration = AppDurations.slowest,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: skeleton,
      secondChild: content,
      crossFadeState:
          showContent ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: duration,
      firstCurve: AppCurves.exit,
      secondCurve: AppCurves.entrance,
    );
  }
}
