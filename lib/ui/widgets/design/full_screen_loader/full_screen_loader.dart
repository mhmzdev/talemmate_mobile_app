import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';

import '../misc/pluse_dot.dart';
import '../misc/progress_dots.dart';

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
            const AppProgressDots(),
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

