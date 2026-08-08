import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/graph_question.dart';
import '../../shared/theme/app_theme.dart';

class SimpleGraphCard extends StatelessWidget {
  const SimpleGraphCard({required this.graph, super.key});

  final GraphQuestion graph;

  @override
  Widget build(BuildContext context) {
    final svgAsset = graph.svgAsset;
    final colors = context.appColors;
    return Semantics(
      label: 'Graph with ${graph.points.length} plotted points',
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.divider),
        ),
        child: Column(
          children: [
            if (svgAsset != null) ...[
              SvgPicture.asset(svgAsset, height: 56),
              const SizedBox(height: 8),
            ],
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (final point in graph.points)
                          FlSpot(point.x, point.y),
                      ],
                      color: colors.accent,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
            if (graph.latexCaption case final caption?) ...[
              const SizedBox(height: 8),
              Math.tex(
                caption,
                textStyle: TextStyle(color: colors.primaryText, fontSize: 15),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
