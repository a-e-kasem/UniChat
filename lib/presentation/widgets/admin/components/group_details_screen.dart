import 'package:UniChat/data/core/consts/consts.dart';
import 'package:UniChat/data/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:UniChat/logic/cubits/group_details_cubit/group_details_cubit.dart';

class GroupDetailsScreen extends StatelessWidget {
  final GroupModel group;
  const GroupDetailsScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GroupDetailsCubit(group)..loadMembers(),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.name,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'ID: ${group.id}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: group.id));
                      showSnackBarSuccess(
                        context,
                        'Group ID copied to clipboard',
                      );
                    },
                    child: Icon(Icons.copy, size: 20),
                  ),
                ],
              ),
            ],
          ),
          toolbarHeight: 90,
        ),
        body: BlocBuilder<GroupDetailsCubit, GroupDetailsState>(
          builder: (context, state) {
            if (state is GroupDetailsError) {
              return Center(child: Text(state.message));
            }

            if (state is GroupDetailsLoaded) {
              final members = state.members;

              if (members.isEmpty) {
                return const Center(child: Text('No members found.'));
              }

              return ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];

                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(member.name),
                    subtitle: Text('Role: ${member.role}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<GroupDetailsCubit>().removeMember(
                              member.id,
                            );
                            showSnackBarSuccess(
                              context,
                              'User removed from group',
                            );
                          },
                        ),
                        if (member.role != 'admin')
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_upward,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              context.read<GroupDetailsCubit>().promoteToAdmin(
                                member.id,
                              );
                              showSnackBarSuccess(
                                context,
                                'User promoted to admin',
                              );
                            },
                          ),
                        if (member.role == 'admin')
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_downward,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              context.read<GroupDetailsCubit>().demoteToMember(
                                member.id,
                              );
                              showSnackBarSuccess(
                                context,
                                'User demoted from admin',
                              );
                            },
                          ),
                      ],
                    ),
                  );
                },
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
