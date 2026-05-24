import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';

/// Gold dot that pulses opacity and floats up/down. Use standalone anywhere
/// a live/heartbeat indicator is needed (e.g. AI typing, syncing).
class AppPulsingDot extends StatefulWidget {
  const AppPulsingDot({super.key, this.size = 6, this.color});

  final double size;

  /// Defaults to [AppTheme.c.accent] (gold).
  final Color? color;

  @override
  State<AppPulsingDot> createState() => _AppPulsingDotState();
}

class _AppPulsingDotState extends State<AppPulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<double> _dy;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _opacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.25, end: 1.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.25), weight: 60),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

    _dy = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -3.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: -3.0, end: 0.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) => Transform.translate(
        offset: Offset(0, _dy.value),
        child: Opacity(
          opacity: _opacity.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color ?? AppTheme.c.accent,
            ),
          ),
        ),
      ),
    );
  }
}
