import 'package:UniChat/data/models/member_model.dart';
import 'package:UniChat/data/models/message_model.dart';

class GroupModel {
  final String id;
  final String name;
  final List<MessageModel> messages;
  final List<MemberModel> members;

  GroupModel({
    required this.id,
    required this.name,
    required this.messages,
    required this.members,
  });
}
