import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(value: 40, color: Colors.green, title: 'Суккуленты'),
            PieChartSectionData(value: 30, color: Colors.blue, title: 'Тропические'),
            PieChartSectionData(value: 30, color: Colors.purple, title: 'Цветущие'),
          ],
        ),
      ),
    );
  }
}
