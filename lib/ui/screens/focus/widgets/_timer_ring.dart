part of '../focus.dart';

/// Determinate countdown ring — a background track plus a foreground arc that
/// sweeps from the top as the session elapses, with the remaining time and the
/// total length centered inside. Driven by the ephemeral [_ScreenState].
class _TimerRing extends StatelessWidget {
  const _TimerRing();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final ss = _ScreenState.s(context, true);

    return Center(
      child: SizedBox(
        width: 240,
        height: 240,
        child: CustomPaint(
          painter: _RingPainter(
            fraction: ss.fraction,
            track: AppTheme.c.border,
            arc: AppTheme.c.accent,
          ),
          child: Center(
            child: Column(
              mainAxisSize: .min,
              children: [
                Text(
                  ss.remainingLabel,
                  style: AppText.h1
                      .cl(AppTheme.c.text)
                      .gm()
                      .copyWith(fontSize: 44, fontWeight: FontWeight.w600),
                ),
                Space.y.t04,
                Text(
                  'remaining · ${ss.block.durationMinutes} min',
                  style: AppText.b2.cl(AppTheme.c.subText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.fraction,
    required this.track,
    required this.arc,
  });

  final double fraction;
  final Color track;
  final Color arc;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 10.0;
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - stroke) / 2;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = track;
    canvas.drawCircle(center, radius, trackPaint);

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = arc;
    final sweep = fraction.clamp(0.0, 1.0) * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction || old.track != track || old.arc != arc;
}
