import 'dart:developer';
import 'package:UniChat/data/core/consts/consts.dart';
import 'package:UniChat/logic/cubits/home_cubit/home_cubit.dart';
import 'package:UniChat/logic/cubits/admin_groups_cubit/admin_groups_cubit.dart';
import 'package:UniChat/presentation/widgets/settings/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorCreateGroupButton extends StatefulWidget {
  const DoctorCreateGroupButton({
    super.key,
    required this.userName,
    required this.userId,
  });

  final String userName;
  final String userId;

  @override
  State<DoctorCreateGroupButton> createState() =>
      _DoctorCreateGroupButtonState();
}

class _DoctorCreateGroupButtonState extends State<DoctorCreateGroupButton> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool needCreate = false;

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
        return;
      }

      final memberSnapshot = await groupRef
          .collection('members')
          .doc(widget.userId)
          .get();

      if (memberSnapshot.exists) {
        showSnackBarAlert(context, 'You already joined this group');
        return;
      }

      await groupRef.collection('members').doc(widget.userId).set({
        'joinedAt': Timestamp.now(),
        'name': widget.userName,
        'role': 'doctor',
        'token': FirebaseApi.userToken,
      });

      await userRef.collection('groups').doc(groupId).set({
        'name': groupSnapshot.data()?['name'] ?? 'Unnamed Group',
        'joinedAt': Timestamp.now(),
      });

      BlocProvider.of<HomeCubit>(context).getUserGroups();
      showSnackBarSuccess(context, 'Joined group "$groupId" successfully');
      Navigator.pop(context);
    } catch (e) {
      showSnackBarError(context, 'Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> showGroupDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) =>
            BlocListener<AdminGroupsCubit, AdminGroupsState>(
              listener: (context, state) {
                if (state is AdminGroupsSuccess) {
                  showSnackBarSuccess(context, state.message);
                  Navigator.pop(context);
                } else if (state is AdminGroupsError) {
                  showSnackBarError(context, state.message);
                }
              },
              child: AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        needCreate ? 'Create a Group' : 'Join a Group',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        setStateDialog(() {
                          needCreate = !needCreate;
                          _controller.clear();
                        });
                      },
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            needCreate ? 'Join' : 'Create',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                content: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: needCreate
                              ? 'Enter Group Name'
                              : 'Enter Group ID',
                        ),
                      ),
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_isLoading) return;
                      final input = _controller.text.trim();

                      if (input.isEmpty) return;

                      if (needCreate) {
                        context.read<AdminGroupsCubit>().createGroup(
                          input,
                          'doctor',
                          context: context,
                        );
                      } else {
                        joinGroup(context);
                      }
                    },
                    child: Text(needCreate ? 'Create' : 'Join'),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add, color: Colors.blue, size: 30),
      onPressed: () => showGroupDialog(context),
    );
  }
}
