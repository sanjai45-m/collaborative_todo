import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_card.dart';
import '../widgets/status_chart.dart';
import '../widgets/drawer/custom_drawer.dart';
import 'add_edit_todo_screen.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F4),
      appBar: _buildAppBar(context),
      drawer: const CustomDrawer(),
      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {

          if (!provider.isInitialized || provider.isConnecting) {
            return _buildLoadingState(provider);
          }

          if (provider.todos.isEmpty) {
            return _buildEmptyState();
          }

          return _buildTodoList(provider);
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      title: const Text(
        'Collaborative Todo List',
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
      ),
      centerTitle: true,
      elevation: 2,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _showStatusChart(context),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.pie_chart,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Chart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(TodoProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 2 * 3.14159,
                child: child,
              );
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: SweepGradient(
                  colors: [
                    Colors.blueAccent.withOpacity(0.3),
                    Colors.blueAccent,
                    Colors.blueAccent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            provider.isConnecting
                ? 'Connecting to server...'
                : 'Loading your tasks...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          if (provider.reconnectAttempts > 0)
            Text(
              'Attempt ${provider.reconnectAttempts}...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),

          const SizedBox(height: 16),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue.shade700,
                  size: 20,
                ),
                const SizedBox(height: 8),
                Text(
                  'Server is waking up...',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This may take 30-60 seconds on first load',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.task_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No tasks yet',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to create your first task',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),

          Consumer<TodoProvider>(
            builder: (context, provider, child) {
              return ElevatedButton.icon(
                onPressed: provider.isConnecting
                    ? null
                    : () => provider.refreshConnection(),
                icon: Icon(
                  Icons.refresh,
                  color: provider.isConnecting ? Colors.grey : Colors.white,
                ),
                label: Text(
                  provider.isConnecting ? 'Connecting...' : 'Refresh',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTodoList(TodoProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: provider.todos.length,
      itemBuilder: (context, index) {
        final todo = provider.todos[index];
        return TodoCard(
          todo: todo,
          onTap: () => _editTodo(context, todo),
          onStatusChanged: (newStatus) {
            provider.updateStatus(todo, newStatus);
          },
        );
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        return FloatingActionButton.extended(
          onPressed: provider.isConnected && provider.isInitialized
              ? () => _addNewTodo(context)
              : null,
          icon: Icon(
            Icons.add,
            color: provider.isConnected && provider.isInitialized
                ? Colors.white
                : Colors.grey.shade400,
          ),
          label: Text(
            'Add Task',
            style: TextStyle(
              color: provider.isConnected && provider.isInitialized
                  ? Colors.white
                  : Colors.grey.shade400,
            ),
          ),
          backgroundColor: provider.isConnected && provider.isInitialized
              ? Colors.blueAccent
              : Colors.grey.shade300,
        );
      },
    );
  }

  void _addNewTodo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditTodoScreen()),
    );
  }

  void _editTodo(BuildContext context, todo) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditTodoScreen(todo: todo)),
    );
  }

  void _showStatusChart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const StatusChart(),
    );
  }
}
