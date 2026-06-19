import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';

/// A minimal quiz-score bar chart (no axes, grid or touch — the design is
/// bare). Bars use the ink text color at an opacity scaled by score; the most
/// recent bar is gold. An empty [scores] list renders a calm placeholder.
class AppScoreChart extends StatelessWidget {
  const AppScoreChart({super.key, required this.scores, this.height = 120});

  /// Quiz percentages (0–100), oldest first; the last is highlighted.
  final List<int> scores;
  final double height;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    if (scores.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'No quiz scores yet',
            style: AppText.b2.cl(AppTheme.c.subText),
          ),
        ),
      );
    }

    final lastIndex = scores.length - 1;

    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          minY: 0,
          maxY: 100,
          barTouchData: const BarTouchData(enabled: false),
          titlesData: const FlTitlesData(show: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: scores.asMap().entries.map((e) {
            final isLast = e.key == lastIndex;
            final value = e.value.clamp(0, 100).toDouble();
            final color = isLast
                ? AppTheme.c.accent
                : AppTheme.c.text.withValues(alpha: 0.25 + (value / 100) * 0.5);
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: value,
                  color: color,
                  width: 8,
                  borderRadius: 3.radius(),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
