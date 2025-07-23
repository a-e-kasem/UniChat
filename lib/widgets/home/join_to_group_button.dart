import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_chat/widgets/home/provider_state.dart';
import 'package:uni_chat/core/consts/consts.dart';

class JoinToGroupButton extends StatefulWidget {
  final String userId;
  final String? userName;

  const JoinToGroupButton({super.key, required this.userId, this.userName});

  @override
  State<JoinToGroupButton> createState() => _JoinToGroupButtonState();
}

class _JoinToGroupButtonState extends State<JoinToGroupButton> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add, color: Colors.green, size: 30),
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Join a Group'),
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
                  if (groupId.isEmpty) return;

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

                      return;
                    }

                    final memberSnapshot = await groupRef
                        .collection('members')
                        .doc(widget.userId)
                        .get();

                    if (memberSnapshot.exists) {
                      showSnackBarAlert(
                        context,
                        'You already joined this group',
                      );
                      return;
                    }

                    // Add user to group members
                    await groupRef
                        .collection('members')
                        .doc(widget.userId)
                        .set({
                          'joinedAt': Timestamp.now(),
                          'name': widget.userName ?? 'Anonymous',
                          'role': 'student',
                        });
                    // Add group to user profile
                    await userRef.collection('groups').doc(groupId).set({
                      'name': groupSnapshot.data()?['name'] ?? 'Unnamed Group',
                      'joinedAt': Timestamp.now(),
                    });

                    showSnackBarSuccess(
                      context,
                      'Joined group "$groupId" successfully',
                    );
                    // Clear the input field
                    _controller.clear();
                    Navigator.pop(context);
                    // Update the join state in ProviderState
                    Provider.of<ProviderState>(
                      context,
                      listen: false,
                    ).toggleJoinState();
                  } catch (e) {
                    showSnackBarError(context, 'Error: ${e.toString()}');
                  } finally {
                    if (mounted) setState(() => _isLoading = false);
                  }
                },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Join'),
              ),
            ],
          ),
        );
      },
    );
  }
}
