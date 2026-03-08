import 'package:flutter/material.dart';

class TodoForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool isViewOnly;
  final bool isEditing;

  const TodoForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.isViewOnly,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            if (isViewOnly) _buildViewOnlyMessage(),
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
            color: isViewOnly
                ? Colors.grey.shade100
                : Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isViewOnly ? Icons.visibility : Icons.edit_note,
            color: isViewOnly ? Colors.grey : Colors.blueAccent,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          isViewOnly ? 'Task Details (View Only)' : 'Task Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isViewOnly ? Colors.grey.shade600 : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: titleController,
      decoration: InputDecoration(
        labelText: 'Title',
        labelStyle: TextStyle(
          color: isViewOnly ? Colors.grey.shade500 : Colors.blueAccent,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isViewOnly ? Colors.grey.shade300 : Colors.blueAccent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isViewOnly ? Colors.grey.shade200 : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isViewOnly ? Colors.grey.shade400 : Colors.blueAccent,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.title,
          color: isViewOnly ? Colors.grey.shade400 : Colors.blueAccent,
        ),
        filled: true,
        fillColor: isViewOnly ? Colors.grey.shade50 : Colors.white,
      ),
      readOnly: isViewOnly,
      enabled: !isViewOnly,
      style: TextStyle(
        color: isViewOnly ? Colors.grey.shade600 : Colors.black87,
      ),
      validator: (value) {
        if (!isViewOnly && (value == null || value.isEmpty)) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: descriptionController,
      decoration: InputDecoration(
        labelText: 'Description',
        labelStyle: TextStyle(
          color: isViewOnly ? Colors.grey.shade500 : Colors.blueAccent,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isViewOnly ? Colors.grey.shade300 : Colors.blueAccent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isViewOnly ? Colors.grey.shade200 : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isViewOnly ? Colors.grey.shade400 : Colors.blueAccent,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.description,
          color: isViewOnly ? Colors.grey.shade400 : Colors.blueAccent,
        ),
        alignLabelWithHint: true,
        filled: true,
        fillColor: isViewOnly ? Colors.grey.shade50 : Colors.white,
      ),
      maxLines: 4,
      readOnly: isViewOnly,
      enabled: !isViewOnly,
      style: TextStyle(
        color: isViewOnly ? Colors.grey.shade600 : Colors.black87,
      ),
      validator: (value) {
        if (!isViewOnly && (value == null || value.isEmpty)) {
          return 'Please enter a description';
        }
        return null;
      },
    );
  }

  Widget _buildViewOnlyMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.visibility,
                color: Colors.blue.shade700,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'View Only Mode',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'This task is completed and cannot be edited',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
