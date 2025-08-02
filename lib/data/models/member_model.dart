import 'package:cloud_firestore/cloud_firestore.dart';

class MemberModel {
  final String id;
  final String name;
  final String role;
  final String token;

  MemberModel({
    required this.id,
    required this.name,
    required this.role,
    required this.token,
  });

  factory MemberModel.fromDoc(DocumentSnapshot doc) {
    return MemberModel(
      id: doc.id,
      name: doc['name'],
      role: doc['role'],
      token: doc['token'],
    );
  }
}
