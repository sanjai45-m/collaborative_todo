import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../utils/date_formatter.dart';

class TodoInfoCard extends StatelessWidget {
  final Todo todo;
  final bool isViewOnly;

  const TodoInfoCard({
    super.key,
    required this.todo,
    required this.isViewOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.person_outline,
              label: 'Created by',
              value: todo.createdBy,
              iconColor: Colors.blueAccent,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              icon: Icons.update,
              label: 'Last updated by',
              value: todo.updatedBy,
              iconColor: Colors.orange,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              icon: Icons.access_time,
              label: 'Last updated',
              value: DateFormatter.formatTimeAgo(todo.updatedAt),
              iconColor: Colors.purple,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              icon: Icons.info_outline,
              label: 'Status',
              value: todo.status.displayName,
              iconColor: todo.status.color,
              valueColor: todo.status.color,
              isStatus: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.info_outline,
            color: Colors.amber.shade800,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Task Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    Color? valueColor,
    bool isStatus = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isStatus ? FontWeight.bold : FontWeight.w500,
                  color: valueColor ?? Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
