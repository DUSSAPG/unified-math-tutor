import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/graph_question.dart';

class SimpleGraphCard extends StatelessWidget {
  const SimpleGraphCard({required this.graph, super.key});

  final GraphQuestion graph;

  @override
  Widget build(BuildContext context) {
    final svgAsset = graph.svgAsset;
    return Semantics(
      label: 'Graph with ${graph.points.length} plotted points',
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF101B32),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1F3055)),
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
                      color: const Color(0xFF5B8EFF),
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
                textStyle: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
