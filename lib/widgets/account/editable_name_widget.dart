import 'package:flutter/material.dart';

class EditableNameWidget extends StatelessWidget {
  const EditableNameWidget({
    super.key,
    required this.isEdit,
    required this.controller,
    required this.displayName,
    required this.onEditPressed,
    required this.onSubmit,
  });

  final bool isEdit;
  final TextEditingController controller;
  final String? displayName;
  final VoidCallback onEditPressed;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    if (isEdit) {
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              onSubmitted: (_) => onSubmit(),
              decoration: InputDecoration(
                hintText: 'Enter your name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: onSubmit,
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              (displayName?.trim().isNotEmpty ?? false)
                  ? displayName!
                  : 'No Name',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey),
            onPressed: onEditPressed,
          ),
        ],
      );
    }
  }
}
