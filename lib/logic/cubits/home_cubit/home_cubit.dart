import 'dart:async';

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
  final User? user = FirebaseAuth.instance.currentUser;

  final List<StreamSubscription> _groupSubscriptions = [];

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

    if (user == null) {
      emit(HomeGroupsError("User is not logged in."));
      return;
    }

    try {
      final snapshot = await firestore
          .collection('users')
          .doc(user!.uid)
          .collection('groups')
          .get();

      List<GroupModel> groups = [];

      for (var doc in snapshot.docs) {
        final groupId = doc.id;
        final groupName = doc['name'];

        final group = GroupModel(
          id: groupId,
          name: groupName,
          messages: [],
          members: [],
        );

        groups.add(group);

        // Start real-time listener for messages in this group
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

          // Update the group messages
          final updatedGroups = groups.map((g) {
            if (g.id == groupId) {
              return GroupModel(id: g.id, name: g.name, messages: updatedMessages, members: []);
            }
            return g;
          }).toList();

          emit(HomeGroupsLoaded(updatedGroups));
        });

        _groupSubscriptions.add(sub);
      }

      // Emit initial empty groups while listeners update in background
      emit(HomeGroupsLoaded(groups));
    } catch (e, stack) {
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: stack);
      emit(HomeGroupsError("Failed to load groups and messages."));
    }
  }
}
