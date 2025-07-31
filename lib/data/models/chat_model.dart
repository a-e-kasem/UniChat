class ChatModel {
  String senderId;
  String receiverId;
  String message;
  DateTime timestamp;
  ChatModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });
}
