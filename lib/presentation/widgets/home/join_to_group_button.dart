import 'package:UniChat/data/core/consts/consts.dart';
import 'package:UniChat/logic/cubits/home_cubit/home_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  Future<void> joinGroup(BuildContext context) async {
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
        setState(() => _isLoading = false);
        _controller.clear();
        return;
      }

      final memberSnapshot = await groupRef
          .collection('members')
          .doc(widget.userId)
          .get();

      if (memberSnapshot.exists) {
        showSnackBarAlert(context, 'You already joined this group');
        setState(() => _isLoading = false);
        _controller.clear();
        Navigator.pop(context);
        return;
      }

      await groupRef.collection('members').doc(widget.userId).set({
        'joinedAt': Timestamp.now(),
        'name': widget.userName ?? 'Anonymous',
        'role': 'student',
      });

      await userRef.collection('groups').doc(groupId).set({
        'name': groupSnapshot.data()?['name'] ?? 'Unnamed Group',
        'joinedAt': Timestamp.now(),
      });

      showSnackBarSuccess(context, 'Joined group "$groupId" successfully');
      BlocProvider.of<HomeCubit>(context).getUserGroups();

      _controller.clear();
      Navigator.pop(context);
    } catch (e) {
      showSnackBarError(context, 'Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add, color: Colors.green, size: 30),
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (_) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: const Text('Join a Group'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter Group ID',
                    ),
                  ),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: _isLoading ? null : () => joinGroup(context),
                  child: const Text('Join'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
