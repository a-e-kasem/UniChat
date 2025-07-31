import 'dart:async';

import 'package:UniChat/data/models/group_model.dart';
import 'package:UniChat/data/models/member_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'admin_groups_state.dart';

class AdminGroupsCubit extends Cubit<AdminGroupsState> {
  AdminGroupsCubit() : super(AdminGroupsInitial());

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  final List<StreamSubscription> _groupSubscriptions = [];

  Future<void> getUserGroups() async {
    emit(AdminGroupsLoading());

    try {
      final snapshot = await firestore.collection('groups').get();

      List<GroupModel> groups = [];

      for (var doc in snapshot.docs) {
        final groupId = doc.id;
        final groupName = doc['name'];

        final membersSnapshot = await firestore
            .collection('groups')
            .doc(groupId)
            .collection('members')
            .get();

        final members = membersSnapshot.docs
            .map((memberDoc) => MemberModel.fromDoc(memberDoc))
            .toList();

        groups.add(
          GroupModel(
            id: groupId,
            name: groupName,
            messages: [],
            members: members,
          ),
        );
      }

      emit(AdminGroupsLoaded(groups));
    } catch (e) {
      emit(AdminGroupsError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    for (final sub in _groupSubscriptions) {
      sub.cancel();
    }
    return super.close();
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      final groupRef = firestore.collection('groups').doc(groupId);
      final membersRef = groupRef.collection('members');
      final membersSnapshot = await membersRef.get();

      final batch = firestore.batch();

      for (var memberDoc in membersSnapshot.docs) {
        final userGroupRef = firestore
            .collection('users')
            .doc(memberDoc.id)
            .collection('groups')
            .doc(groupId);

        batch.delete(userGroupRef);
        batch.delete(membersRef.doc(memberDoc.id));
      }

      batch.delete(groupRef);

      await batch.commit();

      getUserGroups();
      emit(AdminGroupsLoading());
      await getUserGroups();
    } catch (e) {
      emit(AdminGroupsError('Failed to delete group: ${e.toString()}'));
    }
  }

  Future<void> createGroup(String groupName, String roleCreator) async {
    if (groupName.trim().isEmpty || user == null) {
      emit(AdminGroupsError('Group name is required.'));
      return;
    }

    try {
      final groupId =
          '${groupName.trim()}_${DateTime.now().millisecondsSinceEpoch}';
      final groupRef = firestore.collection('groups').doc(groupId);

    
      await groupRef.set({
        'name': groupName,
        'createdBy': user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await groupRef.collection('members').doc(user!.uid).set({
        'name': user!.displayName ?? 'Anonymous',
        'role': roleCreator,
        'joinedAt': Timestamp.now(),
      });


      await firestore
          .collection('users')
          .doc(user!.uid)
          .collection('groups')
          .doc(groupId)
          .set({'name': groupName, 'joinedAt': Timestamp.now()});

      emit(AdminGroupsSuccess('Group "$groupName" created successfully.'));
      await getUserGroups();
    } catch (e) {
      emit(AdminGroupsError('Failed to create group: ${e.toString()}'));
    }
  }
}
