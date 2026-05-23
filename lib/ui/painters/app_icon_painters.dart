part of 'painters.dart';

class AppIconPainters extends CustomPainter {
  static Size s(double value) => Size(value, value);

  final Color? fg;
  final Color? bg;
  final double radius;

  const AppIconPainters({
    this.fg,
    this.bg,
    this.radius = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = bg ?? const Color(0xff0E2128).withValues(alpha: 1.0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ),
      paint0Fill,
    );

    final path_1 = Path();
    path_1.moveTo(size.width * 0.2707656, size.height * 0.1444131);
    path_1.lineTo(size.width * 0.7084326, size.height * 0.1444131);
    path_1.cubicTo(
      size.width * 0.7147754,
      size.height * 0.1444131,
      size.width * 0.7209424,
      size.height * 0.1431797,
      size.width * 0.7269336,
      size.height * 0.1407129,
    );
    path_1.cubicTo(
      size.width * 0.7329238,
      size.height * 0.1378936,
      size.width * 0.7380332,
      size.height * 0.1352510,
      size.width * 0.7422617,
      size.height * 0.1327842,
    );
    path_1.cubicTo(
      size.width * 0.7468428,
      size.height * 0.1303174,
      size.width * 0.7500146,
      size.height * 0.1290840,
      size.width * 0.7517764,
      size.height * 0.1290840,
    );
    path_1.cubicTo(
      size.width * 0.7524814,
      size.height * 0.1290840,
      size.width * 0.7531865,
      size.height * 0.1296133,
      size.width * 0.7538906,
      size.height * 0.1306699,
    );
    path_1.cubicTo(
      size.width * 0.7545957,
      size.height * 0.1317275,
      size.width * 0.7554766,
      size.height * 0.1345459,
      size.width * 0.7565342,
      size.height * 0.1391270,
    );
    path_1.lineTo(size.width * 0.7898350, size.height * 0.3251885);
    path_1.cubicTo(
      size.width * 0.7905391,
      size.height * 0.3273037,
      size.width * 0.7907158,
      size.height * 0.3290654,
      size.width * 0.7903633,
      size.height * 0.3304746,
    );
    path_1.cubicTo(
      size.width * 0.7900107,
      size.height * 0.3318848,
      size.width * 0.7893066,
      size.height * 0.3325889,
      size.width * 0.7882490,
      size.height * 0.3325889,
    );
    path_1.cubicTo(
      size.width * 0.7871914,
      size.height * 0.3329414,
      size.width * 0.7861348,
      size.height * 0.3327656,
      size.width * 0.7850771,
      size.height * 0.3320605,
    );
    path_1.cubicTo(
      size.width * 0.7843730,
      size.height * 0.3313555,
      size.width * 0.7836680,
      size.height * 0.3301221,
      size.width * 0.7829629,
      size.height * 0.3283604,
    );
    path_1.cubicTo(
      size.width * 0.7639346,
      size.height * 0.2783213,
      size.width * 0.7463145,
      size.height * 0.2407920,
      size.width * 0.7301045,
      size.height * 0.2157725,
    );
    path_1.cubicTo(
      size.width * 0.7138945,
      size.height * 0.1904004,
      size.width * 0.6978613,
      size.height * 0.1736611,
      size.width * 0.6820039,
      size.height * 0.1655566,
    );
    path_1.cubicTo(
      size.width * 0.6661465,
      size.height * 0.1570996,
      size.width * 0.6497598,
      size.height * 0.1528701,
      size.width * 0.6328457,
      size.height * 0.1528701,
    );
    path_1.lineTo(size.width * 0.5472148, size.height * 0.1528701);
    path_1.lineTo(size.width * 0.5472148, size.height * 0.8569443);
    path_1.cubicTo(
      size.width * 0.5472148,
      size.height * 0.8611729,
      size.width * 0.5486240,
      size.height * 0.8643447,
      size.width * 0.5514434,
      size.height * 0.8664590,
    );
    path_1.cubicTo(
      size.width * 0.5546152,
      size.height * 0.8685732,
      size.width * 0.5593721,
      size.height * 0.8699834,
      size.width * 0.5657148,
      size.height * 0.8706875,
    );
    path_1.lineTo(size.width * 0.6148730, size.height * 0.8780879);
    path_1.cubicTo(
      size.width * 0.6183975,
      size.height * 0.8784404,
      size.width * 0.6201592,
      size.height * 0.8794971,
      size.width * 0.6201592,
      size.height * 0.8812598,
    );
    path_1.cubicTo(
      size.width * 0.6201592,
      size.height * 0.8833740,
      size.width * 0.6187500,
      size.height * 0.8844307,
      size.width * 0.6159307,
      size.height * 0.8844307,
    );
    path_1.lineTo(size.width * 0.3696104, size.height * 0.8844307);
    path_1.cubicTo(
      size.width * 0.3682012,
      size.height * 0.8844307,
      size.width * 0.3671436,
      size.height * 0.8840781,
      size.width * 0.3664385,
      size.height * 0.8833740,
    );
    path_1.cubicTo(
      size.width * 0.3657344,
      size.height * 0.8826689,
      size.width * 0.3653818,
      size.height * 0.8819639,
      size.width * 0.3653818,
      size.height * 0.8812598,
    );
    path_1.cubicTo(
      size.width * 0.3653818,
      size.height * 0.8794971,
      size.width * 0.3671436,
      size.height * 0.8784404,
      size.width * 0.3706680,
      size.height * 0.8780879,
    );
    path_1.lineTo(size.width * 0.4198262, size.height * 0.8706875);
    path_1.cubicTo(
      size.width * 0.4261689,
      size.height * 0.8699834,
      size.width * 0.4307500,
      size.height * 0.8685732,
      size.width * 0.4335693,
      size.height * 0.8664590,
    );
    path_1.cubicTo(
      size.width * 0.4367402,
      size.height * 0.8643447,
      size.width * 0.4383262,
      size.height * 0.8611729,
      size.width * 0.4383262,
      size.height * 0.8569443,
    );
    path_1.lineTo(size.width * 0.4383262, size.height * 0.1528701);
    path_1.lineTo(size.width * 0.3526953, size.height * 0.1528701);
    path_1.cubicTo(
      size.width * 0.3354287,
      size.height * 0.1528701,
      size.width * 0.3188662,
      size.height * 0.1576279,
      size.width * 0.3030088,
      size.height * 0.1671426,
    );
    path_1.cubicTo(
      size.width * 0.2875039,
      size.height * 0.1763047,
      size.width * 0.2716465,
      size.height * 0.1935713,
      size.width * 0.2554365,
      size.height * 0.2189434,
    );
    path_1.cubicTo(
      size.width * 0.2392266,
      size.height * 0.2439629,
      size.width * 0.2216064,
      size.height * 0.2804355,
      size.width * 0.2025781,
      size.height * 0.3283604,
    );
    path_1.cubicTo(
      size.width * 0.2022256,
      size.height * 0.3301221,
      size.width * 0.2015205,
      size.height * 0.3313555,
      size.width * 0.2004639,
      size.height * 0.3320605,
    );
    path_1.cubicTo(
      size.width * 0.1994063,
      size.height * 0.3327656,
      size.width * 0.1983496,
      size.height * 0.3329414,
      size.width * 0.1972920,
      size.height * 0.3325889,
    );
    path_1.cubicTo(
      size.width * 0.1962344,
      size.height * 0.3325889,
      size.width * 0.1955303,
      size.height * 0.3318848,
      size.width * 0.1951777,
      size.height * 0.3304746,
    );
    path_1.cubicTo(
      size.width * 0.1951777,
      size.height * 0.3290654,
      size.width * 0.1953535,
      size.height * 0.3273037,
      size.width * 0.1957061,
      size.height * 0.3251885,
    );
    path_1.lineTo(size.width * 0.2290068, size.height * 0.1391270);
    path_1.cubicTo(
      size.width * 0.2300645,
      size.height * 0.1345459,
      size.width * 0.2309453,
      size.height * 0.1317275,
      size.width * 0.2316504,
      size.height * 0.1306699,
    );
    path_1.cubicTo(
      size.width * 0.2323545,
      size.height * 0.1296133,
      size.width * 0.2330596,
      size.height * 0.1290840,
      size.width * 0.2337646,
      size.height * 0.1290840,
    );
    path_1.cubicTo(
      size.width * 0.2351738,
      size.height * 0.1290840,
      size.width * 0.2376406,
      size.height * 0.1303174,
      size.width * 0.2411641,
      size.height * 0.1327842,
    );
    path_1.cubicTo(
      size.width * 0.2446885,
      size.height * 0.1352510,
      size.width * 0.2489170,
      size.height * 0.1378936,
      size.width * 0.2538506,
      size.height * 0.1407129,
    );
    path_1.cubicTo(
      size.width * 0.2591367,
      size.height * 0.1431797,
      size.width * 0.2647744,
      size.height * 0.1444131,
      size.width * 0.2707656,
      size.height * 0.1444131,
    );
    path_1.close();

    final paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = fg ?? Colors.white.withValues(alpha: 1.0);
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
