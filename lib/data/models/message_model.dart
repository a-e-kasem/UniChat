import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final String imageUrl;
  final String type;
  final Timestamp? time;
  final String replyMessageID;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.imageUrl,
    required this.type,
    required this.time,
    required this.replyMessageID,
  });

  factory MessageModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      message: data['message'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      type: data['type'] ?? 'text',
      time: data['time'],
      replyMessageID: data['replyMessageID'] ?? '',
    );
  }
}
