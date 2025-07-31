import 'package:cloud_firestore/cloud_firestore.dart';

class MemberModel {
  final String id;
  final String name;
  final String role;

  MemberModel({
    required this.id,
    required this.name,
    required this.role,
  });

  factory MemberModel.fromDoc(DocumentSnapshot doc) {
    return MemberModel(
      id: doc.id,
      name: doc['name'],
      role: doc['role'],
    );
  }
}
