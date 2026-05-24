part of 'painters.dart';

class AppIconPainter extends CustomPainter {
  final Color? fg;
  final Color? bg;
  final double radius;

  const AppIconPainter({
    this.fg,
    this.bg,
    this.radius = 8.0,
  });

  const AppIconPainter.light() : this(fg: Colors.white, bg: AppColors.primary);
  const AppIconPainter.dark() : this(fg: Colors.white, bg: AppColors.primary);

  static Size size(double dimension) => Size(dimension, dimension);

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..style = PaintingStyle.fill;
    bgPaint.color = bg ?? AppColors.primary;

    if (radius > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
        bgPaint,
      );
    } else {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
    }

    final path = Path();
    path.moveTo(size.width * 0.3024180, size.height * 0.1960020);
    path.lineTo(size.width * 0.6776602, size.height * 0.1960020);
    path.cubicTo(
      size.width * 0.6830986,
      size.height * 0.1960020,
      size.width * 0.6883857,
      size.height * 0.1949443,
      size.width * 0.6935225,
      size.height * 0.1928301,
    );
    path.cubicTo(
      size.width * 0.6986582,
      size.height * 0.1904131,
      size.width * 0.7030391,
      size.height * 0.1881465,
      size.width * 0.7066650,
      size.height * 0.1860322,
    );
    path.cubicTo(
      size.width * 0.7105928,
      size.height * 0.1839170,
      size.width * 0.7133115,
      size.height * 0.1828594,
      size.width * 0.7148223,
      size.height * 0.1828594,
    );
    path.cubicTo(
      size.width * 0.7154268,
      size.height * 0.1828594,
      size.width * 0.7160303,
      size.height * 0.1833125,
      size.width * 0.7166348,
      size.height * 0.1842187,
    );
    path.cubicTo(
      size.width * 0.7172393,
      size.height * 0.1851250,
      size.width * 0.7179941,
      size.height * 0.1875420,
      size.width * 0.7189014,
      size.height * 0.1914697,
    );
    path.lineTo(size.width * 0.7474521, size.height * 0.3509932);
    path.cubicTo(
      size.width * 0.7480566,
      size.height * 0.3528066,
      size.width * 0.7482070,
      size.height * 0.3543164,
      size.width * 0.7479053,
      size.height * 0.3555254,
    );
    path.cubicTo(
      size.width * 0.7476035,
      size.height * 0.3567344,
      size.width * 0.7469990,
      size.height * 0.3573379,
      size.width * 0.7460928,
      size.height * 0.3573379,
    );
    path.cubicTo(
      size.width * 0.7451865,
      size.height * 0.3576406,
      size.width * 0.7442793,
      size.height * 0.3574893,
      size.width * 0.7433730,
      size.height * 0.3568848,
    );
    path.cubicTo(
      size.width * 0.7427695,
      size.height * 0.3562803,
      size.width * 0.7421650,
      size.height * 0.3552236,
      size.width * 0.7415605,
      size.height * 0.3537129,
    );
    path.cubicTo(
      size.width * 0.7252461,
      size.height * 0.3108105,
      size.width * 0.7101396,
      size.height * 0.2786338,
      size.width * 0.6962412,
      size.height * 0.2571826,
    );
    path.cubicTo(
      size.width * 0.6823438,
      size.height * 0.2354297,
      size.width * 0.6685967,
      size.height * 0.2210781,
      size.width * 0.6550010,
      size.height * 0.2141299,
    );
    path.cubicTo(
      size.width * 0.6414053,
      size.height * 0.2068789,
      size.width * 0.6273564,
      size.height * 0.2032529,
      size.width * 0.6128545,
      size.height * 0.2032529,
    );
    path.lineTo(size.width * 0.5394375, size.height * 0.2032529);
    path.lineTo(size.width * 0.5394375, size.height * 0.8069043);
    path.cubicTo(
      size.width * 0.5394375,
      size.height * 0.8105293,
      size.width * 0.5406455,
      size.height * 0.8132490,
      size.width * 0.5430625,
      size.height * 0.8150615,
    );
    path.cubicTo(
      size.width * 0.5457822,
      size.height * 0.8168740,
      size.width * 0.5498604,
      size.height * 0.8180830,
      size.width * 0.5552988,
      size.height * 0.8186875,
    );
    path.lineTo(size.width * 0.5974453, size.height * 0.8250322);
    path.cubicTo(
      size.width * 0.6004668,
      size.height * 0.8253340,
      size.width * 0.6019775,
      size.height * 0.8262402,
      size.width * 0.6019775,
      size.height * 0.8277510,
    );
    path.cubicTo(
      size.width * 0.6019775,
      size.height * 0.8295635,
      size.width * 0.6007686,
      size.height * 0.8304697,
      size.width * 0.5983516,
      size.height * 0.8304697,
    );
    path.lineTo(size.width * 0.3871650, size.height * 0.8304697);
    path.cubicTo(
      size.width * 0.3859561,
      size.height * 0.8304697,
      size.width * 0.3850498,
      size.height * 0.8301680,
      size.width * 0.3844453,
      size.height * 0.8295635,
    );
    path.cubicTo(
      size.width * 0.3838418,
      size.height * 0.8289590,
      size.width * 0.3835391,
      size.height * 0.8283555,
      size.width * 0.3835391,
      size.height * 0.8277510,
    );
    path.cubicTo(
      size.width * 0.3835391,
      size.height * 0.8262402,
      size.width * 0.3850498,
      size.height * 0.8253340,
      size.width * 0.3880713,
      size.height * 0.8250322,
    );
    path.lineTo(size.width * 0.4302178, size.height * 0.8186875);
    path.cubicTo(
      size.width * 0.4356563,
      size.height * 0.8180830,
      size.width * 0.4395840,
      size.height * 0.8168740,
      size.width * 0.4420010,
      size.height * 0.8150615,
    );
    path.cubicTo(
      size.width * 0.4447197,
      size.height * 0.8132490,
      size.width * 0.4460801,
      size.height * 0.8105293,
      size.width * 0.4460801,
      size.height * 0.8069043,
    );
    path.lineTo(size.width * 0.4460801, size.height * 0.2032529);
    path.lineTo(size.width * 0.3726631, size.height * 0.2032529);
    path.cubicTo(
      size.width * 0.3578584,
      size.height * 0.2032529,
      size.width * 0.3436582,
      size.height * 0.2073320,
      size.width * 0.3300625,
      size.height * 0.2154893,
    );
    path.cubicTo(
      size.width * 0.3167686,
      size.height * 0.2233447,
      size.width * 0.3031729,
      size.height * 0.2381484,
      size.width * 0.2892754,
      size.height * 0.2599023,
    );
    path.cubicTo(
      size.width * 0.2753779,
      size.height * 0.2813535,
      size.width * 0.2602715,
      size.height * 0.3126230,
      size.width * 0.2439561,
      size.height * 0.3537129,
    );
    path.cubicTo(
      size.width * 0.2436543,
      size.height * 0.3552236,
      size.width * 0.2430498,
      size.height * 0.3562803,
      size.width * 0.2421436,
      size.height * 0.3568848,
    );
    path.cubicTo(
      size.width * 0.2412373,
      size.height * 0.3574893,
      size.width * 0.2403311,
      size.height * 0.3576406,
      size.width * 0.2394248,
      size.height * 0.3573379,
    );
    path.cubicTo(
      size.width * 0.2385176,
      size.height * 0.3573379,
      size.width * 0.2379141,
      size.height * 0.3567344,
      size.width * 0.2376113,
      size.height * 0.3555254,
    );
    path.cubicTo(
      size.width * 0.2376113,
      size.height * 0.3543164,
      size.width * 0.2377627,
      size.height * 0.3528066,
      size.width * 0.2380645,
      size.height * 0.3509932,
    );
    path.lineTo(size.width * 0.2666162, size.height * 0.1914697);
    path.cubicTo(
      size.width * 0.2675225,
      size.height * 0.1875420,
      size.width * 0.2682773,
      size.height * 0.1851250,
      size.width * 0.2688818,
      size.height * 0.1842187,
    );
    path.cubicTo(
      size.width * 0.2694863,
      size.height * 0.1833125,
      size.width * 0.2700898,
      size.height * 0.1828594,
      size.width * 0.2706943,
      size.height * 0.1828594,
    );
    path.cubicTo(
      size.width * 0.2719033,
      size.height * 0.1828594,
      size.width * 0.2740176,
      size.height * 0.1839170,
      size.width * 0.2770391,
      size.height * 0.1860322,
    );
    path.cubicTo(
      size.width * 0.2800605,
      size.height * 0.1881465,
      size.width * 0.2836865,
      size.height * 0.1904131,
      size.width * 0.2879160,
      size.height * 0.1928301,
    );
    path.cubicTo(
      size.width * 0.2924473,
      size.height * 0.1949443,
      size.width * 0.2972822,
      size.height * 0.1960020,
      size.width * 0.3024180,
      size.height * 0.1960020,
    );
    path.close();

    final fgPaint = Paint()..style = PaintingStyle.fill;
    fgPaint.color = fg ?? Colors.white;
    canvas.drawPath(path, fgPaint);
  }

  @override
  bool shouldRepaint(covariant AppIconPainter old) =>
      old.fg != fg || old.bg != bg || old.radius != radius;
}
