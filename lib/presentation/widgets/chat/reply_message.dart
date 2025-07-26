import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:UniChat/presentation/widgets/chat/show_image.dart';

class ReplyMessage extends StatefulWidget {
  final String messageReply;
  final String chatId;
  final bool isMe;
  final bool isDark;
  final String typeMessage;
  final String imageUrl;

  const ReplyMessage({
    super.key,
    required this.messageReply,
    required this.chatId,
    required this.isMe,
    required this.isDark,
    required this.typeMessage,
    required this.imageUrl,
  });

  @override
  State<ReplyMessage> createState() => _ReplyMessageState();
}

class _ReplyMessageState extends State<ReplyMessage> {
  DocumentSnapshot? _cachedReply;

  @override
  void initState() {
    super.initState();
    fetchReply();
  }

  Future<void> fetchReply() async {
    if (widget.messageReply.isNotEmpty) {
      final reply = await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.chatId)
          .collection('messages')
          .doc(widget.messageReply)
          .get();
      if (mounted) {
        setState(() {
          _cachedReply = reply;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cachedReply == null) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 1),
        ),
      );
    }

    if (!_cachedReply!.exists) {
      return _buildReplyContainer(
        const Text(
          'Deleted message',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }

    final data = _cachedReply!.data() as Map<String, dynamic>;
    final replyType = data['type'] ?? 'text';
    final replyText = data['message'] ?? '';
    final replyImageUrl = data['imageUrl'] ?? '';

    if (replyType == 'image') {
      return _buildReplyContainer(
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ShowImage(imageUrl: replyImageUrl),
              ),
            );
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(replyImageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    } else {
      return _buildReplyContainer(
        Text(
          replyText,
          style: const TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }

  Widget _buildReplyContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: widget.isMe
            ? (widget.isDark ? Colors.blueAccent[200] : Colors.lightBlue[100])
            : (widget.isDark ? Colors.grey[500] : Colors.grey[200]),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomRight: Radius.zero,
          bottomLeft: Radius.zero,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.reply, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Flexible(child: child),
        ],
      ),
    );
  }
}
