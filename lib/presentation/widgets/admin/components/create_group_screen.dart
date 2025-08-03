import 'dart:developer';

import 'package:UniChat/data/core/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:UniChat/logic/cubits/admin_groups_cubit/admin_groups_cubit.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({super.key, required this.roleCall});
  static const String id = 'CreateGroupScreen';
  final String roleCall;
 
  @override
  Widget build(BuildContext context) {
    final TextEditingController groupNameController = TextEditingController();
    log('roleCall: $roleCall ===================');
    return Scaffold(
      appBar: AppBar(title: const Text('Create a Group'), centerTitle: true),
      body: BlocListener<AdminGroupsCubit, AdminGroupsState>(
        listener: (context, state) {
          if (state is AdminGroupsSuccess) {
            showSnackBarSuccess(context, state.message);
            Navigator.pop(context);
          } else if (state is AdminGroupsError) {
            showSnackBarError(context, state.message);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: groupNameController,
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<AdminGroupsCubit, AdminGroupsState>(
                builder: (context, state) {
                  final isLoading = state is AdminGroupsLoading;

                  return isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                          icon: const Icon(Icons.group_add),
                          label: const Text('Create Group'),
                          onPressed: () {
                            final name = groupNameController.text.trim();
                            log('roleCall: $roleCall');
                            context.read<AdminGroupsCubit>().createGroup(
                              name,
                              roleCall,
                              context: context,
                            );
                          },
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
