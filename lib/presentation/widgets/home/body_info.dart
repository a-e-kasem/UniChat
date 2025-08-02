import 'package:UniChat/logic/cubits/home_cubit/home_cubit.dart';
import 'package:UniChat/presentation/widgets/settings/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:UniChat/presentation/screens/chat/chat_screen.dart';

class BodyInfo extends StatefulWidget {
  const BodyInfo({super.key, required this.userRole});
  final String userRole;

  @override
  State<BodyInfo> createState() => _BodyInfoState();
}

class _BodyInfoState extends State<BodyInfo> {

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeGroupsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeGroupsError) {
          return Center(child: Text(state.message));
        } else if (state is HomeGroupsLoaded) {
          final groups = state.groups;

          if (groups.isEmpty) {
            return const Center(child: Text("You are not in any group."));
          }

          context.read<HomeCubit>().checkAndUpdateUserTokenInAllGroups(
            FirebaseAuth.instance.currentUser!.uid,
            FirebaseAuth.instance.currentUser!.displayName ?? '',
            groups.map((group) => group.id).toList(),
          );
          
          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(group: group),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.userGroup),
                    title: Text(
                      group.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('Group ID: ${group.id}'),
                  ),
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
