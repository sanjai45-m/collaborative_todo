import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_form.dart';
import '../widgets/todo_info_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/delete_dialog.dart';

class AddEditTodoScreen extends StatefulWidget {
  final Todo? todo;

  const AddEditTodoScreen({super.key, this.todo});

  @override
  State<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late bool _isEditing;
  late bool _isViewOnly;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.todo != null;
    final isCompleted = widget.todo?.status == TodoStatus.completed;
    _isViewOnly = isCompleted;
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController = TextEditingController(text: widget.todo?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F4),
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TodoForm(
              formKey: _formKey,
              titleController: _titleController,
              descriptionController: _descriptionController,
              isViewOnly: _isViewOnly,
              isEditing: _isEditing,
            ),
            const SizedBox(height: 16),
            if (_isEditing) ...[
              TodoInfoCard(
                todo: widget.todo!,
                isViewOnly: _isViewOnly,
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: ActionButtons(
        isViewOnly: _isViewOnly,
        isEditing: _isEditing,
        onClose: () => Navigator.pop(context),
        onDelete: _showDeleteDialog,
        onSave: _saveTodo,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        _getAppBarTitle(),
        style: TextStyle(
          color: _isViewOnly ? Colors.black87 : Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevation: 0,
      backgroundColor: _isViewOnly ? Colors.white : Colors.blueAccent,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: _isViewOnly ? Colors.black87 : Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  String _getAppBarTitle() {
    if (_isViewOnly) return 'View Completed Task';
    if (_isEditing) return 'Edit Task';
    return 'Create New Task';
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<TodoProvider>(context, listen: false);

      if (_isEditing) {
        provider.updateTodo(
          widget.todo!,
          _titleController.text,
          _descriptionController.text,
        );
      } else {
        provider.addTodo(
          _titleController.text,
          _descriptionController.text,
        );
      }

      Navigator.pop(context);
      _showSuccessSnackbar();
    }
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _isEditing ? Icons.update : Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(_isEditing ? 'Task updated successfully!' : 'Task created successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => DeleteDialog(
        onDelete: _deleteTodo,
      ),
    );
  }

  void _deleteTodo() {
    final provider = Provider.of<TodoProvider>(context, listen: false);
    provider.deleteTodo(widget.todo!);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        content: Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Text('Task deleted successfully!'),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
