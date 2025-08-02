import 'package:flutter/material.dart';
import 'package:UniChat/presentation/widgets/chat/show_image.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.isMe,
    required this.isDark,
    required this.typeMessage,
    required this.imageUrl,
    required this.message,
    this.reactions,
  });

  final bool isMe;
  final bool isDark;
  final String typeMessage;
  final String imageUrl;
  final String message;
  final Map<String, dynamic>? reactions;

  bool isArabic(String text) {
    if (text.isEmpty) return false;

    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final uniqueReactions = reactions?.values.toSet().toList() ?? [];

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomRight: isMe ? const Radius.circular(16) : Radius.zero,
                bottomLeft: isMe ? Radius.zero : const Radius.circular(16),
              ),
            ),
            child: typeMessage == 'image'
                ? GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ShowImage(imageUrl: imageUrl),
                        ),
                      );
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : SelectableText(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    textAlign: isArabic(message)
                        ? TextAlign.right
                        : TextAlign.left,
                    textDirection: isArabic(message)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
          ),

          if (uniqueReactions.isNotEmpty)
            Container(
              margin: EdgeInsets.only(
                top: 2,
                right: isMe ? 12 : 0,
                left: isMe ? 0 : 12,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white24 : Colors.grey.shade400,
                ),
              ),
              child: Wrap(
                spacing: 6,
                children: uniqueReactions
                    .map(
                      (emoji) => Text(
                        emoji.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
