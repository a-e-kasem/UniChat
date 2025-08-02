import 'package:flutter/material.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key, required this.controller});
  final TextEditingController controller;
  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool isArabicInput = false;

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: widget.controller,
      onChanged: (text) {
        final isArabicNow = isArabic(text);
        if (isArabicNow != isArabicInput) {
          setState(() {
            isArabicInput = isArabicNow;
          });
        }
      },
      textDirection: isArabicInput ? TextDirection.rtl : TextDirection.ltr,
      textAlign: isArabicInput ? TextAlign.right : TextAlign.left,
      decoration: InputDecoration(
        hintText: 'Type a message...',
        filled: true,
        fillColor: isDark ? Colors.grey[700] : Colors.green[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
      ),
    );
  }
}
