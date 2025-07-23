import 'package:flutter/material.dart';
import 'package:uni_chat/widgets/chat/show_image.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.isMe,
    required this.isDark,
    required this.typeMessage,
    required this.imageUrl,
    required this.message,
  });

  final bool isMe;
  final bool isDark;
  final dynamic typeMessage;
  final dynamic imageUrl;
  final dynamic message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomRight: isMe
              ? const Radius.circular(16)
              : Radius.zero,
          bottomLeft: isMe
              ? Radius.zero
              : const Radius.circular(16),
        ),
      ),
      child: typeMessage == 'image'
          ? GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ShowImage(imageUrl: imageUrl),
                  ),
                );
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          : Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
    );
  }
}
