import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';

/// Three dots with a staggered pulse + float — a subtle "working" hint. Shared
/// by the full-screen loader and the tutor typing indicator.
class AppProgressDots extends StatefulWidget {
  const AppProgressDots({super.key, this.color, this.size = 5});

  /// Dot colour; defaults to [AppTheme.c.text].
  final Color? color;
  final double size;

  @override
  State<AppProgressDots> createState() => _AppProgressDotsState();
}

class _AppProgressDotsState extends State<AppProgressDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _ctrls;
  late List<Animation<double>> _opacities;
  late List<Animation<double>> _dys;

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(
      3,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200),
      ),
    );

    _opacities = _ctrls
        .map(
          (c) => TweenSequence([
            TweenSequenceItem(tween: Tween(begin: 0.25, end: 1.0), weight: 40),
            TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.25), weight: 60),
          ]).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut)),
        )
        .toList();

    _dys = _ctrls
        .map(
          (c) => TweenSequence([
            TweenSequenceItem(tween: Tween(begin: 0.0, end: -2.0), weight: 40),
            TweenSequenceItem(tween: Tween(begin: -2.0, end: 0.0), weight: 60),
          ]).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut)),
        )
        .toList();

    for (var i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 180), () {
        if (mounted) _ctrls[i].repeat();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppTheme.c.text;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (i) => AnimatedBuilder(
          animation: _ctrls[i],
          builder: (context, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Transform.translate(
              offset: Offset(0, _dys[i].value),
              child: Opacity(
                opacity: _opacities[i].value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
