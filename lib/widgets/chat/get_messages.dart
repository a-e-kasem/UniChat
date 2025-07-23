import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:context_menu_android/features/context_menu/data/models/context_menu.dart';
import 'package:context_menu_android/features/context_menu/presentation/widget/ios_style_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uni_chat/widgets/chat/message_bubble.dart';
import 'package:uni_chat/widgets/chat/reply_message.dart';
import 'package:uni_chat/providers/chat_provider.dart';

class GetMessages extends StatelessWidget {
  final String chatId;
  final String currentUserId;

  const GetMessages(this.chatId, this.currentUserId, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('groups')
          .doc(chatId)
          .collection('messages')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading messages'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final data = messages[index].data() as Map<String, dynamic>;
            final senderId = data['senderId'] ?? '';
            final typeMessage = data['type'] ?? 'text';
            final message = data['message'] ?? '';
            final messageReply = data['replyMessageID'] ?? '';
            final imageUrl = data['imageUrl'] ?? '';
            final isMe = senderId == currentUserId;

            String time = '';
            if (data['time'] != null && data['time'] is Timestamp) {
              final timestamp = data['time'] as Timestamp;
              time = DateFormat('HH:mm').format(timestamp.toDate());
            }

            return Align(
              alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: isMe
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => IosStyleContextMenu(
                            actions: [
                              ContextMenuAndroid(
                                icon: FontAwesomeIcons.reply,
                                label: 'Reply',
                                onTap: () {
                                  log('Reply pressed');
                                  Provider.of<ReplyProvider>(
                                    context,
                                    listen: false,
                                  ).setReply(messages[index].id);
                                },
                              ),
                              ContextMenuAndroid(
                                icon: Icons.copy,
                                label: 'Copy',
                                onTap: () {
                                  log('Copy pressed');
                                  Clipboard.setData(
                                    new ClipboardData(text: message),
                                  );
                                },
                              ),
                              ContextMenuAndroid(
                                icon: Icons.delete,
                                label: 'Delete',
                                onTap: () {
                                  log('Delete pressed');
                                  FirebaseFirestore.instance
                                      .collection('groups')
                                      .doc(chatId)
                                      .collection('messages')
                                      .doc(messages[index].id)
                                      .delete();
                                },
                              ),
                            ],
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: isMe
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.end,
                                children: [
                                  if (!isMe)
                                    GestureDetector(
                                      onTap: () {
                                        log('Reply tapped');
                                        Provider.of<ReplyProvider>(
                                          context,
                                          listen: false,
                                        ).setReply(messages[index].id);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(7),
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                          color: isDark
                                              ? Colors.grey[700]
                                              : Colors.grey[300],
                                        ),
                                        child: Icon(
                                          FontAwesomeIcons.reply,
                                          size: 16,
                                          color: isDark
                                              ? Colors.grey[300]
                                              : Colors.grey[700],
                                        ),
                                      ),
                                    ),

                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: isMe
                                          ? (isDark
                                                ? Colors.blueAccent[700]
                                                : Colors.lightBlue[400])
                                          : (isDark
                                                ? Colors.grey[700]
                                                : Colors.grey[400]),
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
                                    child: Column(
                                      children: [
                                        messageReply != ''
                                            ? ReplyMessage(
                                                messageReply: messageReply,
                                                chatId: chatId,
                                                isMe: isMe,
                                                isDark: isDark,
                                                typeMessage: typeMessage,
                                                imageUrl: imageUrl,
                                              )
                                            : SizedBox(),
                                        MessageBubble(
                                          isMe: isMe,
                                          isDark: isDark,
                                          typeMessage: typeMessage,
                                          imageUrl: imageUrl,
                                          message: message,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: [
                          if (!isMe)
                            GestureDetector(
                              onTap: () {
                                log('Reply tapped');
                                Provider.of<ReplyProvider>(
                                  context,
                                  listen: false,
                                ).setReply(messages[index].id);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color: isDark
                                      ? Colors.grey[700]
                                      : Colors.grey[300],
                                ),
                                child: Icon(
                                  FontAwesomeIcons.reply,
                                  size: 16,
                                  color: isDark
                                      ? Colors.grey[300]
                                      : Colors.grey[700],
                                ),
                              ),
                            ),

                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? (isDark
                                        ? Colors.blueAccent[700]
                                        : Colors.lightBlue[400])
                                  : (isDark
                                        ? Colors.grey[700]
                                        : Colors.grey[400]),
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
                            child: Column(
                              children: [
                                messageReply != ''
                                    ? ReplyMessage(
                                        messageReply: messageReply,
                                        chatId: chatId,
                                        isMe: isMe,
                                        isDark: isDark,
                                        typeMessage: typeMessage,
                                        imageUrl: imageUrl,
                                      )
                                    : SizedBox(),
                                MessageBubble(
                                  isMe: isMe,
                                  isDark: isDark,
                                  typeMessage: typeMessage,
                                  imageUrl: imageUrl,
                                  message: message,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (time.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(time, style: const TextStyle(fontSize: 12)),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
