import 'dart:async';
import 'dart:developer';

import 'package:UniChat/data/models/member_model.dart';
import 'package:UniChat/presentation/widgets/settings/firebase_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:UniChat/data/models/group_model.dart';
import 'package:UniChat/data/models/message_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<StreamSubscription> _groupSubscriptions = [];
  List<String> Domains = [];

  // Cleanup when done
  @override
  Future<void> close() {
    for (final sub in _groupSubscriptions) {
      sub.cancel();
    }
    return super.close();
  }
Future<void> getUserGroups() async {
    emit(HomeGroupsLoading());

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(HomeGroupsError("User is not logged in."));
      return;
    }

    try {
      final userGroupsSnapshot = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('groups')
          .get();

      if (userGroupsSnapshot.docs.isEmpty) {
        emit(HomeGroupsLoaded([]));
        return;
      }

      List<GroupModel> groups = [];

      await Future.wait(
        userGroupsSnapshot.docs.map((doc) async {
          final groupId = doc.id;
          final groupName = doc['name'];

          final groupDoc = await firestore
              .collection('groups')
              .doc(groupId)
              .get();

          final groupData = groupDoc.data();
          if (groupData == null) return;

          final membersSnapshot = await firestore
              .collection('groups')
              .doc(groupId)
              .collection('members')
              .get();

          List<MemberModel> members = membersSnapshot.docs
              .map((doc) => MemberModel.fromDoc(doc))
              .toList();

          final group = GroupModel(
            id: groupId,
            name: groupName,
            messages: [],
            members: members,
          );

          groups.add(group);

          final sub = firestore
              .collection('groups')
              .doc(groupId)
              .collection('messages')
              .orderBy('time', descending: true)
              .snapshots()
              .listen((snapshot) {
                final updatedMessages = snapshot.docs
                    .map((doc) => MessageModel.fromDoc(doc))
                    .toList();

                final updatedGroups = groups.map((g) {
                  if (g.id == groupId) {
                    return GroupModel(
                      id: g.id,
                      name: g.name,
                      messages: updatedMessages,
                      members: g.members,
                    );
                  }
                  return g;
                }).toList();

                emit(HomeGroupsLoaded(updatedGroups));
              });

          _groupSubscriptions.add(sub);
        }),
      );

      emit(HomeGroupsLoaded(groups));
      log('[debug] ${groups[0].name} has ${groups[0].members.length} members');
    } catch (e, stack) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: stack);
      emit(HomeGroupsError("Failed to load groups and messages."));
    }
  }

  Future<List<String>> getAllUniversities() async {
    try {
      final snapshot = await firestore.collection('universities').get();
      Domains = [];
      for (var uni in snapshot.docs) {
        final uniId = uni.id;
        Domains.add(uniId);
      }
      return Domains;
    } catch (e, stack) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: stack);
      emit(HomeGroupsError("Failed to load groups and messages."));
      return [];
    }
  }

  Future<void> checkAndUpdateUserTokenInAllGroups(
    String userId,
    String userName,
    List<String> userGroupIds,
  ) async {
    for (final groupId in userGroupIds) {
      final memberRef = firestore
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .doc(userId);

      final memberDoc = await memberRef.get();

      if (memberDoc.exists) {
        final currentToken = memberDoc.data()?['token'];
        if (currentToken != FirebaseApi.userToken) {
          await memberRef.update({'token': FirebaseApi.userToken});
          log('✅ Token updated in group $groupId');
        }
      }
    }
  }
}
