import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback onTap;
  final Function(TodoStatus) onStatusChanged;

  const TodoCard({
    super.key,
    required this.todo,
    required this.onTap,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = todo.status == TodoStatus.completed;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: isCompleted ? Colors.grey.shade50 : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  Expanded(
                    child: Text(
                      todo.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: isCompleted ? Colors.grey : null,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: todo.status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: todo.status.color),
                    ),
                    child: Text(
                      todo.status.displayName,
                      style: TextStyle(
                        color: todo.status.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              if (todo.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  todo.description,
                  style: TextStyle(
                    color: isCompleted ? Colors.grey.shade500 : Colors.grey[600],
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: isCompleted ? Colors.grey.shade400 : Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Created: ${todo.createdBy}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isCompleted ? Colors.grey.shade400 : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.update,
                        size: 14,
                        color: isCompleted ? Colors.grey.shade400 : Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTimeAgo(todo.updatedAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: isCompleted ? Colors.grey.shade400 : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (!isCompleted)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildStatusButton(
                      context,
                      TodoStatus.pending,
                      todo.status == TodoStatus.pending,
                    ),
                    const SizedBox(width: 8),
                    _buildStatusButton(
                      context,
                      TodoStatus.in_progress,
                      todo.status == TodoStatus.in_progress,
                    ),
                    const SizedBox(width: 8),
                    _buildStatusButton(
                      context,
                      TodoStatus.completed,
                      todo.status == TodoStatus.completed,
                    ),
                  ],
                )
              else

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.visibility,
                        color: Colors.green,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'View only - Tap to view details',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(
      BuildContext context,
      TodoStatus status,
      bool isActive,
      ) {
    return Expanded(
      child: InkWell(
        onTap: () => onStatusChanged(status),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? status.color : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive ? status.color : Colors.grey[300]!,
            ),
          ),
          child: Text(
            status.displayName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? Colors.white : status.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
