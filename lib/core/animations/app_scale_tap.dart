import 'package:flutter/material.dart';
import 'app_curves.dart';
import 'app_durations.dart';

class AppScaleTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration forwardDuration;
  final Duration reverseDuration;
  final Curve curve;
  final double pressedOpacity;

  const AppScaleTap({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.97,
    this.forwardDuration = AppDurations.instant,
    this.reverseDuration = AppDurations.fast,
    this.curve = AppCurves.state,
    this.pressedOpacity = 1.0,
  });

  @override
  State<AppScaleTap> createState() => _AppScaleTapState();
}

class _AppScaleTapState extends State<AppScaleTap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.forwardDuration,
      reverseDuration: widget.reverseDuration,
    );
    _scale = Tween<double>(begin: 1.0, end: widget.scale).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _down(TapDownDetails details) {
    if (!mounted || widget.onTap == null) return;
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return;
    _controller.forward();
  }

  void _up([_]) {
    if (!mounted) return;
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    Widget child = widget.child;
    if (!disableAnimations) {
      child = ScaleTransition(
        scale: _scale,
        child: AnimatedOpacity(
          duration: widget.reverseDuration,
          opacity: _controller.isAnimating || _controller.value > 0
              ? widget.pressedOpacity
              : 1.0,
          child: child,
        ),
      );
    }

    return Semantics(
      button: widget.onTap != null,
      enabled: widget.onTap != null,
      child: GestureDetector(
        onTapDown: widget.onTap == null ? null : _down,
        onTapUp: widget.onTap == null ? null : _up,
        onTapCancel: widget.onTap == null ? null : _up,
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          child: child,
        ),
      ),
    );
  }
}
