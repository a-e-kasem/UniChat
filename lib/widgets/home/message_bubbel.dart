import 'package:flutter/material.dart';

class MessageBubbel extends StatelessWidget {
  const MessageBubbel({super.key, required this.isDark, required this.message});

  final Map<String, String> message;
  final bool isDark;
  @override
  Widget build(BuildContext context) {
    String sender = message['sender']!;
    String msg = message['message']!;
    return Align(
      alignment: sender == 'me' ? Alignment.centerLeft : Alignment.centerRight,
      child: SizedBox(
        width: 300,
        child: Align(
          alignment: sender == 'me'
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
              color: isDark
                  ? sender == 'me'
                        ? Color(0xFF262C32)
                        : Color(0xFF2A6AC6)
                  : sender == 'me'
                  ? Color(0xFFF1EBE5)
                  : Color(0xFF4B8BE0),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: sender == 'me' ? Radius.circular(20) : Radius.zero,
                bottomLeft: sender == 'me' ? Radius.zero : Radius.circular(20),
              ),
            ),

            child: Text(msg),
          ),
        ),
      ),
    );
  }
}
