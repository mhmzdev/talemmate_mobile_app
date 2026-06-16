import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';

/// A small round subject-colour swatch used across the study-plan surfaces
/// (home today rows, plan timeline tiles). Falls back to a neutral tone when
/// the subject colour is unknown.
class SubjectSwatch extends StatelessWidget {
  const SubjectSwatch({super.key, required this.colorHex, this.size = 8});

  final String? colorHex;
  final double size;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorHex?.toColor() ?? AppTheme.c.subText,
      ),
    );
  }
}

/// Compact human label for a block length in minutes — "45m", "1h", "1h 30m".
String fmtBlockLength(int minutes) {
  if (minutes < 60) return '${minutes}m';
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m == 0 ? '${h}h' : '${h}h ${m}m';
}
