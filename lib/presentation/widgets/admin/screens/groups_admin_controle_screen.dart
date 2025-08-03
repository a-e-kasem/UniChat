
import 'package:UniChat/data/core/consts/consts.dart';
import 'package:UniChat/data/models/group_model.dart';
import 'package:UniChat/presentation/widgets/admin/components/create_group_screen.dart';
import 'package:UniChat/presentation/widgets/admin/components/delete_group_dialog.dart';
import 'package:UniChat/presentation/widgets/admin/components/group_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:UniChat/logic/cubits/admin_groups_cubit/admin_groups_cubit.dart';

class GroupsAdminControleScreen extends StatefulWidget {
  const GroupsAdminControleScreen({super.key});
  static const String id = 'GroupsAdminControleScreen';

  @override
  State<GroupsAdminControleScreen> createState() =>
      _GroupsAdminControleScreenState();
}

class _GroupsAdminControleScreenState extends State<GroupsAdminControleScreen> {
  late final AdminGroupsCubit _adminCubit;

  @override
  void initState() {
    super.initState();
    _adminCubit = AdminGroupsCubit()..getUserGroups();
  }

  @override
  void dispose() {
    _adminCubit.close();
    super.dispose();
  }

  Future<void> showDeleteConfirmationDialog(
    BuildContext context,
    GroupModel group,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          DeleteGroupDialog(group: group, adminCubit: _adminCubit),
    );

    if (confirm == true) {
      _adminCubit.getUserGroups();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _adminCubit,
      child: BlocListener<AdminGroupsCubit, AdminGroupsState>(
        listener: (context, state) {
          if (state is AdminGroupsSuccess) {
            showSnackBarSuccess(context, state.message);
          } else if (state is AdminGroupsError) {
            showSnackBarError(context, state.message);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Groups Admin Control'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateGroupScreen(roleCall: 'admin'),
                    ),
                  );
                  _adminCubit.getUserGroups();
                },
              ),
            ],
          ),
          body: BlocBuilder<AdminGroupsCubit, AdminGroupsState>(
            builder: (context, state) {
              if (state is AdminGroupsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AdminGroupsError) {
                return Center(child: Text(state.message));
              } else if (state is AdminGroupsLoaded) {
                final groups = state.groups;

                if (groups.isEmpty) {
                  return const Center(child: Text('No groups found.'));
                }

                return RefreshIndicator(
                  onRefresh: () async => _adminCubit.getUserGroups(),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.group, size: 40),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                group.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                group.id,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text('${group.members.length} members'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () =>
                                showDeleteConfirmationDialog(context, group),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    GroupDetailsScreen(group: group),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
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
