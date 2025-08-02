import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:UniChat/data/models/group_model.dart';
import 'package:UniChat/data/models/member_model.dart';

part 'group_details_state.dart';

class GroupDetailsCubit extends Cubit<GroupDetailsState> {
  final GroupModel group;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  GroupDetailsCubit(this.group) : super(GroupDetailsLoading());

  Future<void> loadMembers() async {
    emit(GroupDetailsLoading());
    try {
      final snapshot = await firestore
          .collection('groups')
          .doc(group.id)
          .collection('members')
          .get();

      final members = snapshot.docs
          .map((doc) => MemberModel.fromDoc(doc))
          .toList();

      emit(GroupDetailsLoaded(members));
    } catch (e) {
      emit(GroupDetailsError('Failed to load members: $e'));
    }
  }

  Future<void> promoteToAdmin(String memberId) async {
    try {
      await firestore
          .collection('groups')
          .doc(group.id)
          .collection('members')
          .doc(memberId)
          .update({'role': 'admin'});

      final updated = (state as GroupDetailsLoaded).members.map((m) {
        if (m.id == memberId) {
          return MemberModel(
            id: m.id,
            name: m.name,
            role: 'admin',
            token: m.token,
          );
        }
        return m;
      }).toList();

      emit(GroupDetailsLoaded(updated));
    } catch (e) {
      emit(GroupDetailsError("Failed to promote: $e"));
    }
  }

  Future<void> demoteToMember(String memberId) async {
    try {
      await firestore
          .collection('groups')
          .doc(group.id)
          .collection('members')
          .doc(memberId)
          .update({'role': 'student'});

      final updated = (state as GroupDetailsLoaded).members.map((m) {
        if (m.id == memberId) {
          return MemberModel(
            id: m.id,
            name: m.name,
            role: 'student',
            token: m.token,
          );
        }
        return m;
      }).toList();

      emit(GroupDetailsLoaded(updated));
    } catch (e) {
      emit(GroupDetailsError("Failed to demote: $e"));
    }
  }

  Future<void> removeMember(String memberId) async {
    try {
      await firestore
          .collection('users')
          .doc(memberId)
          .collection('groups')
          .doc(group.id)
          .delete();

      await firestore
          .collection('groups')
          .doc(group.id)
          .collection('members')
          .doc(memberId)
          .delete();

      final updated = (state as GroupDetailsLoaded).members
          .where((m) => m.id != memberId)
          .toList();

      emit(GroupDetailsLoaded(updated));
    } catch (e) {
      emit(GroupDetailsError("Failed to remove: $e"));
    }
  }
}
