import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 5, color: Colors.green)]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 8, color: Colors.green)]),
          ],
        ),
      ),
    );
  }
}
