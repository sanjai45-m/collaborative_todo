import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/todo_provider.dart';
import '../models/todo.dart';

class StatusChart extends StatelessWidget {
  const StatusChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        final counts = provider.getStatusCounts();
        final total = counts.values.fold(0, (sum, count) => sum + count);

        return Container(
          height: 400,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Task Status Distribution',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: _buildChartSections(counts),
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (total > 0) ...[
                _buildLegend(),
                const SizedBox(height: 8),
                Text(
                  'Total Tasks: $total',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else
                const Text(
                  'No tasks available',
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _buildChartSections(Map<TodoStatus, int> counts) {
    return counts.entries.map((entry) {
      final status = entry.key;
      final count = entry.value;

      return PieChartSectionData(
        color: status.color,
        value: count.toDouble(),
        title: count.toString(),
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: TodoStatus.values.map((status) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: status.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(status.displayName),
            ],
          ),
        );
      }).toList(),
    );
  }
}
