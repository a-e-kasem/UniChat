import 'package:UniChat/data/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:UniChat/logic/cubits/group_details_cubit/group_details_cubit.dart';

class MemberDetailsScreen extends StatelessWidget {
  const MemberDetailsScreen({super.key, required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => GroupDetailsCubit(group)..loadMembers(),
      child: BlocListener<GroupDetailsCubit, GroupDetailsState>(
        listener: (context, state) {
          if (state is GroupDetailsActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is GroupDetailsError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Group Members')),
          body: BlocBuilder<GroupDetailsCubit, GroupDetailsState>(
            builder: (context, state) {
              if (state is GroupDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GroupDetailsLoaded) {
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
                          if (member.role != 'doctor' && member.role != 'admin')
                            IconButton(
                              icon: const Icon(
                                Icons.upgrade,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                context
                                    .read<GroupDetailsCubit>()
                                    .promoteToAdmin(member.id);
                              },
                            )
                          else if (member.role == 'admin')
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_downward,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                context
                                    .read<GroupDetailsCubit>()
                                    .demoteToMember(member.id);
                              },
                            ),
                        ],
                      ),
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
