import 'package:UniChat/data/models/group_model.dart';
import 'package:UniChat/logic/cubits/admin_groups_cubit/admin_groups_cubit.dart';
import 'package:flutter/material.dart';

class DeleteGroupDialog extends StatefulWidget {
  final GroupModel group;
  final AdminGroupsCubit adminCubit;

  const DeleteGroupDialog({
    super.key,
    required this.group,
    required this.adminCubit,
  });

  @override
  State<DeleteGroupDialog> createState() => _DeleteGroupDialogState();
}


class _DeleteGroupDialogState extends State<DeleteGroupDialog> {
  bool _isDeleting = false;

  Future<void> _deleteGroup() async {
    setState(() => _isDeleting = true);
    await widget.adminCubit.deleteGroup(widget.group.id);
    if (mounted) Navigator.pop(context, true); // return true = confirm delete
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Group'),
      content: Text(
        'Are you sure you want to delete the group "${widget.group.name}"?',
      ),
      actions: [
        TextButton(
          onPressed: _isDeleting ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: _isDeleting ? null : _deleteGroup,
          child: _isDeleting
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
