import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:UniChat/data/core/consts/consts.dart';

class AddToGroupAdminButton extends StatefulWidget {
  final String userId;
  final String userName;
  final String userToken;

  const AddToGroupAdminButton({
    super.key,
    required this.userId,
    required this.userName,
    required this.userToken,
  });

  @override
  State<AddToGroupAdminButton> createState() => _AddToGroupAdminButtonState();
}

class _AddToGroupAdminButtonState extends State<AddToGroupAdminButton> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.group_add, color: Colors.blue),
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Add to Group'),
            content: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter Group ID'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final groupId = _controller.text.trim();
                  if (groupId.isEmpty) {
                    showSnackBarError(context, 'Group ID is required');
                    return;
                  }

                  setState(() => _isLoading = true);

                  final userRef = FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userId);
                  final groupRef = FirebaseFirestore.instance
                      .collection('groups')
                      .doc(groupId);

                  try {
                    final groupSnapshot = await groupRef.get();
                    if (!groupSnapshot.exists) {
                      showSnackBarError(context, 'Group not found');
                      _controller.clear();
                      Navigator.pop(context);
                      return;
                    }

                    final memberSnapshot = await groupRef
                        .collection('members')
                        .doc(widget.userId)
                        .get();
                    if (memberSnapshot.exists) {
                      showSnackBarAlert(context, 'User already in group');
                      _controller.clear();
                      Navigator.pop(context);
                      return;
                    }

                    // Add user to group members
                    await groupRef
                        .collection('members')
                        .doc(widget.userId)
                        .set({
                          'joinedAt': Timestamp.now(),
                          'name': widget.userName,
                          'token': widget.userToken,
                          'role': 'student',
                        });

                    // Add group to user profile
                    await userRef.collection('groups').doc(groupId).set({
                      'name': groupSnapshot.data()?['name'] ?? 'Unnamed Group',
                      'joinedAt': Timestamp.now(),
                    });

                    showSnackBarSuccess(
                      context,
                      'User added to group "$groupId"',
                    );

                    _controller.clear();
                    Navigator.pop(context);
                  } catch (e) {
                    showSnackBarError(context, 'Error: ${e.toString()}');
                  } finally {
                    if (mounted) setState(() => _isLoading = false);
                  }
                },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }
}
