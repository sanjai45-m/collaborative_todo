import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final bool isViewOnly;
  final bool isEditing;
  final VoidCallback onClose;
  final VoidCallback onDelete;
  final VoidCallback onSave;

  const ActionButtons({
    super.key,
    required this.isViewOnly,
    required this.isEditing,
    required this.onClose,
    required this.onDelete,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: _buildButtons(),
    );
  }

  Widget _buildButtons() {

    if (isViewOnly) {
      return _buildFullWidthButton(
        label: 'Close',
        icon: Icons.close,
        onPressed: onClose,
        color: Colors.blueAccent,
      );
    }

    if (isEditing) {
      return Row(
        children: [
          Expanded(child: _buildDeleteButton()),
          const SizedBox(width: 12),
          Expanded(child: _buildUpdateButton()),
        ],
      );
    }

    return _buildFullWidthButton(
      label: 'Create Task',
      icon: Icons.add,
      onPressed: onSave,
      color: Colors.blueAccent,
    );
  }

  Widget _buildFullWidthButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        onPressed: onDelete,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, size: 20),
            SizedBox(width: 8),
            Text(
              'Delete',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save, size: 20),
            SizedBox(width: 8),
            Text(
              'Update',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
