import 'package:flutter/material.dart';
import '../models/monthly_report.dart';

class SpendingPieChart extends StatelessWidget {
  final SpendingReport report;

  const SpendingPieChart({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    // Placeholder implementation
    return Container(
      height: 200,
      child: Center(
        child: Text('Pie Chart Placeholder'),
      ),
    );
  }
}
