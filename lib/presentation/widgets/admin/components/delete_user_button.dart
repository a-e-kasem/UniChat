import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:UniChat/data/core/consts/consts.dart';

class DeleteUserButton extends StatefulWidget {
  const DeleteUserButton({super.key, required this.userId});
  final String userId;

  @override
  State<DeleteUserButton> createState() => _DeleteUserButtonState();
}

class _DeleteUserButtonState extends State<DeleteUserButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete user?'),
            content: const Text('Are you sure you want to delete this user?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );

        if (confirm == true) {
          final userId = widget.userId;
          if (userId.isEmpty) {
            showSnackBarError(context, 'User ID is required');
            return;
          }

          try {
            final userRef =
                FirebaseFirestore.instance.collection('users').doc(userId);

            // 
            final userGroupsSnapshot = await userRef.collection('groups').get();
            for (final doc in userGroupsSnapshot.docs) {
              final groupId = doc.id;
              await FirebaseFirestore.instance
                  .collection('groups')
                  .doc(groupId)
                  .collection('members')
                  .doc(userId)
                  .delete();
            }

            // 
            for (final doc in userGroupsSnapshot.docs) {
              await doc.reference.delete(); // users/user/groups
            }

            // 
            await userRef.delete();
            setState(() {
              
            });
            showSnackBarSuccess(context, 'User deleted successfully');
          } catch (e) {
            showSnackBarError(context, 'Error deleting user: $e');
          }
        }
      },
    );
  }
}
