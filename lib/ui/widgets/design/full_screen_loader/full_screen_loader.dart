import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';

import '../misc/pluse_dot.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({
    super.key,
    this.loading = false,
    this.bg,
    this.title = 'Loading...',
    this.subtitle,
  });

  final bool loading;
  final Color? bg;
  final String title;
  final String? subtitle;

  static void modal(
    BuildContext context, {
    String title = 'Loading...',
    String? subtitle,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      builder: (_) => FullScreenLoader(
        loading: true,
        title: title,
        subtitle: subtitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    if (!loading) return const SizedBox.shrink();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        width: AppMedia.width,
        height: AppMedia.height,
        alignment: Alignment.center,
        color: (bg ?? AppTheme.c.background).withValues(alpha: 0.92),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _RingSpinner(),
            Space.y.t24,
            Text(title, style: AppText.h3, textAlign: TextAlign.center),
            if (subtitle != null) ...[
              Space.y.t12,
              Text(
                subtitle!,
                style: AppText.b2 + AppTheme.c.subText,
                textAlign: TextAlign.center,
              ),
            ],
            Space.y.t24,
            const _ProgressDots(),
          ],
        ),
      ),
    );
  }
}

// Thin ring track + spinning arc with a gold pulsing dot at centre.
class _RingSpinner extends StatelessWidget {
  const _RingSpinner();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            backgroundColor: AppTheme.c.border,
            color: AppTheme.c.text,
            strokeCap: StrokeCap.round,
          ),
        ),
        const AppPulsingDot(),
      ],
    );
  }
}

// Three dots with staggered pulse — subtle progress hint at the bottom.
class _ProgressDots extends StatefulWidget {
  const _ProgressDots();

  @override
  State<_ProgressDots> createState() => _ProgressDotsState();
}

class _ProgressDotsState extends State<_ProgressDots>
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
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.c.text,
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
