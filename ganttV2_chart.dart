import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/process.dart';

class GanttV2Chart extends StatelessWidget {
  final List<Map<String, dynamic>> timeline;

  const GanttV2Chart({super.key, required this.timeline});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) => Text(
                  '${value.toInt()}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          barGroups: timeline.asMap().entries.map((entry) {
            int index = entry.key;
            var segment = entry.value;
            int start = segment['start'];
            int end = segment['end'];
            String processId = segment['processId'];

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: (end - start).toDouble(),
                  color: Colors.primaries[index % Colors.primaries.length],
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                  rodStackItems: [
                    BarChartRodStackItem(0, (end - start).toDouble(), Colors.primaries[index % Colors.primaries.length]),
                  ],
                ),
              ],
              showingTooltipIndicators: [0],
              barsSpace: 10,
            );
          }).toList(),
        ),
      ),
    );
  }
}
