import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:UniChat/logic/cubits/replay_cubit/replay_message_cubit.dart';
import 'package:UniChat/presentation/widgets/chat/message_bubble.dart';
import 'package:UniChat/presentation/widgets/chat/reply_message.dart';

class GetMessages extends StatelessWidget {
  final String chatId;
  final String currentUserId;
  final bool showImageNameOfSenderOrNot;
  final Map<String, String> userImages;

  const GetMessages({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.showImageNameOfSenderOrNot,
    required this.userImages,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final openAllAccess = showImageNameOfSenderOrNot;

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
          controller: BlocProvider.of<ReplayMessageCubit>(
            context,
          ).scrollController,
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: isMe
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          if (!isMe &&
                              openAllAccess &&
                              data['senderName'] != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                data['senderName'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          GestureDetector(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  backgroundColor: Theme.of(context).cardColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Wrap(
                                          alignment: WrapAlignment.center,
                                          spacing: 12,
                                          children:
                                              [
                                                '❤️',
                                                '😂',
                                                '👍',
                                                '😢',
                                                '🔥',
                                              ].map((emoji) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    final userId = FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid;
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('groups')
                                                        .doc(chatId)
                                                        .collection('messages')
                                                        .doc(messages[index].id)
                                                        .update({
                                                          'reactions.$userId':
                                                              emoji,
                                                        });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    emoji,
                                                    style: const TextStyle(
                                                      fontSize: 30,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                        const Divider(height: 30),
                                        ListTile(
                                          leading: const Icon(
                                            FontAwesomeIcons.reply,
                                            size: 20,
                                          ),
                                          title: const Text('Reply'),
                                          onTap: () {
                                            context
                                                .read<ReplayMessageCubit>()
                                                .setReply(messages[index].id);
                                            Navigator.pop(ctx);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                            Icons.copy,
                                            size: 20,
                                          ),
                                          title: const Text('Copy'),
                                          onTap: () {
                                            Clipboard.setData(
                                              ClipboardData(text: message),
                                            );
                                            Navigator.pop(ctx);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                            Icons.delete,
                                            size: 20,
                                          ),
                                          title: const Text('Delete'),
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection('groups')
                                                .doc(chatId)
                                                .collection('messages')
                                                .doc(messages[index].id)
                                                .delete();
                                            Navigator.pop(ctx);
                                          },
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
                                      context
                                          .read<ReplayMessageCubit>()
                                          .setReply(messages[index].id);
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
                                      if (messageReply != '')
                                        ReplyMessage(
                                          messageReply: messageReply,
                                          chatId: chatId,
                                          isMe: isMe,
                                          isDark: isDark,
                                          typeMessage: typeMessage,
                                          imageUrl: imageUrl,
                                        ),
                                      MessageBubble(
                                        isMe: isMe,
                                        isDark: isDark,
                                        typeMessage: typeMessage,
                                        imageUrl: imageUrl,
                                        message: message,
                                        reactions:
                                            data['reactions']
                                                as Map<String, dynamic>?,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (time.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Text(
                                time,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (!isMe && openAllAccess)
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 16),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(
                            userImages[senderId] ??
                                'https://i.pinimg.com/736x/0f/68/94/0f6894e539589a50809e45833c8bb6c4.jpg',
                          ),
                        ),
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
